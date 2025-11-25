// File: lib/screens/profile/profile_page.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import '../../database/database.dart';
import '../../services/supabase_service.dart';

class ProfilePage extends StatefulWidget {
  final AppDatabase database;

  const ProfilePage({
    super.key,
    required this.database,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final SupabaseService _supabaseService;
  final _picker = ImagePicker();

  String _userName = '';
  String _userEmail = '';
  String? _avatarUrl;
  File? _localImageFile;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _supabaseService = SupabaseService(widget.database);
    _loadUserProfile();

    Supabase.instance.client.auth.onAuthStateChange.listen((_) {
      if (mounted) _loadUserProfile();
    });
  }

  void _loadUserProfile() {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      setState(() {
        _userName = user.userMetadata?['name'] ?? '';
        _userEmail = user.email ?? '';
        _avatarUrl = user.userMetadata?['avatar_url'];
      });
    } else {
      setState(() {
        _userName = '';
        _userEmail = '';
        _avatarUrl = null;
      });
    }
  }

  Future<void> _handleImagePicking(ImageSource source) async {
    final XFile? picked = await _picker.pickImage(
      source: source,
      imageQuality: 70,
    );

    if (picked == null) return;

    final file = File(picked.path);
    setState(() => _localImageFile = file);

    try {
      setState(() => _isUploading = true);

      final url = await _supabaseService.uploadProfileImage(file);

      if (mounted) {
        if (url != null && url.isNotEmpty) {
          setState(() {
            _avatarUrl = url;
            _localImageFile = null;
          });
        }
        setState(() => _isUploading = false);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Foto profil berhasil diperbarui!')),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isUploading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal upload foto: $e')),
        );
      }
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Kamera'),
                onTap: () {
                  Navigator.pop(context);
                  _handleImagePicking(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Galeri'),
                onTap: () {
                  Navigator.pop(context);
                  _handleImagePicking(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showLogoutConfirmationDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: const Text('Keluar Akun'),
        content: const Text('Apakah Anda yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );

    if (result == true) {
      await _supabaseService.signOut(); // <-- pakai signOut() yang benar
    }
  }

  Widget _buildAvatar() {
    if (_localImageFile != null) {
      return CircleAvatar(
        radius: 50,
        backgroundImage: FileImage(_localImageFile!),
      );
    }

    if (_avatarUrl != null && _avatarUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: 50,
        backgroundImage: NetworkImage(_avatarUrl!),
        onBackgroundImageError: (_, __) => setState(() => _avatarUrl = null),
      );
    }

    return const CircleAvatar(
      radius: 50,
      child: Icon(Icons.person, size: 50),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (ModalRoute.of(context)?.isCurrent == true) {
      _loadUserProfile();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya'),
        backgroundColor: Colors.white,
        elevation: 0.3,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Center(child: _buildAvatar()),
            if (_isUploading)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ),
            TextButton(
              onPressed: _showImageSourceDialog,
              child: const Text('Edit Foto Profil'),
            ),
            const SizedBox(height: 24),

            // --- Nama ---
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text("Nama"),
              subtitle: Text(_userName.isNotEmpty ? _userName : "Belum diatur"),
              onTap: () async {
                await context.push('/edit-name');
                _loadUserProfile();
              },
            ),

            // --- Email ---
            ListTile(
              leading: const Icon(Icons.email_outlined),
              title: const Text("Email"),
              subtitle: Text(_userEmail),
              onTap: () async {
                await context.push('/edit-email');
                _loadUserProfile();
              },
            ),

            const SizedBox(height: 50),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _showLogoutConfirmationDialog,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.brown,
                ),
                child: const Text(
                  "Keluar Akun",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
