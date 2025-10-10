CREATE TABLE IF NOT EXISTS app_users (
    id uuid PRIMARY KEY DEFAULT auth.uid (),
    email text UNIQUE,
    display_name text,
    created_at timestamptz DEFAULT now()
);