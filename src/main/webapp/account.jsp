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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/account.css?v=99">
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
                            <section class="account__content account-profile-card account-profile-card--info">
                                <div class="account-profile-card__heading">
                                    <div class="account-profile-card__icon">
                                        <i class="fa-solid fa-user-pen"></i>
                                    </div>
                                    <div>
                                        <h2>Thông tin cá nhân</h2>
                                        <p>Cập nhật họ tên và số điện thoại để đơn hàng được xử lý nhanh hơn.</p>
                                    </div>
                                </div>

                                <form class="account__form account-profile-form" action="${pageContext.request.contextPath}/account" method="post">
                                    <input type="hidden" name="action" value="updateProfile">
                                    <input type="hidden" name="tab" value="info">

                                    <div class="account-profile-form__grid">
                                        <div class="account__form-group">
                                            <label for="fullname" class="account__label">
                                                <i class="fa-regular fa-user"></i>
                                                Họ và tên
                                            </label>
                                            <input type="text" id="fullname" name="name" class="account__input"
                                                   value="${sessionScope.user.name}" required>
                                        </div>

                                        <div class="account__form-group">
                                            <label for="phone" class="account__label">
                                                <i class="fa-solid fa-phone"></i>
                                                Số điện thoại
                                            </label>
                                            <input type="tel" id="phone" name="phone" class="account__input"
                                                   value="${sessionScope.user.phone}" placeholder="Nhập số điện thoại">
                                        </div>
                                    </div>

                                    <c:if test="${not empty profileMsg}">
                                        <p class="account-alert account-alert--success">
                                            <i class="fa-solid fa-circle-check"></i>
                                            ${profileMsg}
                                        </p>
                                    </c:if>
                                    <c:if test="${not empty profileError}">
                                        <p class="account-alert account-alert--error">
                                            <i class="fa-solid fa-triangle-exclamation"></i>
                                            ${profileError}
                                        </p>
                                    </c:if>

                                    <button type="submit" class="account__btn account-profile-btn btn btn--default-color">
                                        <i class="fa-solid fa-floppy-disk"></i>
                                        Lưu thông tin
                                    </button>
                                </form>
                            </section>
                        </c:when>

                        <c:when test="${tab == 'address'}">
                            <section class="account__content account-profile-card account-profile-card--address">
                                <div class="account-profile-card__heading">
                                    <div class="account-profile-card__icon">
                                        <i class="fa-solid fa-location-dot"></i>
                                    </div>
                                    <div>
                                        <h2>Địa chỉ</h2>
                                        <p>Cập nhật địa chỉ nhận hàng để quá trình giao hàng chính xác hơn.</p>
                                    </div>
                                </div>

                                <form id="addressForm" class="account__form account-profile-form" action="${pageContext.request.contextPath}/account" method="post">
                                    <input type="hidden" name="action" value="updateProfile">
                                    <input type="hidden" name="tab" value="address">
                                    <input type="hidden" name="provinceName" id="provinceName">

                                    <div class="account-profile-form__grid">
                                        <div class="account__form-group">
                                            <label for="province" class="account__label">
                                                <i class="fa-solid fa-city"></i>
                                                Tỉnh/thành phố
                                            </label>
                                            <select id="province" name="province" class="account__select" required>
                                                <option value="">Chọn tỉnh/thành phố</option>
                                            </select>
                                        </div>

                                        <div class="account__form-group">
                                            <label for="district" class="account__label">
                                                <i class="fa-solid fa-map-location-dot"></i>
                                                Quận/huyện
                                            </label>
                                            <select id="district" name="district" class="account__select" required>
                                                <option value="">Chọn quận/huyện</option>
                                            </select>
                                        </div>
                                    </div>

                                    <div class="account__form-group">
                                        <label for="detailAddress" class="account__label">
                                            <i class="fa-regular fa-map"></i>
                                            Địa chỉ chi tiết
                                        </label>
                                        <input type="text" id="detailAddress" name="detailAddress" class="account__input"
                                               value="${sessionScope.user.address}" placeholder="Số nhà, tên đường, phường/xã..." required>
                                    </div>

                                    <c:if test="${not empty profileMsg}">
                                        <p class="account-alert account-alert--success">
                                            <i class="fa-solid fa-circle-check"></i>
                                            ${profileMsg}
                                        </p>
                                    </c:if>
                                    <c:if test="${not empty profileError}">
                                        <p class="account-alert account-alert--error">
                                            <i class="fa-solid fa-triangle-exclamation"></i>
                                            ${profileError}
                                        </p>
                                    </c:if>

                                    <button type="submit" class="account__btn account-profile-btn btn btn--default-color">
                                        <i class="fa-solid fa-floppy-disk"></i>
                                        Lưu thông tin
                                    </button>
                                </form>
                            </section>
                        </c:when>

                        <c:when test="${tab == 'password'}">
                            <section class="account__content account-profile-card account-profile-card--password">
                                <div class="account-profile-card__heading">
                                    <div class="account-profile-card__icon">
                                        <i class="fa-solid fa-key"></i>
                                    </div>
                                    <div>
                                        <h2>Đổi mật khẩu</h2>
                                        <p>Tạo mật khẩu mới để tăng bảo mật cho tài khoản của bạn.</p>
                                    </div>
                                </div>

                                <form class="account__form account-profile-form" action="${pageContext.request.contextPath}/account" method="post">
                                    <input type="hidden" name="action" value="changePassword">
                                    <input type="hidden" name="tab" value="password">

                                    <div class="account__form-group">
                                        <label for="current-password" class="account__label">
                                            <i class="fa-solid fa-lock"></i>
                                            Mật khẩu hiện tại
                                        </label>
                                        <input type="password" id="current-password" name="oldPassword"
                                               class="account__input" placeholder="Nhập mật khẩu hiện tại" required>
                                    </div>

                                    <div class="account-profile-form__grid">
                                        <div class="account__form-group">
                                            <label for="new-password" class="account__label">
                                                <i class="fa-solid fa-shield-halved"></i>
                                                Mật khẩu mới
                                            </label>
                                            <input type="password" id="new-password" name="newPassword"
                                                   class="account__input" placeholder="Nhập mật khẩu mới" required>
                                        </div>

                                        <div class="account__form-group">
                                            <label for="confirm-password" class="account__label">
                                                <i class="fa-solid fa-circle-check"></i>
                                                Xác nhận mật khẩu mới
                                            </label>
                                            <input type="password" id="confirm-password" name="confirmPassword"
                                                   class="account__input" placeholder="Nhập lại mật khẩu mới" required>
                                        </div>
                                    </div>

                                    <c:if test="${not empty passMsg}">
                                        <p class="account-alert account-alert--success">
                                            <i class="fa-solid fa-circle-check"></i>
                                            ${passMsg}
                                        </p>
                                    </c:if>
                                    <c:if test="${not empty passError}">
                                        <p class="account-alert account-alert--error">
                                            <i class="fa-solid fa-triangle-exclamation"></i>
                                            ${passError}
                                        </p>
                                    </c:if>

                                    <button type="submit" class="account__btn account-profile-btn btn btn--default-color">
                                        <i class="fa-solid fa-floppy-disk"></i>
                                        Lưu thông tin
                                    </button>
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
                                        <div class="row small-gutter">
                                            <c:forEach var="p" items="${favorites}">
                                                <div class="col l-2-4 m-4 c-6">
                                                    <div class="product-card">
                                                        <a href="${pageContext.request.contextPath}/product?id=${p.id}">
                                                            <img src="${pageContext.request.contextPath}/assets/img/products/${p.image}" alt="${p.name}">
                                                        </a>
                                                        <a href="${pageContext.request.contextPath}/product?id=${p.id}">
                                                            <p>${p.name}</p>
                                                        </a>

                                                        <div class="price-discount">
                                                            <c:if test="${p.isDiscounted}">
                                                                <div class="price-top">
                                            <span class="old-price">
                                                <fmt:formatNumber value="${p.firstPrice}" pattern="#,###"/>đ
                                            </span>
                                                                    <div class="discount-badge">
                                                                        <c:choose>
                                                                            <c:when test="${p.discountType eq 'percentage'}">
                                                                                Giảm ${p.discountPercent}%
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                Giảm <fmt:formatNumber value="${p.discountPercent}" pattern="#,###"/>đ
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </div>
                                                                </div>
                                                            </c:if>

                                                            <div class="price-bottom">
                                        <span class="new-price">
                                            <fmt:formatNumber value="${p.totalPrice}" pattern="#,###"/>đ
                                        </span>
                                                            </div>
                                                        </div>
                                                        <div class="bottom">
                                                            <div class="star"><i class="fa-solid fa-star"></i> ${p.ratingAvg}</div>
                                                            <button class="fav-btn active">
                                                                <i class="fa-solid fa-heart"></i> Yêu thích
                                                            </button>
                                                        </div>
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

                                            <c:if test="${not empty o.refund_status}">
                                                <c:choose>
                                                    <c:when test="${o.refund_status == 0}">
                                                        <span class="refund-badge refund-pending">
                                                            <i class="fas fa-undo"></i> Chờ hoàn tiền
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${o.refund_status == 1}">
                                                        <span class="refund-badge refund-success">
                                                            <i class="fas fa-check"></i> Đã hoàn tiền
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${o.refund_status == 2}">
                                                        <span class="refund-badge refund-rejected">
                                                            <i class="fas fa-ban"></i> Từ chối hoàn tiền
                                                        </span>
                                                    </c:when>
                                                </c:choose>
                                            </c:if>
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

                                            <c:if test="${o.refund_status == 2 and not empty o.refund_reason_admin}">
                                                <div class="refund-reason-box" style="color: #c62828; font-style: italic; margin-bottom: 8px;">
                                                    Lý do từ chối: ${o.refund_reason_admin}
                                                </div>
                                            </c:if>

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

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<script>
    async function cancelOrderAjax(orderId, btnElement) {
        const {
            value: reason, isConfirmed
        } = await Swal.fire( {
            title: 'Hủy đơn hàng #' + orderId,
            input: 'select',
            inputOptions: {
                'Thay đổi ý định': 'Thay đổi ý định',
                'Tìm thấy giá rẻ hơn': 'Tìm thấy giá rẻ hơn',
                'Đặt trùng đơn': 'Đặt trùng đơn',
                'Thời gian giao hàng quá lâu': 'Thời gian giao hàng quá lâu',
                'Khác': 'Lý do khác'
            },
            inputPlaceholder: 'Vui lòng chọn lý do hủy',
            showCancelButton: true,
            confirmButtonColor: '#fca120',
            cancelButtonColor: '#6c757d',
            confirmButtonText: 'Xác nhận hủy',
            cancelButtonText: 'Đóng',
            inputValidator: (value) => {
                return new Promise((resolve) => {
                    if(value) {
                        resolve();
                    } else {
                        resolve('Bạn cần chọn lý do để hủy đơn!');
                    }
                });
            }
        });

        if(isConfirmed && reason) {

            // const originalText = btnElement.innerText;
            btnElement.disabled = true;
            btnElement.style.opacity = '0.8';

            // gửi request
            const params = new URLSearchParams();
            params.append('action', 'cancelOrder');
            params.append('orderId', orderId);
            params.append('reason', reason);

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
                        Swal.fire('Thành công!', data.message, 'success').then(() => {
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
                        })

                    } else {
                        Swal.fire('Thất bại', data.message, 'error');
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