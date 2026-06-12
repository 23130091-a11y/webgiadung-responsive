package com.webgiadung.webgiadung.controller;

import com.webgiadung.webgiadung.dao.AuthDao;
import com.webgiadung.webgiadung.dao.TokenForgetPasswordDAO;
import com.webgiadung.webgiadung.model.TokenForgetPassword;
import com.webgiadung.webgiadung.model.User;
import com.webgiadung.webgiadung.services.EmailService;
import com.webgiadung.webgiadung.services.ResetService;
import com.webgiadung.webgiadung.utils.SecurityUtils;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;

@WebServlet("/resetPassword")
public class resetPassword extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String token = request.getParameter("token");
        TokenForgetPasswordDAO passwordDAO = new TokenForgetPasswordDAO();
        ResetService resetService = new ResetService();
        AuthDao authDao = new AuthDao();

        HttpSession session = request.getSession();
        if(token != null) {
            TokenForgetPassword tokenForgetPassword = passwordDAO.getTokenPassword(token);
            if(tokenForgetPassword == null) {
                request.setAttribute("message", "token invalid");
                request.getRequestDispatcher("/requestPassword.jsp").forward(request, response);
                return;
            }

            if(tokenForgetPassword.isUsed()) {
                request.setAttribute("message", "token is used");
                request.getRequestDispatcher("/requestPassword.jsp").forward(request, response);
                return;
            }

            if(resetService.isExpireDate(tokenForgetPassword.getExpiryTime())) {
                request.setAttribute("message", "token is expiry time");
                request.getRequestDispatcher("/requestPassword.jsp").forward(request, response);
                return;
            }

            User user = authDao.findUserById(tokenForgetPassword.getUserId());

            request.setAttribute("email", user.getEmail());
            session.setAttribute("token", tokenForgetPassword.getToken());

            request.getRequestDispatcher("/resetPassword.jsp").forward(request, response);
            return;
        } else request.getRequestDispatcher("/requestPassword.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        if(!password.equals(confirmPassword)) {
            request.setAttribute("message", "confirm password must same password");
            request.getRequestDispatcher("/resetPassword.jsp").forward(request, response);
            return;
        }

        AuthDao authDao = new AuthDao();
        HttpSession session = request.getSession();

        String token = (String) session.getAttribute("token");
        TokenForgetPasswordDAO forgetPasswordDAO = new TokenForgetPasswordDAO();

        TokenForgetPassword tokenForgetPassword = forgetPasswordDAO.getTokenPassword(token);

        boolean updatedUser = authDao.updatePassword(tokenForgetPassword.getUserId(), SecurityUtils.hashMD5(password));
        boolean updatedToken = forgetPasswordDAO.updateStatus(token);

        if (updatedUser && updatedToken) {
            session.removeAttribute("token");

            session.setAttribute("success",
                    "Đặt lại mật khẩu thành công. Vui lòng đăng nhập.");

            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        request.setAttribute("error",
                "Không thể đặt lại mật khẩu. Vui lòng thử lại.");

        request.getRequestDispatcher("/resetPassword.jsp")
                .forward(request, response);
    }
}