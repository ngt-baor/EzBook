USE EZBookDB;
GO

BEGIN TRANSACTION;

-- =========================================================
-- STAFF 03
-- =========================================================
IF NOT EXISTS (SELECT 1 FROM TaiKhoan WHERE username = 'staff03')
BEGIN
    INSERT INTO TaiKhoan (username, mat_khau, vai_tro, trang_thai, avatar, ma_xac_nhan)
    VALUES ('staff03', '123456', 'STAFF', 1, NULL, NULL);
END
ELSE
BEGIN
    UPDATE TaiKhoan
    SET mat_khau = '123456',
        vai_tro = 'STAFF',
        trang_thai = 1
    WHERE username = 'staff03';
END

IF NOT EXISTS (SELECT 1 FROM NhanVien WHERE username = 'staff03')
BEGIN
    DECLARE @idStaff03 VARCHAR(50) = 'NV' + RIGHT(CONVERT(VARCHAR(20), ABS(CHECKSUM(NEWID()))), 6);
    WHILE EXISTS (SELECT 1 FROM NhanVien WHERE id = @idStaff03)
    BEGIN
        SET @idStaff03 = 'NV' + RIGHT(CONVERT(VARCHAR(20), ABS(CHECKSUM(NEWID()))), 6);
    END

    INSERT INTO NhanVien (id, ho_ten, sdt, vai_tro, trang_thai, username)
    VALUES (@idStaff03, N'Le Tuan Nam', '0961000001', N'Nhan vien Ky thuat', 1, 'staff03');
END
ELSE
BEGIN
    UPDATE NhanVien
    SET ho_ten = N'Le Tuan Nam',
        sdt = '0961000001',
        vai_tro = N'Nhan vien Ky thuat',
        trang_thai = 1
    WHERE username = 'staff03';
END

-- =========================================================
-- STAFF 04
-- =========================================================
IF NOT EXISTS (SELECT 1 FROM TaiKhoan WHERE username = 'staff04')
BEGIN
    INSERT INTO TaiKhoan (username, mat_khau, vai_tro, trang_thai, avatar, ma_xac_nhan)
    VALUES ('staff04', '123456', 'STAFF', 1, NULL, NULL);
END
ELSE
BEGIN
    UPDATE TaiKhoan
    SET mat_khau = '123456',
        vai_tro = 'STAFF',
        trang_thai = 1
    WHERE username = 'staff04';
END

IF NOT EXISTS (SELECT 1 FROM NhanVien WHERE username = 'staff04')
BEGIN
    DECLARE @idStaff04 VARCHAR(50) = 'NV' + RIGHT(CONVERT(VARCHAR(20), ABS(CHECKSUM(NEWID()))), 6);
    WHILE EXISTS (SELECT 1 FROM NhanVien WHERE id = @idStaff04)
    BEGIN
        SET @idStaff04 = 'NV' + RIGHT(CONVERT(VARCHAR(20), ABS(CHECKSUM(NEWID()))), 6);
    END

    INSERT INTO NhanVien (id, ho_ten, sdt, vai_tro, trang_thai, username)
    VALUES (@idStaff04, N'Pham Khanh Linh', '0961000002', N'Tiep tan', 1, 'staff04');
END
ELSE
BEGIN
    UPDATE NhanVien
    SET ho_ten = N'Pham Khanh Linh',
        sdt = '0961000002',
        vai_tro = N'Tiep tan',
        trang_thai = 1
    WHERE username = 'staff04';
END

COMMIT TRANSACTION;
GO

SELECT tk.username, tk.vai_tro, tk.trang_thai, nv.id, nv.ho_ten, nv.sdt, nv.vai_tro AS nv_vai_tro
FROM TaiKhoan tk
JOIN NhanVien nv ON nv.username = tk.username
WHERE tk.username IN ('staff03', 'staff04');
GO
