USE EZBookDB;
GO

BEGIN TRANSACTION;

IF NOT EXISTS (SELECT 1 FROM TaiKhoan WHERE username = 'admin')
BEGIN
    INSERT INTO TaiKhoan (username, mat_khau, vai_tro, trang_thai, avatar, ma_xac_nhan)
    VALUES ('admin', '123456', 'ADMIN', 1, NULL, NULL);
END
ELSE
BEGIN
    UPDATE TaiKhoan
    SET mat_khau = '123456',
        vai_tro = 'ADMIN',
        trang_thai = 1
    WHERE username = 'admin';
END

IF NOT EXISTS (SELECT 1 FROM NhanVien WHERE username = 'admin')
BEGIN
    DECLARE @newId VARCHAR(50) = 'NVADMIN';

    IF EXISTS (SELECT 1 FROM NhanVien WHERE id = @newId)
    BEGIN
        SET @newId = 'NV' + RIGHT(CONVERT(VARCHAR(20), ABS(CHECKSUM(NEWID()))), 6);
    END

    INSERT INTO NhanVien (id, ho_ten, sdt, vai_tro, trang_thai, username)
    VALUES (@newId, N'Quản trị hệ thống', '0900000000', N'Quản lý', 1, 'admin');
END
ELSE
BEGIN
    UPDATE NhanVien
    SET trang_thai = 1
    WHERE username = 'admin';
END

COMMIT TRANSACTION;
GO

SELECT username, vai_tro, trang_thai
FROM TaiKhoan
WHERE username = 'admin';
GO
