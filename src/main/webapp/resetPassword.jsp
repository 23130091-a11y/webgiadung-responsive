<%--
  Created by IntelliJ IDEA.
  User: nguye
  Date: 12/06/2026
  Time: 7:22 SA
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
    <title>Reset password</title>
    <link rel="stylesheet" href="assets/css/verify.css">
</head>
<body>
<div class="verify-container">
    <h3>Reset password</h3>

    <form action="${pageContext.request.contextPath}/resetPassword" method="post">
        <input type="email" name="email" value="${email}" placeholder="Email" required>
        <input type="password" name="password" placeholder="Password" required>
        <input type="password" name="confirmPassword" placeholder="Confirm password" required>
        <button type="submit">Reset password</button>
    </form>
</div>
</body>
</html>
