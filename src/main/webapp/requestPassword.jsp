<%--
  Created by IntelliJ IDEA.
  User: nguye
  Date: 12/06/2026
  Time: 7:14 SA
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
        <h3>Send to email</h3>

        <div class="success">${success}</div>

        <form action="${pageContext.request.contextPath}/requestPassword" method="post">
            <input type="email" name="email" placeholder="Email" required>
            <button type="submit">Reset password</button>
        </form>

        <div class="error">${message}</div>
    </div>
</body>
</html>
