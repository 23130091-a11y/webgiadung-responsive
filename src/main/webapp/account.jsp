<%--
  Created by IntelliJ IDEA.
  User: nguye
  Date: 07/12/2025
  Time: 3:07 CH
  To change this template use File | Settings | File Templates.
--%>
<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tài khoản của</title>

    <!-- Link Reset CSS -->
    <link rel="stylesheet" href="assets/css/reset.css">
    <!-- Link font -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Open+Sans:ital,wght@0,300..800;1,300..800&family=Poppins:ital,wght@0,300;0,400;0,500;0,600;0,700;1,300;1,400;1,500;1,600;1,700&display=swap"
            rel="stylesheet">
    <!-- Link icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css"
          integrity="sha512-2SwdPD6INVrV/lHTZbO2nodKhrnDdJK9/kg2XD1r9uGqPo1cUbujc+IYdlYdEErWNu69gVcYgdxlmVmzTWnetw=="
          crossorigin="anonymous" referrerpolicy="no-referrer" />
    <!-- Link CSS -->
    <link rel="stylesheet" href="assets/css/grid.css">
    <link rel="stylesheet" href="assets/css/base.css">
    <link rel="stylesheet" href="assets/css/style.css">
    <link rel="stylesheet" href="assets/css/search.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/account.css?v=20260403">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/axios/0.21.1/axios.min.js"></script>
</head>

<body>

<%@ include file="/common/header.jsp" %>
<c:set var="tab" value="${empty param.tab ? 'info' : param.tab}" />
<main class="main">
    <div class="account">
        <div class="grid wide">
            <div class="row small-gutter">
                <div class="col l-2 m-0 c-0">
                    <aside class="account__sidebar">

                        <section class="account__section">
                            <h2 class="account__title">Tài khoản của tôi</h2>
                            <ul class="account__list">
                                <li class="account__item">
                                     <a href="${pageContext.request.contextPath}/account?tab=info"
                                       class="account__link ${tab == 'info' ? 'account__link--active' : ''}">
                                        Thông tin cá nhân
                                     </a>
                                </li>
                                <li class="account__item">
                                    <a href="${pageContext.request.contextPath}/account?tab=address"
                                          class="account__link ${tab == 'address' ? 'account__link--active' : ''}">
                                        Địa chỉ
                                    </a>
                                </li>
                                <li class="account__item">
                                    <a href="${pageContext.request.contextPath}/account?tab=password"
                                         class="account__link ${tab == 'password' ? 'account__link--active' : ''}">
                                        Đổi mật khẩu
                                    </a>
                                </li>
                            </ul>
                        </section>

                        <section class="account__section">
                            <h2 class="account__title">Yêu thích</h2>
                            <ul class="account__list">
                                <li class="account__item">
                                    <a href="${pageContext.request.contextPath}/account?tab=favorite"
                                        class="account__link ${tab == 'favorite' ? 'account__link--active' : ''}">
                                        Sản phẩm đã thích
                                    </a>
                                </li>
                            </ul>
                        </section>

                        <section class="account__section">
                          <h2 class="account__title">Thông tin đơn hàng</h2>

                          <ul class="account__list">
                            <li class="account__item">
                              <a href="${pageContext.request.contextPath}/account?tab=all"
                               class="account__link ${tab == 'all' ? 'account__link--active' : ''}">
                                Tất cả đơn hàng
                              </a>
                            </li>

                            <li class="account__item">
                              <a href="${pageContext.request.contextPath}/account?tab=processing"
                               class="account__link ${tab == 'processing' ? 'account__link--active' : ''}">
                                Đơn chờ xác nhận
                              </a>
                            </li>

                              <li class="account__item">
                                  <a href="${pageContext.request.contextPath}/account?tab=shipping"
                                     class="account__link ${tab == 'shipping' ? 'account__link--active' : ''}">
                                      Đơn đang giao
                                  </a>
                              </li>

                            <li class="account__item">
                              <a href="${pageContext.request.contextPath}/account?tab=delivered"
                                  class="account__link ${tab == 'delivered' ? 'account__link--active' : ''}">
                                Đơn đã giao
                              </a>
                            </li>

                            <li class="account__item">
                              <a href="${pageContext.request.contextPath}/account?tab=cancelled"
                                  class="account__link ${tab == 'cancelled' ? 'account__link--active' : ''}">
                                Đơn đã hủy / trả hàng
                              </a>
                            </li>
                          </ul>

                        </section>
                    </aside>
                </div>

                <!-- Content -->
                <div class="col l-10 m-12 c-12">
                    <c:choose>
                        <c:when test="${tab == 'info'}">
                            <section class="account__content">
                                <h2 class="account__heading">Thông tin cá nhân</h2>

                                <form class="account__form" action="${pageContext.request.contextPath}/account" method="post">
                                    <input type="hidden" name="action" value="updateProfile">
                                    <input type="hidden" name="tab" value="info">

                                    <div class="account__form-group">
                                        <label for="fullname" class="account__label">Họ và tên</label>
                                        <input type="text" id="fullname" name="name" class="account__input"
                                               value="${sessionScope.user.name}" required>
                                    </div>

                                    <div class="account__form-group">
                                        <label for="phone" class="account__label">Số điện thoại</label>
                                        <input type="tel" id="phone" name="phone" class="account__input"
                                               value="${sessionScope.user.phone}">
                                    </div>

                                    <c:if test="${not empty profileMsg}">
                                        <p style="color:green;margin:8px 0;">${profileMsg}</p>
                                    </c:if>
                                    <c:if test="${not empty profileError}">
                                        <p style="color:red;margin:8px 0;">${profileError}</p>
                                    </c:if>

                                    <button type="submit" class="account__btn btn btn--default-color">Lưu thông tin</button>
                                </form>
                            </section>
                        </c:when>

                        <c:when test="${tab == 'address'}">
                            <section class="account__content">
                                <h2 class="account__heading">Địa chỉ</h2>

                                <form id="addressForm" class="account__form" action="${pageContext.request.contextPath}/account" method="post">
                                    <input type="hidden" name="action" value="updateProfile">
                                    <input type="hidden" name="tab" value="address">
                                    <input type="hidden" name="provinceName" id="provinceName">

                                    <div class="account__form-group">
                                        <label for="province" class="account__label">Tỉnh/thành phố</label>
                                        <select id="province" name="province" class="account__select" required>
                                            <option value="">Chọn tỉnh/thành phố</option>
                                        </select>
                                    </div>

                                    <!-- Quận/huyện -->
                                    <div class="account__form-group">
                                        <label for="district" class="account__label">Quận/huyện</label>
                                        <select id="district" name="district" class="account__select" required>
                                            <option value="">Chọn quận/huyện</option>
                                        </select>
                                    </div>

                                    <div class="account__form-group">
                                        <label for="detailAddress" class="account__label">Địa chỉ</label>
                                        <input type="text" id="detailAddress" name="detailAddress" class="account__input"
                                               value="${sessionScope.user.address}" required>
                                    </div>

                                    <c:if test="${not empty profileMsg}">
                                        <p style="color:green;margin:8px 0;">${profileMsg}</p>
                                    </c:if>
                                    <c:if test="${not empty profileError}">
                                        <p style="color:red;margin:8px 0;">${profileError}</p>
                                    </c:if>

                                    <button type="submit" class="account__btn btn btn--default-color">Lưu thông tin</button>
                                </form>
                            </section>
                        </c:when>

                        <c:when test="${tab == 'password'}">
                            <section class="account__content">
                                <h2 class="account__heading">Đổi mật khẩu</h2>

                                <form class="account__form" action="${pageContext.request.contextPath}/account" method="post">
                                    <input type="hidden" name="action" value="changePassword">
                                    <input type="hidden" name="tab" value="password">

                                    <!-- Mật khẩu hiện tại -->
                                    <div class="account__form-group">
                                        <label for="current-password" class="account__label">Mật khẩu hiện tại</label>
                                        <input type="password" id="current-password" name="oldPassword"
                                               class="account__input" required>
                                    </div>

                                    <!-- Mật khẩu mới -->
                                    <div class="account__form-group">
                                        <label for="new-password" class="account__label">Mật khẩu mới</label>
                                        <input type="password" id="new-password" name="newPassword"
                                               class="account__input" required>
                                    </div>

                                    <!-- Xác nhận mật khẩu mới -->
                                    <div class="account__form-group">
                                        <label for="confirm-password" class="account__label">Xác nhận mật khẩu mới</label>
                                        <input type="password" id="confirm-password" name="confirmPassword"
                                               class="account__input" required>
                                    </div>

                                    <c:if test="${not empty passMsg}">
                                        <p style="color:green;margin:8px 0;">${passMsg}</p>
                                    </c:if>
                                    <c:if test="${not empty passError}">
                                        <p style="color:red;margin:8px 0;">${passError}</p>
                                    </c:if>

                                    <button type="submit" class="account__btn btn btn--default-color">Lưu thông tin</button>
                                </form>
                            </section>
                        </c:when>

                        <c:when test="${tab == 'favorite'}">
                            <section class="account__content">
                                <h2 class="account__heading">Sản phẩm yêu thích</h2>

                                <c:choose>
                                    <c:when test="${empty favorites}">
                                        <div class="order-empty">Bạn chưa có sản phẩm yêu thích nào.</div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="row g-2">
                                            <c:forEach var="p" items="${favorites}">
                                                <div class="col l-2-4 m-4 c-6">
                                                    <div class="product-item">
                                                        <img src="${p.image}" alt="${p.name}">
                                                        <h3>${p.name}</h3>
                                                        <p>${p.price}</p>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </section>
                        </c:when>

                        <c:otherwise>
                            <c:choose>
                                <c:when test="${tab == 'processing'}">
                                    <c:set var="displayList" value="${ordersNew}" />
                                    <c:set var="tabHeading" value="Đơn chờ xác nhận" />
                                </c:when>
                                <c:when test="${tab == 'shipping'}">
                                    <c:set var="displayList" value="${ordersShipping}" />
                                    <c:set var="tabHeading" value="Đơn đang giao" />
                                </c:when>
                                <c:when test="${tab == 'delivered'}">
                                    <c:set var="displayList" value="${ordersDelivered}" />
                                    <c:set var="tabHeading" value="Đơn đã giao" />
                                </c:when>
                                <c:when test="${tab == 'cancelled'}">
                                    <c:set var="displayList" value="${ordersCancelled}" />
                                    <c:set var="tabHeading" value="Đơn đã hủy / trả hàng" />
                                </c:when>
                                <c:otherwise>
                                    <c:set var="displayList" value="${ordersAll}" />
                                    <c:set var="tabHeading" value="Tất cả đơn hàng" />
                                </c:otherwise>
                            </c:choose>

                            <section class="account__content">
                                <h2 class="account__heading">${tabHeading}</h2>

                                <c:if test="${empty displayList}">
                                    <div class="order-empty">Không có đơn hàng nào trong mục này.</div>
                                </c:if>

                                <c:forEach var="o" items="${displayList}">
                                    <article class="order-item">
                                        <header class="order-item__header">
                                            <div class="order-item__info">
                                                <div>Mã đơn: #${o.id}</div>
                                                <div>Ngày đặt: <fmt:formatDate value="${o.created_at}" pattern="dd/MM/yyyy HH:mm"/></div>
                                            </div>

                                            <c:choose>
                                                <c:when test="${o.status_transport == 0}"><span class="order-item__status">Chờ xác nhận</span></c:when>
                                                <c:when test="${o.status_transport == 1}"><span class="order-item__status">Đã xác nhận</span></c:when>
                                                <c:when test="${o.status_transport == 2}"><span class="order-item__status">Đang giao</span></c:when>
                                                <c:when test="${o.status_transport == 3}"><span class="order-item__status">Đã giao</span></c:when>
                                                <c:when test="${o.status_transport == 4}"><span class="order-item__status">Đã hủy</span></c:when>
                                                <c:when test="${o.status_transport == 5}"><span class="order-item__status">Trả hàng</span></c:when>
                                            </c:choose>
                                        </header>

                                        <section class="order-item__body">
                                            <c:forEach var="it" items="${orderItemsMap[o.id]}">
                                                <div class="order-product">
                                                    <div class="order-product__info">
                                                        <img class="order-product__img" src="${pageContext.request.contextPath}/assets/img/products/${it.product_image}">
                                                        <div class="order-product__meta">
                                                            <h4 class="order-product__name">${it.product_name}</h4>
                                                            <span class="order-product__quantity">x ${it.quantity}</span>
                                                        </div>
                                                    </div>
                                                    <div class="order-product__price-wrap">
                                                        <div class="price-wrapper">
                                                            <c:if test="${it.original_price > it.discount_price}">
                                                                <div class="old-price-box"><fmt:formatNumber value="${it.original_price}" type="number"/>đ</div>
                                                            </c:if>
                                                            <div class="new-price-box"><fmt:formatNumber value="${it.discount_price}" type="number"/>đ</div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </section>

                                        <footer class="order-item__footer">
                                            <div class="order-item__total">
                                                <span>Thành tiền: </span>
                                                <span class="order-item__total-price">
                                                    <fmt:formatNumber value="${o.total_price}" type="number"/>đ
                                                </span>
                                            </div>

                                            <div class="order-item__actions">
                                                <c:if test="${o.status_transport == 0}">
                                                    <button type="button" class="order-item__action-btn" onclick="cancelOrderAjax(${o.id}, this)">Hủy đơn</button>
                                                </c:if>

                                                <c:if test="${o.status_transport >= 3}">
                                                    <form method="post" action="${pageContext.request.contextPath}/account-again">
                                                        <input type="hidden" name="action" value="repurchase"/>
                                                        <input type="hidden" name="orderId" value="${o.id}"/>
                                                        <button type="submit" class="order-item__action-btn order-item__action-btn--primary">Mua lại</button>
                                                    </form>
                                                </c:if>
                                            </div>
                                        </footer>
                                    </article>
                                </c:forEach>
                            </section>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
</main>

<!-- Footer -->
<jsp:include page="/common/footer.jsp" />
</body>

<script src="assets/js/script.js"></script>

<script>
    function cancelOrderAjax(orderId, btnElement) {
        if(!confirm("Bạn có chắc là muốn hủy đơn hàng #" + orderId + "?")) {
            return;
        }
        // const originalText = btnElement.innerText;
        btnElement.disabled = true;
        btnElement.style.opacity = '0.8';

        // gửi request
        const params = new URLSearchParams();
        params.append('action', 'cancelOrder');
        params.append('orderId', orderId);

        fetch('${pageContext.request.contextPath}/account-again', {
            method : 'POST',
            headers : {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body : params.toString()
        })
            .then(response => response.json())
            .then(data => {
                if(data.status === 'success') {
                    alert(data.message);

                    // hiệu ứng xóa đơn
                    const orderArticle = btnElement.closest('.order-item');
                    orderArticle.style.transition = 'all 0.5s ease';
                    orderArticle.style.opacity = '0';
                    orderArticle.style.transform = 'scale(0.9)';

                    setTimeout(() => {
                        orderArticle.remove();
                        if(document.querySelectorAll('.order-item').length === 0) {
                            window.location.href = window.location.pathname + "?tab=cancelled";
                        }
                    }, 500);
                } else {
                    alert(data.message);
                    btnElement.disabled = false;
                    btnElement.style.opacity = '1';
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Có lỗi xảy ra, vui lòng thử lại!');
                btnElement.disabled = false;
                btnElement.style.opacity = '1';
            });
    }
</script>

<script>
    document.addEventListener("DOMContentLoaded", function () {

        const provinceSelect = document.getElementById("province");
        const districtSelect = document.getElementById("district");

        // Load tỉnh
        fetch("https://provinces.open-api.vn/api/p/")
            .then(res => res.json())
            .then(data => {
                data.forEach(province => {
                    const option = document.createElement("option");
                    option.value = province.code;
                    option.textContent = province.name;
                    provinceSelect.appendChild(option);
                });
            });

        // Khi chọn tỉnh
        provinceSelect.addEventListener("change", function () {

            const selectedOption = this.options[this.selectedIndex];

            // lưu name vào hidden input
            document.getElementById("provinceName").value = selectedOption.text;

            const provinceCode = this.value;

            const url = "https://provinces.open-api.vn/api/p/" + provinceCode + "?depth=2";

            districtSelect.innerHTML = `<option value="">Chọn quận/huyện</option>`;

            if (!provinceCode) return;

            fetch(url)
                .then(res => res.json())
                .then(data => {
                    data.districts.forEach(district => {
                        const option = document.createElement("option");
                        option.value = district.name;
                        option.textContent = district.name;
                        districtSelect.appendChild(option);
                    });
                });
        });

    });
</script>

</html>