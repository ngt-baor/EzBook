# EzBook free cloud deployment checklist

EzBook is a Maven `war` application that runs on Tomcat and now targets a Supabase PostgreSQL database.

Deploy it as two free resources:

1. Java/Tomcat web app on Render Free Web Service
2. PostgreSQL database on Supabase Free

## Current deployment target

- App: Render Free Web Service with Docker
- Database: Supabase PostgreSQL
- Domain: free Render subdomain, for example `https://ezbook.onrender.com`

Render deploys from GitHub using:

```text
Dockerfile
render.yaml
```

## Required Supabase environment variables

Set these in Render service environment variables:

```text
EZBOOK_DB_HOST=<supabase-db-host>
EZBOOK_DB_PORT=5432
EZBOOK_DB_NAME=postgres
EZBOOK_DB_USER=postgres
EZBOOK_DB_PASSWORD=<supabase-database-password>
EZBOOK_DB_SSL_MODE=require
```

You can also use a full JDBC URL instead:

```text
EZBOOK_DB_URL=jdbc:postgresql://<supabase-db-host>:5432/postgres?sslmode=require
EZBOOK_DB_USER=postgres
EZBOOK_DB_PASSWORD=<supabase-database-password>
```

Do not commit real passwords or API keys to Git.

## Where to get Supabase values

In Supabase:

1. Open the project.
2. Click `Connect`.
3. Choose Java/JDBC or connection string details.
4. Copy the host, database name, username, and password into Render env vars.

Use the direct/session pooler value recommended by Supabase for server-side apps.

## Required mail environment variables

The OTP email feature also needs SMTP settings:

```text
EZBOOK_MAIL_USERNAME=<gmail-address>
EZBOOK_MAIL_APP_PASSWORD=<gmail-app-password>
```

Render Free may block outbound SMTP ports such as 587. If OTP mail fails on Render, replace Gmail SMTP with an HTTP email provider such as Resend or SendGrid.

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

1. Open the Render URL.
2. Test login with the sample accounts.
3. Test one DB-backed page for each role:
   - Admin dashboard
   - Staff dashboard
   - Customer dashboard
4. Test one write flow:
   - Customer booking, or
   - Admin/staff edit flow
5. Check Render logs for database connection or query errors.
