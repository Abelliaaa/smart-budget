import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class UserService {
  final SupabaseClient _supabase;

  UserService(this._supabase);

  String? get currentUserId => _supabase.auth.currentUser?.id;

  // --- GETTERS (Mengambil Data dari Supabase Auth Metadata) ---

  String getUserName() {
    // Mengambil 'name' dari user_metadata. Default: 'Pengguna Smart Budget'
    return _supabase.auth.currentUser?.userMetadata?['name'] as String? ?? 'Pengguna Smart Budget';
  }
  
  String getUserEmail() {
    return _supabase.auth.currentUser?.email ?? 'Email Tidak Tersedia';
  }
  
  String? getProfilePicturePath() {
    // Mengambil path lokal foto profil yang disimpan di user_metadata
    return _supabase.auth.currentUser?.userMetadata?['avatar_path'] as String?;
  }

  // --- UPDATERS (Memperbarui Data) ---

  // 1. Menyimpan file gambar secara lokal dan mengembalikan path
  Future<String> saveLocalProfilePicture(File imageFile) async {
    if (currentUserId == null) throw Exception("User not logged in");
    
    final appDir = await getApplicationDocumentsDirectory();
    final fileName = 'profile_${currentUserId!}.jpg';
    final localPath = p.join(appDir.path, fileName);
    
    // Menyalin file ke lokasi permanen di direktori aplikasi
    await imageFile.copy(localPath);
    return localPath;
  }
  
  // 2. Menyimpan path gambar lokal ke Supabase metadata
  Future<void> updateProfilePicturePath(String path) async {
      await _supabase.auth.updateUser(
        UserAttributes(
          data: {'avatar_path': path},
        ),
      );
  }
  
  // 3. Memperbarui nama pengguna
  Future<void> updateUserName(String newName) async {
    await _supabase.auth.updateUser(
      UserAttributes(
        data: {'name': newName},
      ),
    );
  }

  // 4. Memperbarui email pengguna
  Future<void> updateUserEmail(String newEmail) async {
    await _supabase.auth.updateUser(
      UserAttributes(
        email: newEmail,
      ),
    );
  }

  // 5. Logout
  Future<void> logout() async {
    await _supabase.auth.signOut();
  }
}