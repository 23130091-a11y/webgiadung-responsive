package com.webgiadung.webgiadung.services;

import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

import java.io.UnsupportedEncodingException;
import java.time.LocalDateTime;
import java.util.Properties;
import java.util.UUID;

public class ResetService {
    private final int LIMIT_MINUS = 10;

    private static final String MY_EMAIL = "nguyenthihonghanh5098@gmail.com";
    private static final String MY_PASSWORD = "nyft fikb wdch tybw";

    public String generateToken() {
        return UUID.randomUUID().toString();
    }

    public LocalDateTime expireDate() {
        return LocalDateTime.now().plusMinutes(LIMIT_MINUS);
    }

    // check token hết hạn chưa
    public boolean isExpireDate(LocalDateTime localDateTime) {
        return LocalDateTime.now().isAfter(localDateTime);
    }

    // send email
    public boolean sendEmail(String to, String link, String name) {
        Properties properties = new Properties();
        properties.put("mail.smtp.host", "smtp.gmail.com"); // địa chỉ máy chủ
        properties.put("mail.smtp.port", "587");
        properties.put("mail.smtp.auth", "true");
        properties.put("mail.smtp.starttls.enable", "true");

        Authenticator authenticator = new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(MY_EMAIL, MY_PASSWORD);
            }
        };

        // lưu trữ phiên gửi email
        Session session = Session.getInstance(properties, authenticator);

        // nội dung
        MimeMessage mimeMessage = new MimeMessage(session);
        try {
            mimeMessage.addHeader("Content-type", "text/html; charset=UTF-8");
            mimeMessage.setFrom(new InternetAddress(MY_EMAIL, "WebGiaDung Support"));
            // thiết lập địa chỉ email của người nhận
            mimeMessage.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to, false));

            mimeMessage.setSubject("Đặt lại mật khẩu tài khoản", "UTF-8");
            String content = """
    <html>
    <body style="font-family: Arial, sans-serif; color: #333;">
        <h2>Yêu cầu đặt lại mật khẩu</h2>
        <p>Xin chào <strong>%s</strong>,</p>
        <p>Chúng tôi đã nhận được yêu cầu đặt lại mật khẩu cho tài khoản của bạn.</p>
        <p>Vui lòng nhấn vào nút bên dưới để tạo mật khẩu mới:</p>
        <p style="margin: 30px 0;">
            <a href="%s"
               style="
                   background-color: #007bff;
                   color: white;
                   padding: 12px 24px;
                   text-decoration: none;
                   border-radius: 5px;
                   display: inline-block;">
                Đặt lại mật khẩu
            </a>
        </p>
        <p><strong>Lưu ý:</strong> Liên kết này sẽ hết hạn sau 10 phút và chỉ được sử dụng một lần.</p>
        <p>Nếu bạn không thực hiện yêu cầu này, vui lòng bỏ qua email này. Mật khẩu hiện tại của bạn sẽ không bị thay đổi.</p>
        <br>
        <p>Trân trọng,<br>
        WebGiaDung Support</p>
    </body>
    </html>
    """.formatted(name, link);

            mimeMessage.setContent(content, "text/html; charset=UTF-8");
            // thực hiện gửi
            Transport.send(mimeMessage);
            System.out.println("Send successfully");
            return true;
        } catch (MessagingException e) {
            System.out.println("Send error");
            System.out.println(e.getMessage());
            return false;
        } catch (UnsupportedEncodingException e) {
            throw new RuntimeException(e);
        }
    }
}
