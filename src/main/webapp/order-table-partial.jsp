<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%--
  Created by IntelliJ IDEA.
  User: nguye
  Date: 10/01/2026
  Time: 2:40 CH
  To change this template use File | Settings | File Templates.
--%>
    <!-- Row -->
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
                <span class="order-table__status ${order.statusTransportClass}">
                        ${order.statusTransportText}
                </span>
            </div>

            <div class="order-table__cell">
                <span class="order-table__status ${order.statusPaymentClass}">
                        ${order.statusPaymentText}
                </span>
            </div>

            <div class="order-table__cell">${order.createdAt}</div>

            <div class="order-table__cell">${order.totalPrice}đ</div>
        </article>
    </c:forEach>

