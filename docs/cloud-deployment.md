# EzBook cloud deployment checklist

EzBook is a Maven `war` application that runs on Tomcat and uses SQL Server.
Deploy it as two cloud resources:

1. Java/Tomcat web app
2. SQL Server database

## Recommended cloud target

Use Azure for the first production deployment:

- App: Azure App Service, Java 17, Tomcat 10.1
- Database: Azure SQL Database
- Domain: custom domain mapped to Azure App Service

This keeps the current SQL Server database script compatible with the smallest amount of code change.

## Free deployment target

For a free public demo, use:

- App: Render Free Web Service with Docker
- Database: Azure SQL Database free offer
- Domain: free Render subdomain, for example `https://ezbook.onrender.com`

This is the lowest-change free path for the current Java/Tomcat + SQL Server project.
A paid custom domain such as `.com`, `.dev`, or `.site` is separate from hosting and usually requires buying the domain from a registrar.

Render gives every web service an `onrender.com` subdomain. The project includes:

```text
Dockerfile
render.yaml
```

Render should deploy the app from GitHub using the Docker runtime and the free instance plan.

## Required database environment variables

Set these in the cloud app settings:

```text
EZBOOK_DB_HOST=<your-sql-server>.database.windows.net
EZBOOK_DB_PORT=1433
EZBOOK_DB_NAME=EZBookDB
EZBOOK_DB_USER=<sql-admin-user>
EZBOOK_DB_PASSWORD=<sql-admin-password>
EZBOOK_DB_ENCRYPT=true
EZBOOK_DB_TRUST_SERVER_CERTIFICATE=false
```

If the provider gives a full JDBC connection string, use this instead:

```text
EZBOOK_DB_URL=jdbc:sqlserver://<your-sql-server>.database.windows.net:1433;databaseName=EZBookDB;encrypt=true;trustServerCertificate=false;hostNameInCertificate=*.database.windows.net;loginTimeout=30;
EZBOOK_DB_USER=<sql-admin-user>
EZBOOK_DB_PASSWORD=<sql-admin-password>
```

## Required mail environment variables

The OTP email feature also needs SMTP settings:

```text
EZBOOK_MAIL_USERNAME=<gmail-address>
EZBOOK_MAIL_APP_PASSWORD=<gmail-app-password>
```

Do not commit real passwords or API keys to Git.

## Database setup

The local database script is:

```text
C:\Users\Bao\Documents\SQL Server Management Studio\EZBookDB.sql
```

For Azure SQL:

1. Create the Azure SQL server.
2. Create database `EZBookDB`.
3. Open SSMS or Azure Data Studio and connect to the created `EZBookDB` database.
4. Run the schema/data part of the script against `EZBookDB`.
5. Do not run destructive local-only setup lines against an existing production database unless you intentionally want to wipe it:
   - `DROP DATABASE`
   - `CREATE DATABASE`
   - `ALTER DATABASE ... SINGLE_USER`

## Build verification

From the EzBook project root:

```powershell
.\mvnw.cmd clean package
```

Expected output:

```text
BUILD SUCCESS
```

The WAR artifact should be generated under:

```text
target\EzBook-1.0-SNAPSHOT.war
```

## Deployment verification

After deploying:

1. Open the default cloud URL.
2. Test login with the sample accounts.
3. Test one DB-backed page for each role:
   - Admin dashboard
   - Staff dashboard
   - Customer dashboard
4. Test one write flow:
   - Customer booking, or
   - Admin/staff edit flow
5. Add the custom domain.
6. Verify the custom domain over HTTPS.
