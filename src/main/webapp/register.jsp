<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng ký Gia Dụng Online</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css"
        integrity="..." crossorigin="anonymous" referrerpolicy="no-referrer" />

    <link rel="stylesheet" href="assets/css/reset.css">
    <link rel="stylesheet" href="assets/css/grid.css">
    <link rel="stylesheet" href="assets/css/base.css">
    <link rel="stylesheet" href="assets/css/style.css">
    <link rel="stylesheet" href="assets/css/register.css">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>

<body>

    <header class="main-header">
        <div class="container">
            <div class="logo">
                <a href="${pageContext.request.contextPath}/list-product">
                    <img src="assets/img/logo.png" alt="Logo Gia Dụng Online">
                </a>
                <h1>Đăng ký</h1>
            </div>
            <div class="support-link">
                <a href="#">Bạn cần giúp đỡ?</a>
            </div>
        </div>
    </header>

    <main class="main-content">
        <div class="banner-section"></div>

        <div class="login-container">
            <form id="registerForm" class="login-form"
                  action="${pageContext.request.contextPath}/register" method="post"novalidate>
                <h3>Đăng ký</h3>

                <!-- lỗi client-side -->
                <p id="clientError" style="color:#d93025; margin-top:10px;"></p>



                <input type="text"
                       id="email"
                       name="email"
                       placeholder="Email"
                       required>

                <input type="text"
                       id="phone"
                       name="phone"
                       placeholder="Số điện thoại"
                       required>

                <input type="password" name="password"placeholder="Nhập mật khẩu" required
                       pattern="^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$"
                       title="Tối thiểu 8 ký tự, có chữ hoa, số và ký tự đặc biệt">

                <input type="password"
                       id="repassword"
                       name="repassword"
                       placeholder="Nhập lại mật khẩu"
                       required>

                <button type="submit" class="btn-login">ĐĂNG KÝ</button>

                <%-- HIỂN THỊ LỖI server-side --%>
                <% if (request.getAttribute("error") != null) { %>
                <p style="color:red; margin-top:10px;">
                    <%= request.getAttribute("error") %>
                </p>
                <% } %>

                <div class="register-link">
                    <span>Đã có tài khoản?</span>
                    <a href="${pageContext.request.contextPath}/login">Đăng nhập</a>
                </div>
            </form>

        </div>
    </main>
    <!-- Footer -->
    <jsp:include page="/common/footer.jsp" />
</body>
<script src="assets/js/script.js"></script>

</html>