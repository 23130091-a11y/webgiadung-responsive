<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${not empty slide ? slide.title : 'Chương trình khuyến mãi'}</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/reset.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/slide.css?v=2">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/grid.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Open+Sans:ital,wght@0,300..800;1,300..800&family=Poppins:ital,wght@0,300;0,400;0,500;0,600;0,700;1,300;1,400;1,500;1,600;1,700&display=swap" rel="stylesheet">

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"
          integrity="sha512-SnH5WK+bZxgPHs44uWIX+LLJAJ9/2PkPKZ5QiAj6Ta86w+fsb2TkcmfRyVX3pBnMFcV7oQPJkl9QevSCWr3W6A=="
          crossorigin="anonymous" referrerpolicy="no-referrer" />
</head>

<body>
<%@ include file="/common/header.jsp" %>

<main class="main" style="background-color: #ffffff; padding-bottom: 30px;">
    <div class="grid wide">

        <c:if test="${not empty errorMessage}">
            <div style="text-align: center; padding: 50px; color: red; font-size: 1.8rem;">
                <i class="fa-solid fa-triangle-exclamation"></i> ${errorMessage}
            </div>
        </c:if>

        <c:if test="${empty errorMessage}">
            <div class="image-sale">
                <img class="logo__img"
                     src="${pageContext.request.contextPath}/${slide.banner}"
                     alt="${slide.title}" style="max-width: 100%; height: auto;">
            </div>

            <div class="slide-content">
                <div class="head-content">
                    <h1 class="ti" style="font-size: 2.2rem; font-weight: bold; margin: 15px 0;">${slide.title}</h1>
                    <p class="name" style="font-size: 1.4rem; color: #555;">${slide.description}</p>
                    <p class="date" style="font-size: 1.2rem; color: #888; margin-top: 5px;">
                        <i class="fa-regular fa-clock"></i> Chương trình áp dụng trên toàn hệ thống
                    </p>
                </div>
            </div>

            <div class="slide-wrapper" style="margin-top: 20px;">
                <div class="slide-list-product row small-gutter">

                    <c:if test="${empty productList}">
                        <div class="col l-12 m-12 c-12">
                            <p style="padding: 30px; text-align: center; width: 100%; font-size: 1.5rem; color: #666;">
                                Hiện tại chưa có sản phẩm nào cho chương trình này.
                            </p>
                        </div>
                    </c:if>

                    <c:forEach items="${productList}" var="p">
                        <div class="col l-2-4 m-4 c-6">
                            <div class="product-card">
                                <a href="product?id=${p.id}">
                                    <img src="${pageContext.request.contextPath}/assets/img/products/${p.image}" alt="${p.name}">
                                </a>
                                <a href="product?id=${p.id}">
                                    <p class="product-name">${p.name}</p>
                                </a>
                                <div class="price-discount">
                                    <div class="price-top">
                                            <span class="old-price">
                                                <fmt:formatNumber value="${p.firstPrice}" type="number"/>đ
                                            </span>
                                        <div class="discount-badge">Giảm ${p.discountPercent}%</div>
                                    </div>
                                    <div class="price-bottom">
                                            <span class="new-price">
                                                <fmt:formatNumber value="${p.totalPrice != null ? p.totalPrice : p.firstPrice}" type="number"/>đ
                                            </span>
                                    </div>
                                </div>
                                <div class="bottom">
                                    <div class="star">
                                        <i class="fa-solid fa-star"></i> ${p.ratingAvg != null ? p.ratingAvg : '5.0'}
                                    </div>
                                    <button class="fav-btn"><i class="fa-regular fa-heart"></i> Yêu thích</button>
                                </div>
                            </div>
                        </div>
                    </c:forEach>

                </div>
            </div>
        </c:if>

    </div>
</main>

<script src="${pageContext.request.contextPath}/assets/js/script.js"></script>
</body>
</html>