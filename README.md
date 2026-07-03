# EzBook

EzBook là hệ thống đặt lịch dịch vụ, quản lý booking và quản lý vận hành salon/spa theo mô hình Java Servlet/JSP. Dự án hỗ trợ khách hàng đặt lịch online, nhân viên xử lý booking, và admin quản lý tài khoản, dịch vụ, khuyến mãi, hóa đơn và thống kê.

## Built With

![Java](https://img.shields.io/badge/Java-17-orange?style=for-the-badge&logo=openjdk)
![Jakarta Servlet](https://img.shields.io/badge/Jakarta%20Servlet-6.1-blue?style=for-the-badge)
![JSP](https://img.shields.io/badge/JSP-Java%20Server%20Pages-green?style=for-the-badge)
![JSTL](https://img.shields.io/badge/JSTL-3.0-purple?style=for-the-badge)
![Maven](https://img.shields.io/badge/Maven-Build-red?style=for-the-badge&logo=apachemaven)
![SQL Server](https://img.shields.io/badge/SQL%20Server-Database-darkred?style=for-the-badge&logo=microsoftsqlserver)
![Tomcat](https://img.shields.io/badge/Tomcat-10.1-yellow?style=for-the-badge&logo=apachetomcat&logoColor=black)
![Jakarta Mail](https://img.shields.io/badge/Jakarta%20Mail-SMTP-009688?style=for-the-badge)

## Project Overview

EzBook phục vụ 3 nhóm người dùng chính:

- `USER`: khách hàng đăng ký, đăng nhập, đặt lịch online, xem lịch đã đặt, hủy lịch hợp lệ, cập nhật hồ sơ và đổi mật khẩu.
- `STAFF`: xem và xử lý booking, quản lý hóa đơn, theo dõi thống kê cơ bản.
- `ADMIN`: toàn quyền với tài khoản, dịch vụ, khuyến mãi, hóa đơn, thống kê và trạng thái tài khoản.

## Main Features

- Đăng nhập và phân quyền theo vai trò `ADMIN`, `STAFF`, `USER`
- Đăng ký khách hàng bằng OTP Gmail
- Quên mật khẩu bằng OTP Gmail
- Đổi mật khẩu bằng OTP Gmail
- Cập nhật hồ sơ cá nhân
- Booking online cho khách hàng
- Quản lý booking cho nhân viên và admin
- Quản lý tài khoản người dùng
- CRUD loại dịch vụ và dịch vụ
- CRUD khuyến mãi
- CRUD hóa đơn và xác nhận thanh toán
- Thống kê doanh thu và top dịch vụ

## Main Workflows

### 1. Đăng ký tài khoản khách hàng

1. Người dùng nhập họ tên, số điện thoại, Gmail và mật khẩu.
2. Hệ thống gửi mã OTP về Gmail.
3. Người dùng nhập mã xác nhận.
4. Nếu mã hợp lệ, hệ thống tạo tài khoản khách hàng mới.

### 2. Quên mật khẩu

1. Người dùng nhập Gmail đã đăng ký.
2. Hệ thống gửi mã OTP về Gmail.
3. Người dùng nhập mã xác nhận và mật khẩu mới.
4. Nếu mã đúng, hệ thống cập nhật mật khẩu.

### 3. Đổi mật khẩu

1. Người dùng đã đăng nhập nhập mật khẩu cũ và Gmail nhận mã.
2. Hệ thống gửi mã OTP về Gmail của tài khoản hiện tại.
3. Người dùng nhập mã xác nhận và mật khẩu mới.
4. Nếu mã đúng và mật khẩu cũ hợp lệ, hệ thống đổi mật khẩu thành công.

### 4. Booking online

1. Khách hàng đăng nhập và truy cập trang đặt lịch.
2. Chọn dịch vụ, thời gian và thông tin liên quan.
3. Hệ thống kiểm tra dữ liệu đầu vào, trạng thái dịch vụ và xung đột lịch.
4. Booking được tạo với trạng thái chờ xử lý.

### 5. Xử lý vận hành

1. Nhân viên/admin xem danh sách booking.
2. Cập nhật trạng thái booking và xử lý hóa đơn.
3. Admin quản lý dịch vụ, khuyến mãi, tài khoản và thống kê.

## Project Structure

```text
EzBook/
├── src/main/java/com/example/ezbook/
│   ├── controller/        # Servlet xử lý request
│   ├── repository/        # Truy vấn và thao tác SQL Server
│   ├── entity/            # Entity/DTO
│   ├── filter/            # Filter phân quyền
│   └── util/              # DBConnect, MailService, tiện ích chung
├── src/main/resources/    # File cấu hình local không đưa lên git
├── src/main/webapp/       # JSP, CSS, assets, view
├── .mvn/                  # Maven wrapper
├── pom.xml
├── mvnw
└── mvnw.cmd
```

## Getting Started

### Prerequisites

- JDK 17
- Apache Tomcat 10.1.x
- SQL Server
- IntelliJ IDEA hoặc IDE hỗ trợ Maven Web App

### Clone Project

```bash
git clone https://github.com/<your-username>/EzBook.git
cd EzBook
```

### Import Project

1. Mở project bằng IntelliJ IDEA.
2. Import như Maven project.
3. Cấu hình Tomcat với artifact `EzBook:war exploded`.
4. Chạy ứng dụng với context path đang dùng trong IDE của bạn.

### Build Project

```bash
./mvnw clean compile
```

Trên Windows:

```powershell
.\mvnw.cmd clean compile
```

## Database Configuration

Project hiện kết nối SQL Server qua lớp [DBConnect.java](src/main/java/com/example/ezbook/util/DBConnect.java). Mặc định code đang dùng:

- Host: `localhost`
- Port: `1433`
- Database: `EZBookDB`
- Username: `sa`

Bạn cần chỉnh lại thông tin kết nối trong `DBConnect` cho phù hợp với máy của mình trước khi chạy.

## Sample Database

Database mẫu để test project:

- Google Drive: [EZBook Sample Database](https://drive.google.com/file/d/1Qvhy7URHr_NNQoohw9AlQXrXzOKZMH6B/view?usp=sharing)

Sau khi tải về:

1. Mở SQL Server Management Studio
2. Import hoặc chạy script database mẫu
3. Đảm bảo tên database khớp với cấu hình hiện tại trong `DBConnect.java`

Nếu database bạn import có tên khác `EZBookDB`, hãy cập nhật lại cấu hình kết nối trong `DBConnect`.

## Gmail SMTP Configuration

Tính năng OTP Gmail hiện dùng `smtp.gmail.com:587` với STARTTLS qua [MailService.java](src/main/java/com/example/ezbook/util/MailService.java).

`MailService` đọc cấu hình theo thứ tự:

1. Java system properties
2. Environment variables
3. File local `src/main/resources/ezbook-mail.properties`

File mẫu đã được đưa lên repo:

```properties
src/main/resources/ezbook-mail.example.properties
```

Bạn cần tự tạo file local `src/main/resources/ezbook-mail.properties` từ file mẫu đó.

Ví dụ:

```properties
ezbook.mail.username=your_email@gmail.com
ezbook.mail.appPassword=your_app_password
```

Lưu ý:

- File `src/main/resources/ezbook-mail.properties` đã được đưa vào `.gitignore`
- File `src/main/resources/ezbook-mail.example.properties` có thể push lên GitHub vì chỉ chứa placeholder
- Không commit app password lên GitHub
- Cần bật xác thực 2 bước cho Gmail trước khi tạo App Password

## Security Notes

- Không lưu Gmail app password trong source code public
- Không đẩy file chứa secret lên GitHub
- Nên chuyển phần cấu hình DB và SMTP sang biến môi trường hoặc file local riêng khi triển khai thực tế

## Screenshots

Toàn bộ ảnh giao diện mới được lưu tại [`docs/screenshots/ezbook-ui-showcase`](docs/screenshots/ezbook-ui-showcase).

### Public and authentication

#### Landing page

![EZBook landing page](docs/screenshots/ezbook-ui-showcase/01-landing.png)

#### Admin and staff login

![Admin and staff login](docs/screenshots/ezbook-ui-showcase/02-admin-staff-login.png)

#### Customer login

![Customer login](docs/screenshots/ezbook-ui-showcase/03-customer-login.png)

#### Customer registration with Gmail OTP

![Customer registration with Gmail OTP](docs/screenshots/ezbook-ui-showcase/04-customer-registration.png)

#### Forgot password

![Forgot password](docs/screenshots/ezbook-ui-showcase/05-forgot-password.png)

### Admin functions

#### Admin dashboard

![Admin dashboard](docs/screenshots/ezbook-ui-showcase/06-admin-dashboard.png)

#### Staff management

![Staff management](docs/screenshots/ezbook-ui-showcase/07-staff-management.png)

#### Staff edit

![Staff edit](docs/screenshots/ezbook-ui-showcase/08-staff-edit.png)

#### Account management

![Account management](docs/screenshots/ezbook-ui-showcase/09-account-management.png)

#### Service management

![Service management](docs/screenshots/ezbook-ui-showcase/10-service-management.png)

#### Promotion management

![Promotion management](docs/screenshots/ezbook-ui-showcase/11-promotion-management.png)

#### Booking management

![Booking management](docs/screenshots/ezbook-ui-showcase/12-booking-management.png)

#### Invoice management

![Invoice management](docs/screenshots/ezbook-ui-showcase/13-invoice-management.png)

#### Statistics dashboard

![Statistics dashboard](docs/screenshots/ezbook-ui-showcase/14-statistics-dashboard.png)

#### Admin profile

![Admin profile](docs/screenshots/ezbook-ui-showcase/15-admin-profile.png)

### Staff functions

#### Staff dashboard

![Staff dashboard](docs/screenshots/ezbook-ui-showcase/16-staff-dashboard.png)

### Customer functions

#### Customer dashboard

![Customer dashboard](docs/screenshots/ezbook-ui-showcase/17-customer-dashboard.png)

#### Customer online booking

![Customer online booking](docs/screenshots/ezbook-ui-showcase/18-customer-online-booking.png)

#### Customer profile

![Customer profile](docs/screenshots/ezbook-ui-showcase/19-customer-profile.png)

## Future Improvements

- Hỗ trợ đặt nhiều dịch vụ trong một booking
- Thêm email template HTML đẹp hơn cho OTP
- Mã hóa mật khẩu thay vì lưu plain text
- Tách cấu hình DB/mail khỏi source code
- Thêm test cho repository và servlet
- Hoàn thiện validation lịch trống và xung đột booking

## Author

- GitHub: [Baor-05](https://github.com/Baor-05)
