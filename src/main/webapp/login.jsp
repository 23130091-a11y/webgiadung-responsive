<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập Gia Dụng Online</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css" crossorigin="anonymous" referrerpolicy="no-referrer" />

    <link rel="stylesheet" href="assets/css/reset.css">
    <link rel="stylesheet" href="assets/css/grid.css">
    <link rel="stylesheet" href="assets/css/base.css">
    <link rel="stylesheet" href="assets/css/style.css">
    <link rel="stylesheet" href="assets/css/login.css">

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

</head>

<body>

<header class="main-header">
    <div class="container">
        <div class="logo">
            <a href="${pageContext.request.contextPath}/list-product">
                <img src="assets/img/logo.png" alt="Logo Gia Dụng Online">
            </a>
            <h1>Đăng nhập</h1>
        </div>
        <div class="support-link">
            <a href="#">Bạn cần giúp đỡ?</a>
        </div>
    </div>
</header>


    <main class="main-content">

        <div class="banner-section">
        </div>

        <div class="login-container">
            <!-- Login Google -->
            <div class="social-login">
                <a class="btn-google" href="https://accounts.google.com/o/oauth2/auth?scope=profile email&redirect_uri=http://localhost:8080/DoAnWeb/login-google&response_type=code
		   &client_id=&approval_prompt=force">
                    <i class="fa-brands fa-google"></i>
                    Đăng nhập với Google
                </a>
            </div>
            <div class="divider">
                <span>hoặc</span>
            </div>
            <!-- Login thường -->
            <form class="login-form" action="${pageContext.request.contextPath}/login" method="post" >
                <input type="hidden" name="redirect" value="${not empty redirect ? redirect : param.redirect}" />
                <h3>Đăng nhập</h3>

                <!-- Xác nhận -->
                <% if ("verify".equals(request.getParameter("msg"))) { %>
                <div style="color: green; margin-bottom: 10px;">
                    Đăng ký thành công! Vui lòng kiểm tra email để xác nhận tài khoản.
                </div>
                <% } %>

                <!-- Thông báo lỗi -->
                <c:if test="${not empty error}">
                    <div class="text-danger mb-1">${error}</div>
                </c:if>

                <input type="email"
                       name="email"
                       value="${requestScope.email}"
                       placeholder="Email"
                       required>

                <input type="password"
                       name="password"
                       placeholder="Mật khẩu"
                       required>

                <button type="submit" class="btn-login">ĐĂNG NHẬP</button>

                <div class="forgot-password">
                    <a href="#">Quên mật khẩu?</a>
                </div>

                <div class="register-link">
                    <span>Đăng ký thành viên mới?</span> <a href="register.jsp">Đăng ký</a>
                </div>
            </form>
        </div>
    </main>
    <!-- Footer -->
    <jsp:include page="/common/footer.jsp" />
</body>

<script src="assets/js/script.js"></script>

</html>