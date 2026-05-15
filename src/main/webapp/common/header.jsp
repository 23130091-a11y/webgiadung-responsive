<%--
  Created by IntelliJ IDEA.
  User: nguye
  Date: 22/01/2026
  Time: 9:11 CH
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    response.setHeader("Cache-Control", "no-store, no-cache, must-revalidate, max-age=0");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
%>
<header id="header" class="header header-checkout">
    <div class="grid wide">
        <div class="header-top">
            <!-- Navbar -->
            <nav class="navbar">
                <ul class="navbar__list">
                    <li class="navbar__item navbar__item--separate navbar__item--fade-qr">
                        Vào cửa hàng trên ứng dụng
                        <div class="navbar-qr">
                            <img src="assets/img/qr_code.jpg" alt="QR Code" class="navbar-qr__img">
                            <div class="navbar-qr__wrap">
                                <a class="navbar-qr__link" href="#!">
                                    <img src="assets/img/googleplay.png" alt="Google Play"
                                         class="navbar-qr__media">
                                </a>
                                <a class="navbar-qr__link" href="#!">
                                    <img src="assets/img/appstore.png" alt="App store" class="navbar-qr__media">
                                </a>
                            </div>
                        </div>
                    </li>
                    <li class="navbar__item">
                        <span class="navbar__item--no-pointer">Kết nối</span>
                        <!-- Chỉ định dạng chữ Kết nối (phần tử nhỏ trong thẻ li) nên dùng span để CSS cụ thể -->
                        <a href="#!" class="navbar__item-icon-link">
                            <i class="navbar__item-symbol fa-brands fa-facebook"></i>
                        </a>
                        <a href="#!" class="navbar__item-icon-link">
                            <i class="navbar__item-symbol fa-brands fa-square-instagram"></i>
                        </a>
                    </li>
                </ul>

                <ul class="navbar__list">
                    <li class="navbar__item navbar__item--fade-notify">
                        <i class="navbar__item-symbol fa-regular fa-bell"></i>
                        <a href="#!" class="navbar__link">
                            Thông báo
                            <div class="navbar-notify navbar-notify--no-login">
                                <!-- navbar-notify--no-login -->
                                <img src="assets/img/no-login_img.png" alt="" class="navbar-notify__img">
                                <span class="navbar-notify__message">Đăng nhập để xem thông báo</span>
                                <!---->
                                <!-- <div class="navbar-notify__wrap">
                                    <header class="navbar-notify__header">
                                        <h3 class="navbar-notify__heading">Thông báo mới nhận</h3>
                                    </header>

                                    <ul class="navbar-notify__list">
                                        <li class="navbar-notify__item navbar-notify__item--view">
                                            <a href="#!" class="navbar-notify__link">
                                                <img class="navbar-notify__login-img" src="./assets/img/notify-img-01.png" alt="Túi đựng quần áo, chăn ga">
                                                <div class="navbar-notify__content">
                                                    <span class="navbar-notify__title">Tặng ngay 1 túi đựng quần áo, chăn ga Tặng ngay 1 túi đựng quần áo, chăn ga</span>
                                                    <span class="navbar-notify__describe">Khuyến mãi siêu hot</span>
                                                </div>
                                            </a>
                                        </li>

                                        <li class="navbar-notify__item">
                                            <a href="#!" class="navbar-notify__link">
                                                <img class="navbar-notify__login-img" src="./assets/img/notify-img-02.jpg" alt="Túi đựng quần áo, chăn ga">
                                                <div class="navbar-notify__content">
                                                    <span class="navbar-notify__title">Combo 12 viên vệ sinh lồng máy giặt, diệt khuẩn tiện lợi</span>
                                                    <span class="navbar-notify__describe">Khuyến mãi siêu hot</span>
                                                </div>
                                            </a>
                                        </li>

                                        <li class="navbar-notify__item">
                                            <a href="#!" class="navbar-notify__link">
                                                <img class="navbar-notify__login-img" src="./assets/img/notify-img-03.jpg" alt="Túi đựng quần áo, chăn ga">
                                                <div class="navbar-notify__content">
                                                    <span class="navbar-notify__title">Khăn lau xe ô tô chuyên dụng mềm mịn và thấm hút tốt, Loại 35cm x 35cm</span>
                                                    <span class="navbar-notify__describe">Khuyến mãi siêu hot</span>
                                                </div>
                                            </a>
                                        </li>
                                    </ul>
                                    <div class="navbar-notify__footer">
                                        <a href="" class="navbar-notify__btn">Xem tất cả</a>
                                    </div>
                                </div> -->
                            </div>
                        </a>
                    </li>
                    <li class="navbar__item">
                        <i class="navbar__item-symbol fa-regular fa-circle-question"></i>
                        <a href="#!" class="navbar__link">Trợ giúp</a>
                    </li>

                    <c:if test="${empty sessionScope.USER_LOGIN}">
                        <li class="navbar__item navbar__item--strong-weight navbar__item--separate">
                            <a href="register.jsp" class="navbar__link">Đăng ký</a>
                        </li>

                        <li class="navbar__item navbar__item--strong-weight">
                            <a href="${pageContext.request.contextPath}/login?redirect=${requestScope['jakarta.servlet.forward.servlet_path']}${not empty requestScope['jakarta.servlet.forward.query_string'] ? '?' : ''}${requestScope['jakarta.servlet.forward.query_string']}"
                               class="navbar__link">
                                Đăng nhập
                            </a>
                        </li>
                    </c:if>

                    <!-- Đã đăng nhập -->
                    <c:if test="${not empty sessionScope.USER_LOGIN}">
                        <li class="navbar__item navbar-user">
                            <img class="navbar-user__img"
                                 src="data:image/png;base64,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"
                                 alt="Avatar">

                            <span class="navbar-user__name">
                                    ${sessionScope.USER_LOGIN.name}
                            </span>

                            <ul class="navbar-user__menu">
                                <li class="navbar-user__item">
                                    <a href="${pageContext.request.contextPath}/account?tab=info" class="navbar-user__link">Tài khoản của tôi</a>
                                </li>
                                <li class="navbar-user__item">
                                    <a href="${pageContext.request.contextPath}/account?tab=favorite" class="navbar-user__link">Yêu thích</a>
                                </li>
                                <li class="navbar-user__item">
                                    <a href="${pageContext.request.contextPath}/account?tab=all" class="navbar-user__link">Thông tin đơn hàng</a>
                                </li>
                                <li class="navbar-user__item navbar-user__item--separate">
                                    <a href="${pageContext.request.contextPath}/logout" class="navbar-user__link">Đăng xuất</a>
                                </li>
                            </ul>
                        </li>
                    </c:if>
                </ul>
            </nav>
            <!-- Search -->
            <div class="search">
                <a href="${pageContext.request.contextPath}/list-product" class="logo">
                    <img class="logo__img" src="assets/img/logo.png" alt="WebGiaDung">
                </a>

                <!-- Thay toàn bộ header search bằng -->
                <form action="search-product" method="get" class="header-search">
                    <div class="header-search__wrap">
                        <input
                                type="text"
                                name="keyword"
                                class="header-search__input"
                                placeholder="Bạn cần tìm kiếm sản phẩm gì?"
                                value="${param.keyword}"
                                required
                        >

                        <!-- Search history giữ nguyên (HTML) -->
                        <div class="search-history">
                            <h3 class="search-history__heading">Lịch sử tìm kiếm</h3>
                            <ul class="search-history__list">
                                <c:forEach items="${sessionScope.searchHistory}" var="item">
                                    <li class="search-history__item">
                                        <a href="${pageContext.request.contextPath}/search-product?keyword=${item}" class="search-history__link">
                                                ${item}
                                        </a>
                                    </li>
                                </c:forEach>
                            </ul>
                        </div>
                    </div>

                    <button type="submit" class="header-search__btn btn btn--default-color">
                        <i class="header-search__icon fa-solid fa-magnifying-glass"></i>
                        <span class="header-search__text">Tìm kiếm</span>
                    </button>
                </form>

                <div class="header-cart">
                    <div class="header-cart__scale header-cart__scale--fade-product">

                        <c:set var="user" value="${sessionScope.user}" />
                        <c:set var="cart" value="${sessionScope.cart}" />

                        <a href="#!">
                            <i class="header-cart__icon fa-solid fa-cart-shopping"></i>
                            <span class="header-cart__notice header__cart-notice" id="headerCartQty">
                                 <c:choose>
                                     <c:when test="${not empty cart && not empty cart.items}">
                                         ${cart.totalQuantity}
                                     </c:when>
                                     <c:otherwise>0</c:otherwise>
                                 </c:choose>
                            </span>
                        </a>

                        <div class="cart-list">
                            <c:choose>

                                <c:when test="${empty user}">
                                    <div class="cart-list--no-cart">
                                        <img src="${pageContext.request.contextPath}/assets/img/no-cart_img.png" class="header-cart__img" alt="">
                                        <span class="header-cart__msg">Bạn cần đăng nhập</span>
                                    </div>
                                </c:when>

                                <c:when test="${empty cart || empty cart.items}">
                                    <div class="cart-list--no-cart">
                                        <img src="${pageContext.request.contextPath}/assets/img/no-cart_img.png" class="header-cart__img" alt="">
                                        <span class="header-cart__msg">Chưa có sản phẩm</span>
                                    </div>
                                </c:when>

                                <c:otherwise>
                                    <div class="cart-list__wrap">
                                        <h3 class="cart-list__header">Sản phẩm đã thêm</h3>

                                        <ul class="cart-list__list">
                                            <c:forEach items="${cart.items}" var="item">
                                                <li class="cart-list__item" id="mini-cart-item-${item.product.id}">
                                                    <a href="${pageContext.request.contextPath}/product?id=${item.product.id}"
                                                       style="display:flex; gap:10px; align-items:center; text-decoration:none; color:inherit; width:100%;">

                                                        <img src="${pageContext.request.contextPath}/assets/img/products/${item.product.image}"
                                                             alt="${item.product.name}"
                                                             class="cart-list__img">

                                                        <section class="cart-list__body">
                                                            <div class="cart-list__info">
                                                                <h4 class="cart-list__heading">${item.product.name}</h4>

                                                                <div class="cart-list__price-wrap">
                                                                    <span class="cart-list__price">
                                                                        <fmt:formatNumber value="${item.totalPrice}" type="number" /> đ
                                                                    </span>
                                                                    <span class="cart-list__multiply">x</span>
                                                                    <span class="cart-list__qnt">${item.quantity}</span>
                                                                </div>
                                                            </div>

                                                            <div class="cart-list__desc">
                                                                <span class="cart-list__product-cate">
                                                                    Phân loại: ${item.product.categoriesId}
                                                                </span>
                                                            </div>
                                                        </section>
                                                    </a>

                                                    <a href="${pageContext.request.contextPath}/delete-cart?id=${item.product.id}"
                                                       class="cart-list__remove"
                                                       onclick="event.preventDefault(); removeCartItemGlobal(${item.product.id});">
                                                        Xóa
                                                    </a>
                                                </li>
                                            </c:forEach>
                                        </ul>

                                        <a href="${pageContext.request.contextPath}/cart"
                                           class="cart-list__view btn btn--default-color">
                                            Xem giỏ hàng
                                        </a>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>

                <div class="header-hotline">
                    <i class="header-hotline__icon fa-solid fa-phone-volume"></i>
                    <div>
                        <span class="header-hotline__text">Hotline hỗ trợ</span>
                        <span class="header-hotline__text">1900.6750</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</header>

<script>
    // hàm cập nhật nguyên cái cart
    function applyMiniCartUpdate(data) {
        if (!data) return;

        // update badge số lượng
        const badge = document.querySelector('#headerCartQty');

        if (badge && typeof data.cartQty !== 'undefined') {
            badge.innerText = data.cartQty;
        }

        // update dropdown HTML
        if (data.miniCartHtml) {
            const box = document.querySelector('.cart-list');
            if (box) box.innerHTML = data.miniCartHtml;
        }
    }

    window.applyMiniCartUpdate = applyMiniCartUpdate;

    // hàm xóa cart item
    window.removeCartItemGlobal = function (pid, callback) {
        const params = new URLSearchParams({ id: pid, ajax: '1' });

        fetch('${pageContext.request.contextPath}/delete-cart', {
            method: 'POST',
            body: params,
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
                'X-Requested-With': 'XMLHttpRequest'
            }
        })
            .then(r => r.json())
            .then((data) => {

                // gọi cập nhật nguyên cái cart
                if (window.applyMiniCartUpdate) {
                    window.applyMiniCartUpdate(data);
                }

                // Xóa phần tử trên giao diện
                const li = document.getElementById('mini-cart-item-' + pid);
                if (li) li.remove();

                if (typeof callback === "function") {
                    callback(data);
                }

                // nếu giỏ hàng trống thì reload
                if (data.cartQty === 0) {
                    location.reload();
                }
            })
            .catch(err => console.error("Lỗi xóa hàng:", err));
    }
</script>
