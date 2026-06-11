package com.example.ezbook.util;

import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public class MailService {
    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final String SMTP_PORT = "587";

    public void sendVerificationCode(String toEmail, String code, String purpose) throws MessagingException {
        Properties localConfig = loadLocalConfig();
        String username = firstNonBlank(
                System.getProperty("ezbook.mail.username"),
                System.getenv("EZBOOK_MAIL_USERNAME"),
                localConfig.getProperty("ezbook.mail.username")
        );
        String appPassword = firstNonBlank(
                System.getProperty("ezbook.mail.appPassword"),
                System.getenv("EZBOOK_MAIL_APP_PASSWORD"),
                localConfig.getProperty("ezbook.mail.appPassword")
        );

        if (isBlank(username) || isBlank(appPassword)) {
            throw new MessagingException("Missing EZBook Gmail SMTP configuration");
        }

        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", SMTP_HOST);
        props.put("mail.smtp.port", SMTP_PORT);

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(username, appPassword);
            }
        });

        Message message = new MimeMessage(session);
        message.setFrom(new InternetAddress(username));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
        message.setSubject("Ma xac nhan EZBook");
        message.setText("Ma xac nhan EZBook cho " + purpose + " la: " + code
                + "\nMa nay chi dung cho thao tac ban vua yeu cau.");

        Transport.send(message);
    }

    private Properties loadLocalConfig() {
        Properties properties = new Properties();
        try (InputStream input = getClass().getClassLoader().getResourceAsStream("ezbook-mail.properties")) {
            if (input != null) {
                properties.load(input);
            }
        } catch (IOException ignored) {
        }
        return properties;
    }

    private String firstNonBlank(String... values) {
        if (values == null) {
            return null;
        }
        for (String value : values) {
            if (!isBlank(value)) {
                return value;
            }
        }
        return null;
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}
