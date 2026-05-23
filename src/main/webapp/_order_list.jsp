<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:choose>
    <c:when test="${not empty orders}">
        <c:forEach var="order" items="${orders}">

            <c:set var="rowClass" value="order-item"/>
            <c:if test="${order.statusTransport == 4}"><c:set var="rowClass" value="order-item order-item--cancelled"/></c:if>
            <c:if test="${order.statusTransport == 3}"><c:set var="rowClass" value="order-item order-item--done"/></c:if>

            <c:set var="tBadge" value="order-status-badge badge-new"/>
            <c:set var="tIcon"  value="fa-circle-dot"/>
            <c:if test="${order.statusTransport == 1}"><c:set var="tBadge" value="order-status-badge badge-new"/>   <c:set var="tIcon" value="fa-check-circle"/></c:if>
            <c:if test="${order.statusTransport == 2}"><c:set var="tBadge" value="order-status-badge badge-ship"/>  <c:set var="tIcon" value="fa-truck"/></c:if>
            <c:if test="${order.statusTransport == 3}"><c:set var="tBadge" value="order-status-badge badge-done"/>  <c:set var="tIcon" value="fa-circle-check"/></c:if>
            <c:if test="${order.statusTransport == 4}"><c:set var="tBadge" value="order-status-badge badge-cancel"/><c:set var="tIcon" value="fa-ban"/></c:if>

            <c:set var="pBadge" value="order-payment-badge badge-unpaid"/>
            <c:set var="pIcon"  value="fa-clock"/>
            <c:if test="${order.statusPayment == 1}"><c:set var="pBadge" value="order-payment-badge badge-paid"/>       <c:set var="pIcon" value="fa-circle-check"/></c:if>
            <c:if test="${order.statusPayment == 2}"><c:set var="pBadge" value="order-payment-badge badge-processing"/> <c:set var="pIcon" value="fa-spinner"/></c:if>

            <article class="${rowClass}">

                <div class="order-item__cell">
                    <input type="checkbox" name="orderIds" value="${order.id}" class="order-item__checkbox">
                </div>

                <div class="order-item__cell">
                    <span class="order-item__id">#${order.id}</span>
                </div>

                <div class="order-item__cell" style="align-items:flex-start;padding-left:16px;">
                    <span class="order-item__name">${order.customerName}</span>
                </div>

                <div class="order-item__cell">
                    <span class="${tBadge}">
                        <i class="fa-solid ${tIcon}"></i> ${order.statusTransportText}
                    </span>
                    <form action="<c:url value='/order-update-status'/>" method="post" class="form-update-status" style="width:100%;">
                        <input type="hidden" name="orderId" value="${order.id}">
                        <input type="hidden" name="type" value="transport">
                        <select name="status" ${order.statusTransport == 3 || order.statusTransport == 4 ? 'disabled' : ''}>
                            <option value="0" ${order.statusTransport == 0 ? 'selected' : ''}>Đơn hàng mới</option>
                            <option value="1" ${order.statusTransport == 1 ? 'selected' : ''}>Đã xác nhận</option>
                            <option value="2" ${order.statusTransport == 2 ? 'selected' : ''}>Đang giao</option>
                            <option value="3" ${order.statusTransport == 3 ? 'selected' : ''}>Đã giao</option>
                            <option value="4" ${order.statusTransport == 4 ? 'selected' : ''}>Đã hủy</option>
                        </select>
                        <button type="submit" class="btn-save ${order.statusTransport == 3 || order.statusTransport == 4 ? 'btn-save--saved' : ''}"
                            ${order.statusTransport == 3 || order.statusTransport == 4 ? 'disabled' : ''}>
                            <i class="fa-solid fa-floppy-disk"></i> Lưu
                        </button>
                    </form>
                </div>

                <div class="order-item__cell">
                    <span class="${pBadge}">
                        <i class="fa-solid ${pIcon}"></i> ${order.statusPaymentText}
                    </span>
                    <form action="<c:url value='/order-update-status'/>" method="post" class="form-update-status" style="width:100%;">
                        <input type="hidden" name="orderId" value="${order.id}">
                        <input type="hidden" name="type" value="payment">
                        <select name="status" ${order.statusPayment == 1 ? 'disabled' : ''}>
                            <option value="0" ${order.statusPayment == 0 ? 'selected' : ''}>Chưa thanh toán</option>
                            <option value="1" ${order.statusPayment == 1 ? 'selected' : ''}>Đã thanh toán</option>
                        </select>
                        <button type="submit" class="btn-save ${order.statusPayment == 1 ? 'btn-save--saved' : ''}"
                            ${order.statusPayment == 1 ? 'disabled' : ''}>
                            <i class="fa-solid fa-floppy-disk"></i> Lưu
                        </button>
                    </form>
                </div>

                <div class="order-item__cell">
                    <span class="order-item__date">${order.createdAt}</span>
                </div>

                <div class="order-item__cell">
                    <span class="order-item__total">${order.totalPrice}đ</span>
                </div>

            </article>
        </c:forEach>
    </c:when>
    <c:otherwise>
        <div class="order-empty-state">
            <i class="fa-solid fa-box-open"></i>
            <p>Không tìm thấy đơn hàng nào</p>
        </div>
    </c:otherwise>
</c:choose>
