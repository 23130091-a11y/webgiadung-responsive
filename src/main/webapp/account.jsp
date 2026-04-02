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
    <link
            href="https://fonts.googleapis.com/css2?family=Open+Sans:ital,wght@0,300..800;1,300..800&family=Poppins:ital,wght@0,300;0,400;0,500;0,600;0,700;1,300;1,400;1,500;1,600;1,700&display=swap"
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
    <link rel="stylesheet" href="assets/css/account.css">


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
                                          class="account__link ${tab == 'address' ? 'account__link--active' : ''}">Địa chỉ</a>
                                </li>
                                <li class="account__item">
                                    <a href="${pageContext.request.contextPath}/account?tab=password"
                                         class="account__link ${tab == 'password' ? 'account__link--active' : ''}">Đổi mật khẩu</a>
                                </li>
                            </ul>
                        </section>


                        <section class="account__section">
                            <h2 class="account__title">Yêu thích</h2>
                            <ul class="account__list">
                                <li class="account__item">
                                    <a href="${pageContext.request.contextPath}/account?tab=favorite"
                                        class="account__link ${tab == 'favorite' ? 'account__link--active' : ''}">Sản phẩm đã thích</a>
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
                                Đơn đang xử lý
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
                                Đơn đã hủy
                              </a>
                            </li>
                          </ul>
                        </section>



                    </aside>
                </div>


                <div class="col l-10 m-12 c-12">
                    <c:if test="${tab == 'info'}">
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
                     </c:if>

                    <c:if test="${tab == 'address'}">
                    <section class="account__content">
                        <h2 class="account__heading">Địa chỉ</h2>

                        <form id="addressForm" class="account__form" action="${pageContext.request.contextPath}/account" method="post">
                            <input type="hidden" name="action" value="updateProfile">
                            <input type="hidden" name="tab" value="address">


                            <div class="account__form-group">
                                <label for="tinh" class="account__label">Tỉnh/thành phố</label>
                                <select id="tinh" name="tinh" class="account__select" required>
                                    <option value="">Chọn tỉnh/thành phố</option>
                                    <option value="HN">Hà Nội</option>
                                    <option value="HCM">TP. Hồ Chí Minh</option>
                                    <option value="DN">Đà Nẵng</option>
                                </select>
                            </div>

                            <!-- Quận/huyện -->
                            <div class="account__form-group">
                                <label for="huyen" class="account__label">Quận/huyện</label>
                                <select id="huyen" name="huyen" class="account__select" required>
                                    <option value="">Chọn quận/huyện</option>
                                    <option value="Q1">Quận 1</option>
                                    <option value="Q3">Quận 3</option>
                                    <option value="Q5">Quận 5</option>
                                </select>
                            </div>

                            <!-- Địa chỉ (LƯU VÀO users.address) -->
                            <div class="account__form-group">
                                <label for="diachi" class="account__label">Địa chỉ</label>
                                <input type="text" id="diachi" name="address" class="account__input"
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
                     </c:if>

                    <c:if test="${tab == 'password'}">
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
                     </c:if>




                   <c:if test="${tab == 'all'}">
                     <section class="account__content">
                     <h2 class="account__heading">Tất cả đơn hàng</h2>
                       <c:if test="${empty ordersAll}">
                         <div class="order-empty">Chưa có đơn hàng.</div>
                       </c:if>

                       <c:forEach var="o" items="${ordersAll}">
                         <article class="order-item">
                           <header class="order-item__header">
                             <div class="order-item__info">
                               <div>Mã đơn: #${o.id}</div>
                               <div>Ngày đặt:
                                 <fmt:formatDate value="${o.created_at}" pattern="dd/MM/yyyy HH:mm"/>
                               </div>
                             </div>

                             <c:choose>
                               <c:when test="${o.status_transport == 0}">
                                 <span class="order-item__status order-item__status--processing">Đang xử lý</span>
                               </c:when>
                               <c:when test="${o.status_transport == 1}">
                                 <span class="order-item__status order-item__status--delivered">Đã giao</span>
                               </c:when>
                               <c:when test="${o.status_transport == 3}">
                                 <span class="order-item__status order-item__status--cancelled">Đã hủy</span>
                               </c:when>
                               <c:otherwise>
                                 <span class="order-item__status">Không rõ</span>
                               </c:otherwise>
                             </c:choose>
                           </header>

                           <section class="order-item__body">
                             <c:forEach var="it" items="${orderItemsMap[o.id]}">
                               <div class="order-product">
                                 <div class="order-product__info">
                                   <h4 class="order-product__name">${it.product_name}</h4>
                                   <span class="order-product__quantity">x ${it.quantity}</span>
                                 </div>
                                 <div class="order-product__price-wrap">
                                   <span class="order-product__final-price">
                                     <fmt:formatNumber value="${it.total_price}" type="number" maxFractionDigits="0"/>đ
                                   </span>
                                 </div>
                               </div>
                             </c:forEach>
                           </section>

                           <footer class="order-item__footer">
                             <div class="order-item__total">
                               <span>Thành tiền:</span>
                               <span class="order-item__total-price">
                                 <fmt:formatNumber value="${o.total_price}" type="number" maxFractionDigits="0"/>đ
                               </span>
                             </div>

                             <c:if test="${o.status_transport == 0}">
                               <form method="post" action="${pageContext.request.contextPath}/account" style="display:inline;">
                                 <input type="hidden" name="action" value="cancelOrder"/>
                                 <input type="hidden" name="orderId" value="${o.id}"/>
                                 <input type="hidden" name="tab" value="all"/>
                                 <button type="submit" class="order-item__action-btn"
                                         onclick="return confirm('Bạn muốn hủy đơn #${o.id}?');">Hủy đơn</button>
                               </form>
                             </c:if>
                           </footer>
                         </article>
                       </c:forEach>
                     </section>
                   </c:if>



                   <c:if test="${tab == 'processing'}">
                     <section id="orders-processing" class="account__content">
                       <h2 class="account__heading">Đơn đang xử lý</h2>

                       <c:if test="${empty ordersProcessing}">
                         <div class="order-empty">Không có đơn đang xử lý.</div>
                       </c:if>

                       <c:forEach var="o" items="${ordersProcessing}">
                         <article class="order-item">
                           <header class="order-item__header">
                             <div class="order-item__info">
                               <span class="order-item__id">Mã đơn: #${o.id}</span>
                               <span class="order-item__date">
                                 Ngày đặt: <fmt:formatDate value="${o.created_at}" pattern="dd/MM/yyyy HH:mm"/>
                               </span>
                             </div>
                             <span class="order-item__status order-item__status--processing">Đang xử lý</span>
                           </header>

                           <section class="order-item__body">
                             <c:forEach var="it" items="${orderItemsMap[o.id]}">
                               <div class="order-product">
                                 <div class="order-product__info">
                                   <h4 class="order-product__name">${it.product_name}</h4>
                                   <span class="order-product__quantity">x ${it.quantity}</span>
                                 </div>
                                 <div class="order-product__price-wrap">
                                   <span class="order-product__final-price">
                                     <fmt:formatNumber value="${it.total_price}" type="number" maxFractionDigits="0"/>đ
                                   </span>
                                 </div>
                               </div>
                             </c:forEach>
                           </section>

                           <footer class="order-item__footer">
                             <div class="order-item__total">
                               <span class="order-item__total-label">Thành tiền:</span>
                               <span class="order-item__total-price">
                                 <fmt:formatNumber value="${o.total_price}" type="number" maxFractionDigits="0"/>đ
                               </span>
                             </div>
                             <form method="post" action="${pageContext.request.contextPath}/account" style="display:inline;">
                               <input type="hidden" name="action" value="cancelOrder"/>
                               <input type="hidden" name="orderId" value="${o.id}"/>
                               <input type="hidden" name="tab" value="processing"/>
                               <button type="submit" class="order-item__action-btn"
                                       onclick="return confirm('Bạn muốn hủy đơn #${o.id}?');">Hủy đơn</button>
                             </form>
                           </footer>
                         </article>
                       </c:forEach>
                     </section>
                   </c:if>



                   <c:if test="${tab == 'delivered'}">
                     <section id="orders-delivered" class="account__content">
                       <h2 class="account__heading">Đơn đã giao</h2>

                       <c:if test="${empty ordersDelivered}">
                         <div class="order-empty">Không có đơn đã giao.</div>
                       </c:if>

                       <c:forEach var="o" items="${ordersDelivered}">
                         <article class="order-item">
                           <header class="order-item__header">
                             <div class="order-item__info">
                               <span class="order-item__id">Mã đơn: #${o.id}</span>
                               <span class="order-item__date">
                                 Ngày đặt: <fmt:formatDate value="${o.created_at}" pattern="dd/MM/yyyy HH:mm"/>
                               </span>
                             </div>
                             <span class="order-item__status order-item__status--delivered">Đã giao</span>
                           </header>

                           <section class="order-item__body">
                             <c:forEach var="it" items="${orderItemsMap[o.id]}">
                               <div class="order-product">
                                 <div class="order-product__info">
                                   <h4 class="order-product__name">${it.product_name}</h4>
                                   <span class="order-product__quantity">x ${it.quantity}</span>
                                 </div>
                                 <div class="order-product__price-wrap">
                                   <span class="order-product__final-price">
                                     <fmt:formatNumber value="${it.total_price}" type="number" maxFractionDigits="0"/>đ
                                   </span>
                                 </div>
                               </div>
                             </c:forEach>
                           </section>

                           <footer class="order-item__footer">
                             <div class="order-item__total">
                               <span class="order-item__total-label">Thành tiền:</span>
                               <span class="order-item__total-price">
                                 <fmt:formatNumber value="${o.total_price}" type="number" maxFractionDigits="0"/>đ
                               </span>
                             </div>
                             <form method="post" action="${pageContext.request.contextPath}/account" style="display:inline;">
                               <input type="hidden" name="action" value="repurchase"/>
                               <input type="hidden" name="orderId" value="${o.id}"/>
                               <input type="hidden" name="redirect" value="checkout"/>
                               <input type="hidden" name="replaceCart" value="1"/>
                               <input type="hidden" name="tab" value="delivered"/>
                               <button type="submit" class="order-item__action-btn order-item__action-btn--primary">Mua lại</button>
                             </form>
                           </footer>
                         </article>
                       </c:forEach>
                     </section>
                   </c:if>



                   <c:if test="${tab == 'cancelled'}">
                     <section id="orders-cancelled" class="account__content">
                       <h2 class="account__heading">Đơn đã hủy</h2>

                       <c:if test="${empty ordersCancelled}">
                         <div class="order-empty">Không có đơn đã hủy.</div>
                       </c:if>

                       <c:forEach var="o" items="${ordersCancelled}">
                         <article class="order-item">
                           <header class="order-item__header">
                             <div class="order-item__info">
                               <span class="order-item__id">Mã đơn: #${o.id}</span>
                               <span class="order-item__date">
                                 Ngày đặt: <fmt:formatDate value="${o.created_at}" pattern="dd/MM/yyyy HH:mm"/>
                               </span>
                             </div>
                             <span class="order-item__status order-item__status--cancelled">Đã hủy</span>
                           </header>

                           <section class="order-item__body">
                             <c:forEach var="it" items="${orderItemsMap[o.id]}">
                               <div class="order-product">
                                 <div class="order-product__info">
                                   <h4 class="order-product__name">${it.product_name}</h4>
                                   <span class="order-product__quantity">x ${it.quantity}</span>
                                 </div>
                                 <div class="order-product__price-wrap">
                                   <span class="order-product__final-price">
                                     <fmt:formatNumber value="${it.total_price}" type="number" maxFractionDigits="0"/>đ
                                   </span>
                                 </div>
                               </div>
                             </c:forEach>
                           </section>

                           <footer class="order-item__footer">
                             <div class="order-item__total">
                               <span class="order-item__total-label">Thành tiền:</span>
                               <span class="order-item__total-price">
                                 <fmt:formatNumber value="${o.total_price}" type="number" maxFractionDigits="0"/>đ
                               </span>
                             </div>
                            <form method="post" action="${pageContext.request.contextPath}/account" style="display:inline;">
                              <input type="hidden" name="action" value="repurchase"/>
                              <input type="hidden" name="orderId" value="${o.id}"/>
                              <input type="hidden" name="redirect" value="checkout"/>
                              <input type="hidden" name="replaceCart" value="1"/>
                              <input type="hidden" name="tab" value="cancelled"/>
                              <button type="submit" class="order-item__action-btn order-item__action-btn--primary">Mua lại</button>
                            </form>
                           </footer>
                         </article>
                       </c:forEach>
                     </section>
                   </c:if>


                    <c:if test="${tab == 'favorite'}">
                    <section class="account__content">
                        <h2 class="account__heading">Sản phẩm đã thích</h2>
                        <div class="favorite-product-list row small-gutter">
                            <div class="col l-3 m-4 c-6">
                                <div class="product-card">
                                    <a><img src="assets/img/giado.jpg" alt=""></a>
                                    <a>
                                        <p>Giá đỡ chuyển đổi máy cầm tay thành máy bàn chuyên dụng, đa năng và an
                                            toàn khi thao tác
                                        </p>
                                    </a>
                                    <div class="price-discount">
                                        <div class="price-top">
                                            <span class="old-price">390.000đ</span>
                                            <div class="discount-badge">Giảm 20%</div>
                                        </div>
                                        <div class="price-bottom">
                                            <span class="new-price">312.000đ</span>
                                        </div>
                                    </div>
                                    <div class="cart">
                                        <i class="fa-solid fa-cart-shopping content-details__cart-icon"></i>
                                        Thêm vào giỏ hàng
                                    </div>
                                    <div class="bottom">
                                        <div class="star"><i class="fa-solid fa-star"></i> 4.9</div>
                                        <button class="fav-btn"><i class="fa-solid fa-heart"></i> Yêu
                                            thích</button>
                                    </div>
                                </div>
                            </div>
                            <div class="col l-3 m-4 c-6">
                                <div class="product-card">
                                    <a><img src="assets/img/mayhutbui.jpg" alt=""></a>
                                    <a>
                                        <p>Máy hút bụi cầm tay không dây đa năng, nhỏ gọn, lực hút mạnh</p>
                                    </a>
                                    <div class="price-discount">
                                        <div class="price-top">
                                            <span class="old-price">552.000đ</span>
                                            <div class="discount-badge">Giảm 20%</div>
                                        </div>
                                        <div class="price-bottom">
                                            <span class="new-price">441.000đ</span>
                                        </div>
                                    </div>
                                    <div class="cart">
                                        <i class="fa-solid fa-cart-shopping content-details__cart-icon"></i>
                                        Thêm vào giỏ hàng
                                    </div>
                                    <div class="bottom">
                                        <div class="star"><i class="fa-solid fa-star"></i> 5</div>
                                        <button class="fav-btn"><i class="fa-solid fa-heart"></i> Yêu
                                            thích</button>
                                    </div>
                                </div>

                            </div>
                            <div class="col l-3 m-4 c-6">
                                <div class="product-card">
                                    <a><img src="assets/img/denhoc.jpg" alt=""></a>
                                    <a>
                                        <p>Đèn bàn học bóng LED chống cận bảo vệ mắt, Thân đèn</p>
                                    </a>
                                    <div class="price-discount">
                                        <div class="price-top">
                                            <span class="old-price">202.000đ</span>
                                            <div class="discount-badge">Giảm 15%</div>
                                        </div>
                                        <div class="price-bottom">
                                            <span class="new-price">171.000đ</span>
                                        </div>
                                    </div>
                                    <div class="cart">
                                        <i class="fa-solid fa-cart-shopping content-details__cart-icon"></i>
                                        Thêm vào giỏ hàng
                                    </div>
                                    <div class="bottom">
                                        <div class="star"><i class="fa-solid fa-star"></i> 4.6</div>
                                        <button class="fav-btn"><i class="fa-solid fa-heart"></i> Yêu
                                            thích</button>
                                    </div>
                                </div>

                            </div>
                            <div class="col l-3 m-4 c-6">
                                <div class="product-card">
                                    <a><img src="assets/img/candien.jpg" alt=""></a>
                                    <a>
                                        <p>Cân điện tử thông minh Xiaomi Smart Scale Gen 2</p>
                                    </a>
                                    <div class="price-discount">
                                        <div class="price-top">
                                            <span class="old-price">337.000đ</span>
                                            <div class="discount-badge">Giảm 25%</div>
                                        </div>
                                        <div class="price-bottom">
                                            <span class="new-price">252.000đ</span>
                                        </div>
                                    </div>
                                    <div class="cart">
                                        <i class="fa-solid fa-cart-shopping content-details__cart-icon"></i>
                                        Thêm vào giỏ hàng
                                    </div>
                                    <div class="bottom">
                                        <div class="star"><i class="fa-solid fa-star"></i> 4.7</div>
                                        <button class="fav-btn"><i class="fa-solid fa-heart"></i> Yêu
                                            thích</button>
                                    </div>
                                </div>
                            </div>
                            <div class="col l-3 m-4 c-6">
                                <div class="product-card">
                                    <a><img src="assets/img/tuixach.jpg" alt=""></a>
                                    <a>
                                        <p>Túi xách Reeyee RY302B/G 2 trong 1</p>
                                    </a>
                                    <div class="price-discount">
                                        <div class="price-top">
                                            <span class="old-price">1.120.000đ</span>
                                            <div class="discount-badge">Giảm 25%</div>
                                        </div>
                                        <div class="price-bottom">
                                            <span class="new-price">840.000đ</span>
                                        </div>
                                    </div>
                                    <div class="cart">
                                        <i class="fa-solid fa-cart-shopping content-details__cart-icon"></i>
                                        Thêm vào giỏ hàng
                                    </div>
                                    <div class="bottom">
                                        <div class="star"><i class="fa-solid fa-star"></i> 5</div>
                                        <button class="fav-btn"><i class="fa-solid fa-heart"></i> Yêu
                                            thích</button>
                                    </div>
                                </div>
                            </div>
                            <div class="col l-3 m-4 c-6">
                                <div class="product-card">
                                    <a><img src="assets/img/loadeban.jpg" alt=""></a>
                                    <a>
                                        <p>Loa để bàn mini nhỏ gọn âm thanh vượt trội</p>
                                    </a>
                                    <span class="price">162.000đ</span>
                                    <div class="cart">
                                        <i class="fa-solid fa-cart-shopping content-details__cart-icon"></i>
                                        Thêm vào giỏ hàng
                                    </div>
                                    <div class="bottom">
                                        <div class="star"><i class="fa-solid fa-star"></i> 4.6</div>
                                        <button class="fav-btn"><i class="fa-solid fa-heart"></i> Yêu
                                            thích</button>
                                    </div>
                                </div>
                            </div>
                            <div class="col l-3 m-4 c-6">
                                <div class="product-card">
                                    <a><img src="assets/img/keogiay.jpg" alt=""></a>
                                    <a>
                                        <p>Keo dán giày dép siêu dính trong suốt chuyên dụng 100gr</p>
                                    </a>
                                    <span class="price">128.000đ</span>
                                    <div class="cart">
                                        <i class="fa-solid fa-cart-shopping content-details__cart-icon"></i>
                                        Thêm vào giỏ hàng
                                    </div>
                                    <div class="bottom">
                                        <div class="star"><i class="fa-solid fa-star"></i> 4.8</div>
                                        <button class="fav-btn"><i class="fa-solid fa-heart"></i> Yêu
                                            thích</button>
                                    </div>
                                </div>
                            </div>
                            <div class="col l-3 m-4 c-6">
                                <div class="product-card">
                                    <a><img src="assets/img/balo.jpg" alt=""></a>
                                    <a>
                                        <p>Balo đựng sách vở, laptop,...cho học sinh,sinh viên vải dù cao cấp, Màu
                                            trắng khóa xanh</p>
                                    </a>
                                    <span class="price">228.000đ</span>
                                    <div class="cart">
                                        <i class="fa-solid fa-cart-shopping content-details__cart-icon"></i>
                                        Thêm vào giỏ hàng
                                    </div>
                                    <div class="bottom">
                                        <div class="star"><i class="fa-solid fa-star"></i> 5</div>
                                        <button class="fav-btn"><i class="fa-solid fa-heart"></i> Yêu
                                            thích</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </section>
                     </c:if>

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
  (function () {
    const f = document.getElementById("addressForm");
    if (!f) return;

    f.addEventListener("submit", function () {
      const tinh = document.getElementById("tinh");
      const huyen = document.getElementById("huyen");
      const diachi = document.getElementById("diachi");

      const tinhText = tinh && tinh.value ? tinh.options[tinh.selectedIndex].text : "";
      const huyenText = huyen && huyen.value ? huyen.options[huyen.selectedIndex].text : "";
      const soNha = diachi ? diachi.value.trim() : "";


      diachi.value = [soNha, huyenText, tinhText].filter(Boolean).join(", ");
    });
  })();
</script>
</html>