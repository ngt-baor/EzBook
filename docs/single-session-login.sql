-- EzBook single active login session support.
-- Safe to run more than once on Supabase/PostgreSQL.

ALTER TABLE TaiKhoan
    ADD COLUMN IF NOT EXISTS current_session_token VARCHAR(255);
