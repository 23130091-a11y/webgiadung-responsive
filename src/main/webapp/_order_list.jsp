<%--
  Created by IntelliJ IDEA.
  User: nguye
  Date: 28/01/2026
  Time: 9:53 CH
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="order-table__header">
    <h3 class="order-table__heading">Danh sách đơn hàng</h3>
    <button type="button" id="btnDeleteAll" class="btn btn--default-color order-table__btn">
        Xóa các mục đã chọn
    </button>
</div>

<div class="order-table__inner">
    <div class="order-table__row">
        <div class="order-table__check">
            <input type="checkbox" id="selectAll" class="order-table__checkbox">
        </div>
        <div class="order-table__cell">Mã</div>
        <div class="order-table__cell">Khách hàng</div>
        <div class="order-table__cell">Trạng thái</div>
        <div class="order-table__cell">Thanh toán</div>
        <div class="order-table__cell">Ngày tạo</div>
        <div class="order-table__cell">Tổng tiền</div>
    </div>
    <c:choose>
        <%-- TRƯỜNG HỢP: CÓ ĐƠN HÀNG --%>
        <c:when test="${not empty orders}">
            <c:forEach var="order" items="${orders}">
                <article class="order-table__row ${order.rowClass}">
                    <div class="order-table__check">
                        <input type="checkbox" name="orderIds" value="${order.id}" class="order-table__checkbox">
                    </div>

                    <div class="order-table__cell">
                        <a href="#!" class="order-table__text order-table__link">${order.id}</a>
                    </div>

                    <div class="order-table__cell">
                        <span class="order-table__text">${order.customerName}</span>
                    </div>

                    <div class="order-table__cell">
                        <span class="order-table__status ${order.statusTransportClass}">${order.statusTransportText}</span>
                        <form action="<c:url value='/order-update-status'/>" method="post" class="form-update-status">
                            <input type="hidden" name="orderId" value="${order.id}">
                            <input type="hidden" name="type" value="transport">

                            <select name="status" ${order.statusTransport == 3 || order.statusTransport == 4 ? 'disabled' : ''}>
                                <option value="0" ${order.statusTransport == 0 ? 'selected' : ''}>Đơn hàng mới</option>
                                <option value="1" ${order.statusTransport == 1 ? 'selected' : ''}>Đã xác nhận</option>
                                <option value="2" ${order.statusTransport == 2 ? 'selected' : ''}>Đang giao</option>
                                <option value="3" ${order.statusTransport == 3 ? 'selected' : ''}>Đã giao</option>
                                <option value="4" ${order.statusTransport == 4 ? 'selected' : ''}>Đã hủy</option>
                            </select>

                            <button type="submit" class="btn btn--default-color"
                                ${order.statusTransport == 3 || order.statusTransport == 4 ? 'disabled' : ''}>
                                Lưu
                            </button>
                        </form>
                    </div>

                    <div class="order-table__cell">
                        <span class="order-table__status ${order.statusPaymentClass}">${order.statusPaymentText}</span>
                        <form action="<c:url value='/order-update-status'/>" method="post" class="form-update-status">
                            <input type="hidden" name="orderId" value="${order.id}">
                            <input type="hidden" name="type" value="payment">
                            <select name="status" ${order.statusPayment == 1 ? 'disabled' : ''}>
                                <option value="0" ${order.statusPayment == 0 ? 'selected' : ''}>Chưa thanh toán</option>
                                <option value="1" ${order.statusPayment == 1 ? 'selected' : ''}>Đã thanh toán</option>
                            </select>
                            <button type="submit" class="btn btn--default-color" ${order.statusPayment == 1 ? 'disabled' : ''}>Lưu</button>
                        </form>
                    </div>

                    <div class="order-table__cell">${order.createdAt}</div>
                    <div class="order-table__cell">${order.totalPrice}đ</div>
                </article>
            </c:forEach>
        </c:when>

        <%-- TRƯỜNG HỢP: KHÔNG TÌM THẤY ĐƠN HÀNG --%>
        <c:otherwise>
            <div class="order-table__empty" style="padding: 40px; text-align: center;">
                <p style="margin-top: 15px; color: #666; font-size: 1.6rem;">
                    Không tìm thấy đơn hàng nào
                </p>
            </div>
        </c:otherwise>
    </c:choose>
</div>

