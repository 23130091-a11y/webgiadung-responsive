package com.webgiadung.webgiadung.controller;

import com.webgiadung.webgiadung.dao.AuthDao;
import com.webgiadung.webgiadung.dao.TokenForgetPasswordDAO;
import com.webgiadung.webgiadung.model.TokenForgetPassword;
import com.webgiadung.webgiadung.model.User;
import com.webgiadung.webgiadung.services.ResetService;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;

@WebServlet("/requestPassword")
public class requestPassword extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/requestPassword.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        AuthDao authDao = new AuthDao();
        User user = authDao.getUserByEmail(email);
        HttpSession session = request.getSession();
        if(user == null) {
            request.setAttribute("message", "email không tồn tại");
            request.getRequestDispatcher("/requestPassword.jsp").forward(request, response);
            return;
        }

        // send link email
        // tạo token mới
        ResetService resetService = new ResetService();
        String token = resetService.generateToken();
//        String linkReset = "http://localhost" + request.getContextPath() + "/resetPassword?token=" + token;
        String linkReset =
                request.getScheme()
                        + "://"
                        + request.getServerName()
                        + ":"
                        + request.getServerPort()
                        + request.getContextPath()
                        + "/resetPassword?token="
                        + token;
        // insert token này vào bảng và chưa sài
        TokenForgetPassword tokenForgetPassword = new TokenForgetPassword(token, resetService.expireDate(), false, user.getId());
        TokenForgetPasswordDAO forgetPasswordDAO = new TokenForgetPasswordDAO();
        int result = forgetPasswordDAO.insert(tokenForgetPassword);

        if(result <= 0) {
            request.setAttribute("message",
                    "Có lỗi server");

            request.getRequestDispatcher("/requestPassword.jsp").forward(request, response);
            return;
        }

        boolean isSent = resetService.sendEmail(email, linkReset, user.getName());

        if (isSent) {
            session.setAttribute(
                    "success",
                    "Vui lòng kiểm tra email để đặt lại mật khẩu."
            );

            response.sendRedirect(
                    request.getContextPath() + "/requestPassword"
            );
            return;
        }

        request.setAttribute("message",
                "Không thể gửi email. Vui lòng thử lại.");

        request.getRequestDispatcher("/requestPassword.jsp")
                .forward(request, response);
    }
}