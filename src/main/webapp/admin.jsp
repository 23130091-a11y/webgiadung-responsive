<%--
  Created by IntelliJ IDEA.
  User: nguye
  Date: 07/12/2025
  Time: 3:05 CH
  To change this template use File | Settings | File Templates.
--%>
<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trang admin</title>

    <!-- Link Reset CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/reset.css">
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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/grid.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css?v=200">
    <!-- Include stylesheet -->
    <link href="https://cdn.jsdelivr.net/npm/quill@2.0.3/dist/quill.snow.css" rel="stylesheet" />
</head>
<body>
<header class="header">
    <div class="grid wide">
        <nav class="navbar">
            <ul class="navbar__list">
                <li class="navbar__item">
                    <span class="navbar__greeting">Xin chào Admin</span>
                </li>
            </ul>

            <ul class="navbar__list">
                <li class="navbar__item">
                    <i class="navbar__icon fa-solid fa-house"></i>
                    <a href="${pageContext.request.contextPath}/list-product" class="navbar__link">Trang chủ</a>
                </li>
                <li class="navbar__item">
                    <i class="navbar__icon fa-solid fa-right-from-bracket"></i>
                    <a href="${pageContext.request.contextPath}/logout" class="navbar__link">Đăng xuất</a>
                </li>
            </ul>
        </nav>
    </div>
</header>

<main class="main">
    <div class="manage">
        <div class="grid wide">
            <div class="row small-gutter">
                <div class="col l-2 m-0 c-0">
                    <section class="manage-nav">
                        <h2 class="manage__heading">Danh mục quản lý</h2>

                        <ul class="manage-nav__list">
                            <li class="manage-nav__item">
                                <a href="${pageContext.request.contextPath}/admin/revenue"
                                   class="manage-nav__link ${tab == 'config' ? 'manage-nav__link--active' : ''}">
                                    Quản lý doanh thu
                                </a>
                            </li>
                            <li class="manage-nav__item">
                                <a href="#warehouse" class="manage-nav__link">Vận hành kho</a>
                            </li>
                            <li class="manage-nav__item">
                                <a href="#news" class="manage-nav__link">Tin tức</a>
                            </li>
                            <li class="manage-nav__item">
                                <a href="${pageContext.request.contextPath}/admin/customers" class="manage-nav__link">Khách hàng</a>

                            </li>

                            <li class="manage-nav__item">
                                <a href="${pageContext.request.contextPath}/admin/purchase-history"
                                   class="manage-nav__link ${tab == 'purchaseHistory' ? 'manage-nav__link--active' : ''}">
                                    Lịch sử mua hàng
                                </a>
                            </li>

                            <li class="manage-nav__item">
                                <a href="#product" class="manage-nav__link">Sản phẩm</a>
                            </li>
                            <li class="manage-nav__item">
                                <a href="${pageContext.request.contextPath}/order-admin" class="manage-nav__link">Đơn hàng</a>
                            </li>
                        </ul>

                    </section>
                </div>

                <div class="col l-10 m-12 c-12">
                    <section id="warehouse" class="manage-detail" style="display:none;">
                        <div class="sub-tab-container">
                            <div class="sub-tab-item active" onclick="switchSubTab(event, 'tab-inbound')">Nhập hàng</div>
                            <div class="sub-tab-item" onclick="switchSubTab(event, 'tab-damage')">Quản lý hàng hư hỏng</div>
                            <div class="sub-tab-item" onclick="switchSubTab(event, 'tab-transactions')">Sổ vận hành kho</div>
                        </div>

                        <div class="warehouse-content-wrapper">
                            <div id="tab-inbound" class="sub-tab-content active">
                                <div class="warehouse-grid">

                                    <div class="low-stock-panel">
                                        <h3 class="panel-title">Hàng sắp hết</h3>
                                        <div id="low-stock-list">
                                            <p style="text-align: center; padding: 20px; color: #888;">Đang tải danh sách...</p>
                                        </div>
                                    </div>
                                    <div class="inbound-main">
                                        <div class="inbound-form-card">
                                            <h3 style="margin-bottom: 20px; color: var(--primary-color);">Tạo Phiếu Nhập Kho</h3>

                                            <div class="search-product-box">
                                                <label>Tìm kiếm sản phẩm để nhập:</label>
                                                <div class="search-input-wrapper">
                                                    <input type="text" id="search-prod" placeholder="Gõ tên sản phẩm..." onkeyup="handleProductSearch(this.value)">
                                                    <div id="search-dropdown" class="search-results-dropdown" style="display:none;">
                                                        <div class="search-item" onclick="onSelectProduct('Nồi cơm Sunhouse 1.8L', 5, 'https://via.placeholder.com/100', 450000)">
                                                            <img src="https://via.placeholder.com/40">
                                                            <span>Nồi cơm Sunhouse 1.8L - (Hệ thống còn: 5)</span>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="inbound-detail-fields">
                                                <div class="form-row">
                                                    <div class="form-group">
                                                        <label>Mã phiếu nhập</label>
                                                        <input type="text" id="receipt-code" readonly class="readonly-bg" placeholder="Hệ thống tự tạo...">
                                                    </div>
                                                    <div class="form-group">
                                                        <label>Nhà cung cấp</label>
                                                        <input type="text" id="supplier-name" placeholder="Ví dụ: Công ty Sunhouse...">
                                                    </div>
                                                </div>

                                                <div id="selected-product-box" class="selected-product-display">
                                                    <img id="display-img" src="https://via.placeholder.com/100" alt="Ảnh">
                                                    <div class="display-text">
                                                        <h4 id="display-name">Chưa chọn sản phẩm</h4>
                                                        <p>Số tồn kho hệ thống (trước nhập): <strong id="display-pre-stock">0</strong></p>
                                                    </div>
                                                </div>

                                                <div class="form-row">
                                                    <div class="form-group">
                                                        <label>Số lượng nhập thêm thực tế</label>
                                                        <input type="number" id="import-qty" placeholder="0" oninput="calculateTotalPrice()">
                                                    </div>
                                                    <div class="form-group">
                                                        <label>Giá nhập đợt này (đ)</label>
                                                        <input type="number" id="unit-cost" placeholder="0" oninput="calculateTotalPrice()">
                                                    </div>
                                                </div>

                                                <div class="form-group" style="margin-top: 15px; margin-bottom: 10px;">
                                                    <label>Thành tiền dự kiến (đ)</label>
                                                    <input type="text" id="total-price-display" readonly class="readonly-bg"
                                                           style="font-weight: bold; color: #f39c12; font-size: 1.1rem;" value="0">
                                                </div>
                                            </div>

                                            <button class="btn-confirm-warehouse">XÁC NHẬN NHẬP KHO & CẬP NHẬT TỒN</button>
                                        </div>

                                        <div class="inbound-history-list">
                                            <h3 style="margin: 25px 0 15px 0; color: #333;">Lịch sử các đợt nhập hàng</h3>
                                            <table class="warehouse-table">
                                                <thead>
                                                <tr>
                                                    <th>Ngày nhập</th>
                                                    <th>Mã phiếu</th>
                                                    <th>Tên sản phẩm</th>
                                                    <th>Số lượng</th>
                                                    <th>Tổng tiền</th>
                                                    <th>Tổng tồn sau nhập</th>
                                                    <th>Thao tác</th>
                                                </tr>
                                                </thead>
                                                <tbody id="inbound-table-body">
                                                <tr>
                                                    <td colspan="7" style="text-align: center; padding: 20px; color: #888;">
                                                        Đang tải dữ liệu...
                                                    </td>
                                                </tr>
                                                </tbody>
                                            </table>
                                        </div>

                                        <div id="inbound-detail-modal" class="custom-modal" style="display: none;">
                                            <div class="modal-content">

                                                <div class="modal-header">
                                                    <h4>Chi tiết phiếu nhập: <span id="modal-code" style="color: #007bff;"></span></h4>
                                                    <span class="close-btn" onclick="closeInboundModal()">&times;</span>
                                                </div>

                                                <div class="modal-body">
                                                    <div class="modal-img-wrapper">
                                                        <img id="modal-img" src="" alt="Ảnh sản phẩm">
                                                    </div>

                                                    <div class="modal-info">
                                                        <p><strong>Tên sản phẩm:</strong> <span id="modal-name"></span></p>
                                                        <p><strong>Nhà cung cấp:</strong> <span id="modal-supplier"></span></p>
                                                        <p><strong>Thời gian nhập:</strong> <span id="modal-date"></span></p>

                                                        <hr>

                                                        <p><strong>Tồn kho cũ (trước nhập):</strong> <span id="modal-pre-stock"></span></p>
                                                        <p><strong>Số lượng nhập:</strong> <strong style="color: #28a745; font-size: 16px;">+<span id="modal-qty"></span></strong></p>
                                                        <p><strong>Đơn giá nhập:</strong> <span id="modal-unit-cost"></span></p>
                                                        <p style="font-size: 16px; margin-top: 5px;">
                                                            <strong>Tổng tiền:</strong> <strong style="color: #d9534f;" id="modal-total"></strong>
                                                        </p>
                                                    </div>
                                                </div>

                                                <div class="modal-footer">
                                                    <button class="btn-close-modal" onclick="closeInboundModal()">Đóng</button>
                                                </div>

                                            </div>
                                        </div>
                                </div>
                            </div>
                            </div>

                            <div id="tab-damage" class="sub-tab-content">
                                <div class="dmg-grid-layout">
                                    <div class="dmg-main-section">
                                        <div class="dmg-card-panel">

                                            <div class="dmg-search-area">
                                                <label>Tìm kiếm sản phẩm hoặc mã đơn hàng:</label>
                                                <div class="dmg-input-group">
                                                    <input type="text" id="search-dmg-input" placeholder="Nhập tên SP hoặc mã ĐH..." onkeyup="handleDamageSearch(this.value)">
                                                    <div id="search-dmg-dropdown" class="dmg-dropdown-list" style="display:none;">
                                                    </div>
                                                </div>
                                            </div>

                                            <div id="selected-dmg-preview" class="dmg-preview-box">
                                                <img id="dmg-preview-img" src="${pageContext.request.contextPath}/assets/img/products/default.png" alt="Ảnh">
                                                <div class="dmg-preview-info">
                                                    <h4 id="dmg-preview-name">Chưa chọn sản phẩm</h4>
                                                </div>
                                            </div>

                                            <div class="dmg-form-fields">
                                                <div class="dmg-row">
                                                    <div class="dmg-col">
                                                        <label>Số lượng hư hỏng</label>
                                                        <input type="number" id="dmg-qty-input" placeholder="0">
                                                    </div>
                                                </div>

                                                <div class="dmg-full-row" style="margin-top: 15px;">
                                                    <label>Ghi chú & Lý do</label>
                                                    <textarea id="dmg-note-area" rows="3" placeholder="Nhập lý do chi tiết tại đây..."></textarea>
                                                </div>
                                            </div>

                                            <button class="dmg-btn-submit">XÁC NHẬN HOÀN TẤT</button>
                                        </div>

                                        <div class="dmg-history-section">
                                            <h3 style="margin: 25px 0 15px 0; color: #333;">Danh sách đã xử lý</h3>
                                            <table class="dmg-data-table">
                                                <thead>
                                                <tr>
                                                    <th>Ngày báo cáo</th>
                                                    <th>Tên SP / Mã ĐH</th>
                                                    <th>Số lượng</th>
                                                    <th>Hiện trạng</th>
                                                    <th>Lý do</th>
                                                    <th>Phục hồi</th> <th>Thao tác</th>
                                                </tr>
                                                </thead>
                                                <tbody id="damage-table-body">
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div id="tab-transactions" class="sub-tab-content"><h3>Sổ kho (Transactions)</h3></div>
                        </div>
                    </section>
                    <section id="config" class="manage-detail">
                        <h2 class="manage__heading">Quản lý doanh thu</h2>

                        <div class="revenue-page">
                            <div class="revenue-card">
                                <div class="revenue-card__header">
                                    <div>
                                        <h3 class="revenue-title">Báo cáo doanh thu cửa hàng</h3>
                                        <p class="revenue-subtitle">
                                            Theo dõi doanh thu, tỷ lệ hủy, so sánh bán ra theo tháng và hiệu quả từng đợt nhập hàng.
                                        </p>
                                    </div>
                                </div>

                                <form class="revenue-filter" method="get" action="${pageContext.request.contextPath}/admin/revenue">
                                    <div class="revenue-filter__group">
                                        <label>Từ ngày</label>
                                        <input type="date" name="fromDate" value="${fromDate}">
                                    </div>

                                    <div class="revenue-filter__group">
                                        <label>Đến ngày</label>
                                        <input type="date" name="toDate" value="${toDate}">
                                    </div>

                                    <div class="revenue-filter__group">
                                        <label>Trạng thái đơn</label>
                                        <select name="status">
                                            <option value="" ${empty status ? 'selected' : ''}>Tất cả</option>
                                            <option value="done" ${status == 'done' ? 'selected' : ''}>Hoàn tất</option>
                                            <option value="shipping" ${status == 'shipping' ? 'selected' : ''}>Đang giao</option>
                                            <option value="pending" ${status == 'pending' ? 'selected' : ''}>Chờ xử lý</option>
                                            <option value="cancelled" ${status == 'cancelled' ? 'selected' : ''}>Đã hủy</option>
                                        </select>
                                    </div>

                                    <div class="revenue-filter__group">
                                        <label>Tháng A</label>
                                        <input type="month" name="monthA" value="${monthA}">
                                    </div>

                                    <div class="revenue-filter__group">
                                        <label>Tháng B</label>
                                        <input type="month" name="monthB" value="${monthB}">
                                    </div>

                                    <div class="revenue-filter__actions">
                                        <button type="submit" class="btn-ui btn-ui--primary">Lọc dữ liệu</button>
                                        <a href="${pageContext.request.contextPath}/admin/revenue" class="btn-ui btn-ui--ghost">Đặt lại</a>
                                    </div>
                                </form>

                                <div class="revenue-summary">
                                    <div class="revenue-box">
                                        <span class="revenue-box__label">Doanh thu hôm nay</span>
                                        <strong class="revenue-box__value">
                                            <fmt:formatNumber value="${revenueSummary['today_revenue']}" type="number" groupingUsed="true"/> đ
                                        </strong>
                                    </div>

                                    <div class="revenue-box">
                                        <span class="revenue-box__label">Doanh thu tháng ${monthALabel}</span>
                                        <strong class="revenue-box__value">
                                            <fmt:formatNumber value="${revenueSummary['month_a_revenue']}" type="number" groupingUsed="true"/> đ
                                        </strong>
                                    </div>

                                    <div class="revenue-box">
                                        <span class="revenue-box__label">Doanh thu tháng ${monthBLabel}</span>
                                        <strong class="revenue-box__value">
                                            <fmt:formatNumber value="${revenueSummary['month_b_revenue']}" type="number" groupingUsed="true"/> đ
                                        </strong>
                                    </div>

                                    <div class="revenue-box">
                                        <span class="revenue-box__label">Tổng đơn hàng</span>
                                        <strong class="revenue-box__value">
                                            <fmt:formatNumber value="${revenueSummary['total_orders']}" type="number" groupingUsed="true"/>
                                        </strong>
                                    </div>

                                    <div class="revenue-box revenue-box--danger-soft">
                                        <span class="revenue-box__label">Đơn đã hủy</span>
                                        <strong class="revenue-box__value revenue-box__value--danger">
                                            <fmt:formatNumber value="${revenueSummary['cancelled_orders']}" type="number" groupingUsed="true"/>
                                        </strong>
                                    </div>

                                    <div class="revenue-box revenue-box--danger-soft">
                                        <span class="revenue-box__label">Tỉ lệ hủy đơn</span>
                                        <strong class="revenue-box__value revenue-box__value--danger">
                                            <fmt:formatNumber value="${revenueSummary['cancel_rate']}" type="number" groupingUsed="true" minFractionDigits="0" maxFractionDigits="2"/>%
                                        </strong>
                                    </div>
                                    <div class="revenue-box revenue-box--success-soft">
                                        <span class="revenue-box__label">Tỉ lệ hoàn tất</span>
                                        <strong class="revenue-box__value revenue-box__value--success">
                                            <fmt:formatNumber value="${completionRate}" type="number" groupingUsed="true"
                                                              minFractionDigits="1" maxFractionDigits="1"/>%
                                        </strong>
                                    </div>
                                </div>
                                <div class="rv-accordion">

                                    <div class="rv-panel is-open" id="rv-chart">
                                        <div class="rv-panel__head" onclick="toggleRvPanel(this)">
                                            <div class="rv-panel__head-left">
                                                <span class="rv-panel__icon rv-panel__icon--orange"><i class="fa-solid fa-chart-column"></i></span>
                                                <div>
                                                    <div class="rv-panel__title">Doanh thu 12 tháng gần nhất</div>
                                                    <div class="rv-panel__meta">Biểu đồ cột trực quan</div>
                                                </div>
                                            </div>
                                            <i class="fa-solid fa-chevron-down rv-panel__chevron"></i>
                                        </div>
                                        <div class="rv-panel__body">
                                            <div class="revenue-panel revenue-panel--chart" style="border:none;box-shadow:none;padding:0;">
                                                <div class="revenue-month-chart revenue-month-chart--full">
                                                    <c:forEach var="item" items="${monthlyRevenueChart}" varStatus="loop">
                                                        <div class="revenue-month-chart__item">
                                                            <div class="revenue-month-chart__tooltip">
                                                                <fmt:formatNumber value="${item['revenue']}" type="number" groupingUsed="true"/> đ
                                                            </div>
                                                            <div class="revenue-month-chart__bar-wrap">
                                                                <div class="revenue-month-chart__bar ${loop.last ? 'revenue-month-chart__bar--active' : ''}"
                                                                     style="height: ${item['heightPercent']}%;"></div>
                                                            </div>
                                                            <div class="revenue-month-chart__label">${item['month_label']}</div>
                                                        </div>
                                                    </c:forEach>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="rv-panel" id="rv-daily">
                                        <div class="rv-panel__head" onclick="toggleRvPanel(this)">
                                            <div class="rv-panel__head-left">
                                                <span class="rv-panel__icon rv-panel__icon--blue"><i class="fa-solid fa-calendar-days"></i></span>
                                                <div>
                                                    <div class="rv-panel__title">Doanh thu theo ngày</div>
                                                    <div class="rv-panel__meta">Tổng đơn, doanh thu gốc, đơn hủy, thực nhận</div>
                                                </div>
                                            </div>
                                            <i class="fa-solid fa-chevron-down rv-panel__chevron"></i>
                                        </div>
                                        <div class="rv-panel__body">
                                            <table class="revenue-table">
                                                <thead>
                                                <tr>
                                                    <th>Ngày</th>
                                                    <th>Tổng đơn</th>
                                                    <th>Doanh thu gốc</th>
                                                    <th>Số đơn hủy</th>
                                                    <th>Giá trị đơn hủy</th>
                                                    <th>Doanh thu thực nhận</th>
                                                    <th>Trạng thái</th>
                                                </tr>
                                                </thead>
                                                <tbody>
                                                <c:choose>
                                                    <c:when test="${empty dailyRevenueList}">
                                                        <tr><td colspan="7" class="revenue-empty">Không có dữ liệu phù hợp.</td></tr>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <c:forEach var="row" items="${dailyRevenueList}">
                                                            <tr>
                                                                <td>${row['order_date']}</td>
                                                                <td><fmt:formatNumber value="${row['total_orders']}" type="number" groupingUsed="true"/></td>
                                                                <td><fmt:formatNumber value="${row['gross_revenue']}" type="number" groupingUsed="true"/> đ</td>
                                                                <td><fmt:formatNumber value="${row['cancelled_orders']}" type="number" groupingUsed="true"/></td>
                                                                <td><fmt:formatNumber value="${row['cancelled_value']}" type="number" groupingUsed="true"/> đ</td>
                                                                <td><fmt:formatNumber value="${row['net_revenue']}" type="number" groupingUsed="true"/> đ</td>
                                                                <td>
                                                                    <c:choose>
                                                                        <c:when test="${row['cancelled_orders'] == 0}">
                                                                            <span class="revenue-badge revenue-badge--success">Ổn định</span>
                                                                        </c:when>
                                                                        <c:when test="${row['cancelled_orders'] < 3}">
                                                                            <span class="revenue-badge revenue-badge--warning">Có hủy nhẹ</span>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <span class="revenue-badge revenue-badge--danger">Hủy cao</span>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </td>
                                                            </tr>
                                                        </c:forEach>
                                                    </c:otherwise>
                                                </c:choose>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>

                                    <div class="rv-panel" id="rv-status">
                                        <div class="rv-panel__head" onclick="toggleRvPanel(this)">
                                            <div class="rv-panel__head-left">
                                                <span class="rv-panel__icon rv-panel__icon--green"><i class="fa-solid fa-fire-flame-curved"></i></span>
                                                <div>
                                                    <div class="rv-panel__title">Sản phẩm bán chạy &amp; Tình trạng đơn hàng</div>
                                                    <div class="rv-panel__meta">Top sản phẩm và phân loại đơn</div>
                                                </div>
                                            </div>
                                            <i class="fa-solid fa-chevron-down rv-panel__chevron"></i>
                                        </div>
                                        <div class="rv-panel__body rv-panel__body--grid">
                                            <div>
                                                <h4 class="revenue-panel__title" style="margin-bottom:12px;">🔥 Sản phẩm bán chạy</h4>
                                                <ul class="revenue-list">
                                                    <c:choose>
                                                        <c:when test="${empty topSellingProducts}">
                                                            <li><span>Chưa có dữ liệu</span><strong>0</strong></li>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <c:forEach var="item" items="${topSellingProducts}">
                                                                <li>
                                                                    <span>${item['product_name']} (<fmt:formatNumber value="${item['sold_qty']}" type="number" groupingUsed="true"/> SP)</span>
                                                                    <strong><fmt:formatNumber value="${item['revenue']}" type="number" groupingUsed="true"/> đ</strong>
                                                                </li>
                                                            </c:forEach>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </ul>
                                            </div>
                                            <div>
                                                <h4 class="revenue-panel__title" style="margin-bottom:12px;">📦 Tình trạng đơn hàng</h4>
                                                <ul class="revenue-list">
                                                    <li><span>Đơn hoàn tất</span><strong><fmt:formatNumber value="${orderStatusStats['completed_orders']}" type="number" groupingUsed="true"/></strong></li>
                                                    <li><span>Đơn đang giao</span><strong><fmt:formatNumber value="${orderStatusStats['shipping_orders']}" type="number" groupingUsed="true"/></strong></li>
                                                    <li><span>Đơn chờ xử lý</span><strong><fmt:formatNumber value="${orderStatusStats['pending_orders']}" type="number" groupingUsed="true"/></strong></li>
                                                    <li><span>Đơn đã hủy</span><strong><fmt:formatNumber value="${orderStatusStats['cancelled_orders']}" type="number" groupingUsed="true"/></strong></li>
                                                </ul>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="rv-panel" id="rv-compare">
                                        <div class="rv-panel__head" onclick="toggleRvPanel(this)">
                                            <div class="rv-panel__head-left">
                                                <span class="rv-panel__icon rv-panel__icon--purple"><i class="fa-solid fa-code-compare"></i></span>
                                                <div>
                                                    <div class="rv-panel__title">So sánh bán ra theo tháng</div>
                                                    <div class="rv-panel__meta">${monthALabel} vs ${monthBLabel}</div>
                                                </div>
                                            </div>
                                            <i class="fa-solid fa-chevron-down rv-panel__chevron"></i>
                                        </div>
                                        <div class="rv-panel__body">
                                            <table class="revenue-table">
                                                <thead>
                                                <tr>
                                                    <th>Sản phẩm</th>
                                                    <th>SL tháng trước</th>
                                                    <th>SL tháng này</th>
                                                    <th>Chênh lệch</th>
                                                    <th>DT tháng trước</th>
                                                    <th>DT tháng này</th>
                                                </tr>
                                                </thead>
                                                <tbody>
                                                <c:choose>
                                                    <c:when test="${empty productMonthCompareList}">
                                                        <tr><td colspan="6" class="revenue-empty">Chưa có dữ liệu so sánh theo tháng.</td></tr>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <c:forEach var="item" items="${productMonthCompareList}">
                                                            <tr>
                                                                <td>${item['product_name']}</td>
                                                                <td><fmt:formatNumber value="${item['month_a_qty']}" type="number" groupingUsed="true"/></td>
                                                                <td><fmt:formatNumber value="${item['month_b_qty']}" type="number" groupingUsed="true"/></td>
                                                                <td>
                                                                    <c:choose>
                                                                        <c:when test="${item['month_b_qty'] > item['month_a_qty']}">
                                                                            <span class="revenue-badge revenue-badge--success">+<fmt:formatNumber value="${item['month_b_qty'] - item['month_a_qty']}" type="number" groupingUsed="true"/></span>
                                                                        </c:when>
                                                                        <c:when test="${item['month_b_qty'] < item['month_a_qty']}">
                                                                            <span class="revenue-badge revenue-badge--danger"><fmt:formatNumber value="${item['month_b_qty'] - item['month_a_qty']}" type="number" groupingUsed="true"/></span>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <span class="revenue-badge revenue-badge--info">Không đổi</span>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </td>
                                                                <td><fmt:formatNumber value="${item['month_a_revenue']}" type="number" groupingUsed="true"/> đ</td>
                                                                <td><fmt:formatNumber value="${item['month_b_revenue']}" type="number" groupingUsed="true"/> đ</td>
                                                            </tr>
                                                        </c:forEach>
                                                    </c:otherwise>
                                                </c:choose>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>

                                    <div class="rv-panel" id="rv-import">
                                        <div class="rv-panel__head" onclick="toggleRvPanel(this)">
                                            <div class="rv-panel__head-left">
                                                <span class="rv-panel__icon rv-panel__icon--red"><i class="fa-solid fa-boxes-stacked"></i></span>
                                                <div>
                                                    <div class="rv-panel__title">Theo dõi bán ra theo từng đợt nhập</div>
                                                    <div class="rv-panel__meta">SL nhập, đã bán, còn ước tính, giá nhập</div>
                                                </div>
                                            </div>
                                            <i class="fa-solid fa-chevron-down rv-panel__chevron"></i>
                                        </div>
                                        <div class="rv-panel__body">
                                            <table class="revenue-table">
                                                <thead>
                                                <tr>
                                                    <th>Ngày nhập</th>
                                                    <th>Mã phiếu</th>
                                                    <th>Sản phẩm</th>
                                                    <th>SL nhập</th>
                                                    <th>Đã bán từ đợt này</th>
                                                    <th>Số đơn bán</th>
                                                    <th>Còn ước tính</th>
                                                    <th>Giá nhập</th>
                                                </tr>
                                                </thead>
                                                <tbody>
                                                <c:choose>
                                                    <c:when test="${empty importBatchSalesList}">
                                                        <tr><td colspan="8" class="revenue-empty">Chưa có dữ liệu đợt nhập.</td></tr>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <c:forEach var="item" items="${importBatchSalesList}">
                                                            <tr>
                                                                <td>${item['imported_at']}</td>
                                                                <td>${item['receipt_code']}</td>
                                                                <td>${item['product_name']}</td>
                                                                <td><fmt:formatNumber value="${item['import_qty']}" type="number" groupingUsed="true"/></td>
                                                                <td><fmt:formatNumber value="${item['sold_qty_since_import']}" type="number" groupingUsed="true"/></td>
                                                                <td><fmt:formatNumber value="${item['sold_order_count']}" type="number" groupingUsed="true"/></td>
                                                                <td><fmt:formatNumber value="${item['estimated_remaining_qty']}" type="number" groupingUsed="true"/></td>
                                                                <td><fmt:formatNumber value="${item['total_price']}" type="number" groupingUsed="true"/> đ</td>
                                                            </tr>
                                                        </c:forEach>
                                                    </c:otherwise>
                                                </c:choose>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>

                                </div>
                            </div>
                        </div>
                    </section>


                    <section id="customer" class="admin-section customer-admin-page">
                        <div class="customer-admin-card customer-admin-card--header">
                            <div class="customer-admin-title">
                                <div class="customer-admin-title__icon">
                                    <i class="fa-solid fa-users"></i>
                                </div>
                                <div>
                                    <span class="customer-admin-title__label"></span>
                                    <h2>Quản lý khách hàng</h2>
                                </div>
                            </div>

                            <form class="customer-search customer-search--admin" method="get" action="${pageContext.request.contextPath}/admin/customers">
                                <div class="customer-search__box">
                                    <i class="fa-solid fa-magnifying-glass"></i>
                                    <input type="text" name="q" placeholder="Tìm kiếm theo tên, email hoặc số điện thoại..." value="${param.q}">
                                </div>
                                <button type="submit">
                                    <i class="fa-solid fa-search"></i>
                                    <span>Tìm</span>
                                </button>
                            </form>
                        </div>

                        <div class="customer-admin-card customer-admin-card--table">
                            <div class="customer-table-toolbar">
                                <div>
                                    <h3>Danh sách khách hàng</h3>
                                    <p>Tổng cộng <strong>${fn:length(users)}</strong> tài khoản khách hàng trong hệ thống.</p>
                                </div>
                                <span class="customer-table-toolbar__badge">
                                    <i class="fa-solid fa-database"></i>
                                    ${fn:length(users)} khách hàng
                                </span>
                            </div>

                            <div class="customer-table-wrap customer-table-wrap--admin">
                                <table class="customer-table customer-table--admin">
                                    <thead>
                                    <tr>
                                        <th>Khách hàng</th>
                                        <th>Email</th>
                                        <th>Địa chỉ</th>
                                        <th>Xem</th>
                                        <th>Sửa</th>
                                        <th>Xóa</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:choose>
                                        <c:when test="${empty users}">
                                            <tr>
                                                <td colspan="6">
                                                    <div class="customer-empty-state">
                                                        <i class="fa-regular fa-folder-open"></i>
                                                        <p>Không có khách hàng.</p>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="u" items="${users}">
                                                <tr>
                                                    <td>
                                                        <div class="customer-profile-cell">
                                                            <img class="customer-table__img customer-avatar"
                                                                 src="${pageContext.request.contextPath}/${empty u.avatar ? 'assets/img/default-avatar.png' : u.avatar}"
                                                                 alt="avatar"
                                                                 onerror="this.src='${pageContext.request.contextPath}/assets/img/default-avatar.png'">
                                                            <div class="customer-profile-cell__info">
                                                                <strong>${fn:escapeXml(u.name)}</strong>
                                                                <span>
                                                                    <i class="fa-solid fa-phone"></i>
                                                                    ${empty u.phone ? 'Chưa cập nhật SĐT' : fn:escapeXml(u.phone)}
                                                                </span>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <div class="customer-info-line">
                                                            <i class="fa-regular fa-envelope"></i>
                                                            <span>${fn:escapeXml(u.email)}</span>
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <div class="customer-info-line customer-info-line--address">
                                                            <i class="fa-solid fa-location-dot"></i>
                                                            <span>${empty u.address ? 'Chưa cập nhật địa chỉ' : fn:escapeXml(u.address)}</span>
                                                        </div>
                                                    </td>

                                                    <td>
                                                        <button type="button"
                                                                class="customer-table__view customer-action-btn customer-action-btn--view"
                                                                data-id="${u.id}"
                                                                data-name="${fn:escapeXml(u.name)}"
                                                                data-email="${fn:escapeXml(u.email)}"
                                                                data-phone="${fn:escapeXml(u.phone)}"
                                                                data-address="${fn:escapeXml(u.address)}"
                                                                data-role="${u.role}"
                                                                data-status="${u.status}"
                                                                data-created="${u.createdAt}"
                                                                data-updated="${u.updatedAt}"
                                                                data-avatar="${empty u.avatar ? '' : u.avatar}">
                                                            <i class="fa-regular fa-eye"></i>
                                                            Xem
                                                        </button>
                                                    </td>

                                                    <td>
                                                        <button type="button"
                                                                class="customer-table__edit customer-action-btn customer-action-btn--edit"
                                                                data-id="${u.id}"
                                                                data-name="${fn:escapeXml(u.name)}"
                                                                data-email="${fn:escapeXml(u.email)}"
                                                                data-phone="${fn:escapeXml(u.phone)}"
                                                                data-address="${fn:escapeXml(u.address)}"
                                                                data-role="${u.role}"
                                                                data-status="${u.status}"
                                                                data-created="${u.createdAt}"
                                                                data-updated="${u.updatedAt}">
                                                            <i class="fa-regular fa-pen-to-square"></i>
                                                            Sửa
                                                        </button>
                                                    </td>

                                                    <td>
                                                        <form method="post" action="${pageContext.request.contextPath}/admin/customers/lock"
                                                              onsubmit="return confirm('Khóa khách hàng này?');">
                                                            <input type="hidden" name="id" value="${u.id}">
                                                            <button type="submit" class="customer-table__delete customer-action-btn customer-action-btn--delete">
                                                                <i class="fa-solid fa-user-lock"></i>
                                                                Xóa
                                                            </button>
                                                        </form>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:otherwise>
                                    </c:choose>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </section>


                    <section id="customer-detail" class="customer-detail hidden">
                        <h2 class="manage__heading">Chi tiết khách hàng</h2>

                        <div class="customer-detail__card">
                            <!-- Avatar -->
                            <div class="customer-detail__avatar">
                                <img id="customerDetailAvatar"
                                     src="${pageContext.request.contextPath}/assets/img/default-avatar.png"
                                     alt="Avatar"
                                     onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/assets/img/default-avatar.png';">
                                <span id="customerDetailStatus" class="customer-detail__status online">Hoạt động</span>

                            </div>


                            <div class="customer-detail__info">
                                <div class="customer-detail__row">
                                    <span class="label">Tên:</span>
                                    <span class="value" id="customerDetailName"></span>

                                </div>

                                <div class="customer-detail__row">
                                    <span class="label">Email:</span>
                                    <span class="value" id="customerDetailEmail"></span>

                                </div>


                                <div class="customer-detail__row">
                                    <span class="label">Số điện thoại:</span>
                                    <span class="value" id="customerDetailPhone"></span>

                                </div>

                                <div class="customer-detail__row">
                                    <span class="label">Địa chỉ:</span>
                                    <span class="value" id="customerDetailAddress"></span>

                                </div>

                                <div class="customer-detail__row">
                                  <span class="label">Quyền:</span>
                                  <span class="value" id="customerDetailRole"></span>
                                </div>

                                <div class="customer-detail__row">
                                  <span class="label">Hoạt động:</span>
                                  <span class="value" id="customerDetailStatusText"></span>
                                </div>

                                <div class="customer-detail__row">
                                    <span class="label">Ngày tạo:</span>
                                    <span class="value" id="customerDetailCreatedAt">-</span>
                                </div>

                                <div class="customer-detail__row">
                                    <span class="label">Ngày cập nhật:</span>
                                    <span class="value" id="customerDetailUpdatedAt">-</span>
                                </div>
                            </div>
                        </div>


                        <div class="customer-detail__actions">
                            <button class="btn btn--default-color" onclick="hideCustomerDetail()">
                                Đóng
                            </button>
                        </div>
                    </section>

                    <section id="customer-edit" class="customer-detail hidden">
                        <h2 class="manage__heading">Sửa thông tin khách hàng</h2>

                        <div class="customer-detail__card">

                            <div class="customer-detail__avatar">
                                <img id="customerEditAvatar"
                                     src="${pageContext.request.contextPath}/assets/img/default-avatar.png"
                                     alt="Avatar"
                                     onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/assets/img/default-avatar.png';">
                                <span id="customerEditStatusBadge" class="customer-detail__status online">Đang hoạt động</span>
                            </div>


                            <form class="customer-detail__info"
                                  id="customerEditForm"
                                  method="post"
                                  action="${pageContext.request.contextPath}/admin/customers/update">
                                <input type="hidden" name="id" id="editId">


                                <div class="customer-detail__row">
                                    <label class="label">Tên:</label>
                                    <input type="text" class="input" name="name" id="editName" required>

                                </div>

                                <div class="customer-detail__row">
                                    <label class="label">Email:</label>
                                    <input type="email" class="input" name="email" id="editEmail" required>

                                </div>

                                <div class="customer-detail__row">
                                    <label class="label">Password:</label>
                                    <input type="password" class="input" name="password" id="editPassword" placeholder="Bỏ trống nếu không đổi">

                                </div>

                                <div class="customer-detail__row">
                                    <label class="label">Số điện thoại:</label>
                                    <input type="text" class="input" name="phone" id="editPhone">

                                </div>

                                <div class="customer-detail__row">
                                    <label class="label">Địa chỉ:</label>
                                    <input type="text" class="input" name="address" id="editAddress">

                                </div>
                                <div class="customer-detail__row">
                                  <label class="label">Quyền:</label>
                                  <select class="input" name="role" id="editRole" required>
                                    <option value="0">User</option>
                                    <option value="1">Admin</option>
                                  </select>
                                </div>

                                <div class="customer-detail__row">
                                  <label class="label">Trạng thái:</label>
                                  <select class="input" name="status" id="editStatus" required>
                                    <option value="1">Đang hoạt động</option>
                                    <option value="0">Bị khóa</option>
                                  </select>
                                </div>
                                <div class="customer-detail__row">
                                    <label class="label">Ngày tạo:</label>
                                    <input type="text" class="input" id="editCreatedAt" disabled>
                                </div>

                                <div class="customer-detail__row">
                                    <label class="label">Ngày cập nhật:</label>
                                    <input type="text" class="input" id="editUpdatedAt" disabled>
                                </div>

                                <!-- Action -->
                                <div class="customer-detail__actions">
                                    <button type="submit" class="btn btn--default-color">
                                        Lưu thay đổi
                                    </button>

                                    <button type="button"
                                            class="btn btn--default-color"
                                            onclick="hideCustomerEdit()">
                                        Hủy
                                    </button>
                                </div>
                            </form>
                        </div>
                    </section>
                    <section id="news" class="manage-detail">
                        <h2 class="manage__heading">Danh mục tin tức</h2>

                        <!-- Menu danh mục -->
                        <div class="news-menu">
                            <button class="news-menu__btn active" data-target="news-slide">Slide quảng cáo</button>
                            <button class="news-menu__btn" data-target="news-blog">Blog tin tức</button>
                        </div>

                        <!-- Slide quảng cáo -->
                        <div class="news-table" id="news-slide">
                            <div class="news-search">
                                <input type="text" placeholder="Tìm kiếm slide..." class="news-search__input" id="searchSlide">
                            </div>

                            <div class="add-table__header">
                                <button id="btnShowAddSlide" class="btn btn--default-color add-table__btn">Thêm Slide</button>
                            </div>

                            <div class="news-table__inner" id="slideTableContainer">
                                <div class="news-table__row news-table__row--header">
                                    <div class="news-table__cell">Ảnh</div>
                                    <div class="news-table__cell">Tên slide</div>
                                    <div class="news-table__cell">Trạng thái</div>
                                    <div class="news-table__cell">Ngày tạo</div>
                                    <div class="news-table__cell">Ngày cập nhật</div>
                                    <div class="news-table__cell">Post</div>
                                    <div class="news-table__cell">Xem</div>
                                    <div class="news-table__cell">Sửa</div>
                                    <div class="news-table__cell">Xóa</div>
                                </div>

                            </div>
                        </div>

                        <!-- Blog tin tức -->
                        <div class="news-table hidden" id="news-blog">
                            <!-- Tìm kiếm -->
                            <div class="news-search">
                                <input type="text" placeholder="Tìm kiếm blog..." class="news-search__input" id="searchBlog">
                            </div>
                            <div class="add-table__header">
                                <button class="btn btn--default-color add-table__btn">Thêm Blog</button>
                            </div>

                            <div class="news-table__inner">
                                <!-- Header -->
                                <div class="news-table__row news-table__row--header">
                                    <div class="news-table__cell">Ảnh</div>
                                    <div class="news-table__cell">Tiêu đề</div>
                                    <div class="news-table__cell">Trạng thái</div>
                                    <div class="news-table__cell">Ngày tạo</div>
                                    <div class="news-table__cell">Ngày cập nhật</div>
                                    <div class="news-table__cell">Post</div>
                                    <div class="news-table__cell">Xem</div>
                                    <div class="news-table__cell">Sửa</div>
                                    <div class="news-table__cell">Xóa</div>
                                </div>

                                <!-- Dữ liệu mẫu -->
                                <article class="news-table__row">
                                    <div class="news-table__cell"><img src="${pageContext.request.contextPath}/assets/img/blog1.jpg" class="news-table__img" alt=""></div>
                                    <div class="news-table__cell">Ra mắt sản phẩm mới 2025</div>
                                    <div class="news-table__cell"><span class="status status--active">Đang post</span></div>
                                    <div class="news-table__cell">05/12/2025</div>
                                    <div class="news-table__cell">10/12/2025</div>
                                    <div class="news-table__cell"><input type="checkbox" checked></div>
                                    <div class="news-table__cell"><button class="news-table__view">Xem</button></div>
                                    <div class="news-table__cell"><button class="news-table__edit">Sửa</button></div>
                                    <div class="news-table__cell"><button class="news-table__delete">Xóa</button></div>
                                </article>

                                <article class="news-table__row">
                                    <div class="news-table__cell"><img src="${pageContext.request.contextPath}/assets/img/blog2.jpg" class="news-table__img" alt=""></div>
                                    <div class="news-table__cell">Cập nhật chương trình ưu đãi</div>
                                    <div class="news-table__cell"><span class="status status--inactive">Chưa post</span></div>
                                    <div class="news-table__cell">20/11/2025</div>
                                    <div class="news-table__cell">25/11/2025</div>
                                    <div class="news-table__cell"><input type="checkbox"></div>
                                    <div class="news-table__cell"><button class="news-table__view">Xem</button></div>
                                    <div class="news-table__cell"><button class="news-table__edit">Sửa</button></div>
                                    <div class="news-table__cell"><button class="news-table__delete">Xóa</button></div>
                                </article>
                            </div>
                        </div>
                    </section>

                    <!-- Chi tiết Slide -->
                    <section id="slide-detail" class="slide-detail hidden">
                        <h2 class="manage__heading">Chi tiết Slide</h2>

                        <div class="slide-detail__card">
                            <!-- Hình Slide -->
                            <div class="slide-detail__image">
                                <img id="detailSlideImg" src="" alt="Slide Image">
                                <span id="detailSlideStatusSpan" class="slide-detail__status active"></span>
                            </div>

                            <!-- Thông tin Slide -->
                            <div class="slide-detail__info">
                                <div class="slide-detail__row">
                                    <span class="label">Tên slide:</span>
                                    <span class="value" id="detailSlideTitle"></span>
                                </div>
                                <div class="slide-detail__row">
                                    <span class="label">Trạng thái:</span>
                                    <span class="value" id="detailSlideStatusText"></span>
                                </div>
                                <div class="slide-detail__row">
                                    <span class="label">Ngày tạo:</span>
                                    <span class="value" id="detailSlideCreatedAt"></span>
                                </div>
                                <div class="slide-detail__row">
                                    <span class="label">Ngày cập nhật:</span>
                                    <span class="value" id="detailSlideUpdatedAt"></span>
                                </div>
                                <div class="slide-detail__row">
                                    <span class="label">Post:</span>
                                    <span class="value">
                                        <input type="checkbox" id="detailSlideCheckbox" disabled>
                                    </span>
                                </div>
                            </div>
                        </div>

                        <!-- Nút đóng -->
                        <div class="slide-detail__actions" style="margin-top: 20px;">
                            <button class="btn btn--default-color" onclick="hideSlideDetail()">Đóng</button>
                        </div>
                    </section>

                    <!-- Chi tiết Blog -->
                    <section id="blog-detail" class="blog-detail hidden">
                        <h2 class="manage__heading">Chi tiết Blog</h2>

                        <div class="blog-detail__card">
                            <!-- Hình Blog -->
                            <div class="blog-detail__image">
                                <img src="${pageContext.request.contextPath}/assets/img/blog1.jpg" alt="Blog Image">
                                <span class="blog-detail__status active">Đang post</span>
                            </div>

                            <!-- Thông tin Blog -->
                            <div class="blog-detail__info">
                                <div class="blog-detail__row">
                                    <span class="label">Tiêu đề:</span>
                                    <span class="value">Ra mắt sản phẩm mới 2025</span>
                                </div>
                                <div class="blog-detail__row">
                                    <span class="label">Trạng thái:</span>
                                    <span class="value">Đang post</span>
                                </div>
                                <div class="blog-detail__row">
                                    <span class="label">Ngày tạo:</span>
                                    <span class="value">05/12/2025</span>
                                </div>
                                <div class="blog-detail__row">
                                    <span class="label">Ngày cập nhật:</span>
                                    <span class="value">10/12/2025</span>
                                </div>
                                <div class="blog-detail__row">
                                    <span class="label">Post:</span>
                                    <span class="value"><input type="checkbox" checked></span>
                                </div>
                            </div>
                        </div>

                        <!-- Nút đóng -->
                        <div class="blog-detail__actions">
                            <button class="btn btn--default-color" onclick="hideBlogDetail()">Đóng</button>
                        </div>
                    </section>

                    <!-- Sửa Slide -->
                    <section id="slide-edit" class="slide-detail" style="display: none">
                        <h2 class="manage__heading">Sửa Slide</h2>

                        <div class="slide-detail__card">
                            <!-- Hình Slide -->
                            <div class="slide-detail__image">
                                <img src="" alt="Slide Image" id="editSlideImg">
                                <span class="slide-detail__status" id="editSlideStatusSpan">Đang post</span>
                            </div>

                            <!-- Form thông tin -->
                            <form class="slide-detail__info" id="slideEditForm" enctype="multipart/form-data">
                                <input type="hidden" id="editSlideId" name="slideId">
                                <div class="slide-detail__row">
                                    <label class="label">Tên slide:</label>
                                    <input type="text" class="input" name="title" id="editSlideTitle">
                                </div>

                                <div class="slide-detail__row">
                                    <label class="label">Trạng thái:</label>
                                    <select class="input" id="editSlideStatus" name="status">
                                        <option value="1">Đang post</option>
                                        <option value="0">Chưa post</option>
                                    </select>
                                </div>

                                <div class="slide-detail__row">
                                    <label class="label">Ngày tạo:</label>
                                    <input type="text" class="input" id="editSlideCreatedAt" disabled>
                                </div>

                                <div class="slide-detail__row">
                                    <label class="label">Ngày cập nhật:</label>
                                    <input type="text" class="input" id="editSlideUpdatedAt" disabled>
                                </div>

                                <div class="slide-detail__row">
                                    <label class="label">Hình ảnh mới:</label>
                                    <input type="file" class="input" name="banner">
                                </div>

                                <!-- Action -->
                                <div class="slide-detail__actions">
                                    <button type="submit" class="btn btn--default-color" id="btnUpdateSlide">Lưu thay đổi</button>
                                    <button type="button" class="btn btn--default-color" onclick="hideSlideEdit()">Hủy</button>
                                </div>
                            </form>
                        </div>
                    </section>

                    <!-- Sửa Blog -->
                    <section id="blog-edit" class="blog-detail hidden">
                        <h2 class="manage__heading">Sửa Blog</h2>

                        <div class="blog-detail__card">
                            <!-- Hình Blog -->
                            <div class="blog-detail__image">
                                <img src="${pageContext.request.contextPath}/assets/img/blog1.jpg" alt="Blog Image">
                                <span class="blog-detail__status active">Đang post</span>
                            </div>

                            <!-- Form thông tin -->
                            <form class="blog-detail__info" id="blogEditForm">
                                <div class="blog-detail__row">
                                    <label class="label">Tiêu đề:</label>
                                    <input type="text" class="input" value="Ra mắt sản phẩm mới 2025">
                                </div>

                                <div class="blog-detail__row">
                                    <label class="label">Trạng thái:</label>
                                    <select class="input">
                                        <option value="active" selected>Đang post</option>
                                        <option value="inactive">Chưa post</option>
                                    </select>
                                </div>

                                <div class="blog-detail__row">
                                    <label class="label">Ngày tạo:</label>
                                    <input type="text" class="input" value="05/12/2025" disabled>
                                </div>

                                <div class="blog-detail__row">
                                    <label class="label">Ngày cập nhật:</label>
                                    <input type="text" class="input" value="10/12/2025" disabled>
                                </div>

                                <div class="blog-detail__row">
                                    <label class="label">Hình ảnh mới:</label>
                                    <input type="file" class="input">
                                </div>

                                <!-- Action -->
                                <div class="blog-detail__actions">
                                    <button type="submit" class="btn btn--default-color ">Lưu thay đổi</button>
                                    <button type="button" class="btn btn--default-color" onclick="hideBlogEdit()">Hủy</button>
                                </div>
                            </form>
                        </div>
                    </section>

                    <!-- Thêm slide -->
                    <section id="add-slide" class="manage-detail" style="display:none;">
                        <h2 class="manage__heading">Thêm slide</h2>

                        <div class="slide-table">
                            <div class="slide-table__header">
                                <button type="submit" form="addSlideForm" class="slide-table__save">
                                    <i class="fa-solid fa-floppy-disk"></i> Lưu slide
                                </button>
                            </div>

                            <div class="slide-table__inner">
                                <form id="addSlideForm" class="add-slide-form" enctype="multipart/form-data">

                                    <div class="add-slide-form__field">
                                        <label class="add-slide-form__label">Tên slide:</label>
                                        <input type="text" name="name" class="add-slide-form__input" placeholder="Nhập tên slide..." required>
                                    </div>

                                    <div class="add-slide-form__field">
                                        <label class="add-slide-form__label">Mô tả ngắn:</label>
                                        <input type="text" name="text" class="add-slide-form__input" placeholder="Nhập mô tả slide...">
                                    </div>

                                    <div class="add-slide-form__field">
                                        <label class="add-slide-form__label">Trạng thái:</label>
                                        <select name="status" class="add-slide-form__input">
                                            <option value="1">Đang post</option>
                                            <option value="0">Chưa post</option>
                                        </select>
                                    </div>

                                    <div class="add-slide-form__field">
                                        <label class="add-slide-form__label">Ảnh slide:</label>
                                        <input type="file" name="avatar" class="add-slide-form__input" accept="image/*" required>
                                    </div>

                                    <button type="button"
                                            class="btn btn--default-color product-table__back-btn"
                                            onclick="hideSlideAdd()">
                                        Quay lại
                                    </button>
                                </form>
                            </div>
                        </div>
                    </section>

                    <!-- Thêm blog -->
                    <section id="add-blog" class="manage-detail" style="display:none;">
                        <h2 class="manage__heading">Thêm blog</h2>

                        <div class="blog-table">
                            <div class="blog-table__header">
                                <button type="submit" form="addBlogForm" class="blog-table__save">
                                    <i class="fa-solid fa-floppy-disk"></i>
                                </button>
                            </div>

                            <div class="blog-table__inner">
                                <form id="addBlogForm" class="add-blog-form">

                                    <!-- Tiêu đề -->
                                    <div class="add-blog-form__field">
                                        <label class="add-blog-form__label">Tiêu đề:</label>
                                        <input type="text" class="add-blog-form__input" required>
                                    </div>

                                    <!-- Trạng thái -->
                                    <div class="add-blog-form__field">
                                        <label class="add-blog-form__label">Trạng thái:</label>
                                        <select class="add-blog-form__input">
                                            <option value="active">Đang post</option>
                                            <option value="inactive">Chưa post</option>
                                        </select>
                                    </div>

                                    <!-- Ảnh đại diện -->
                                    <div class="add-blog-form__field">
                                        <label class="add-blog-form__label">Ảnh đại diện:</label>
                                        <input type="file" class="add-blog-form__input" accept="image/*">
                                    </div>

                                    <!-- Nội dung -->
                                    <div class="add-blog-form__field">
                                        <label class="add-blog-form__label">Nội dung:</label>
                                        <div id="blogEditor" class="add-blog-form__editor"></div>
                                    </div>

                                    <button type="button"
                                            class="btn btn--default-color product-table__back-btn"
                                            onclick="hideBlogAdd()">
                                        Quay lại
                                    </button>

                                </form>
                            </div>
                        </div>
                    </section>


                    <section id="product" class="manage-detail" style="display:none;">
                        <h2 class="manage__heading">Sản phẩm</h2>
                        <div class="product-menu">
                            <button class="product-menu__btn active" data-target="product-list">Danh mục sản phẩm</button>
                            <button class="product-menu__btn" data-target="product-event">Sự kiện giảm giá</button>
                        </div>
                        <div class="product-layout">
                            <aside class="product-sidebar">
                                <h3 class="product-sidebar__heading">Danh mục</h3>
                                <ul class="product-sidebar__list" id="category-list">
                                    <li class="product-sidebar__item">
                                        <a href="#!" class="product-sidebar__link">Đang tải...</a>
                                    </li>
                                </ul>
                            </aside>
                            <div class="product-main-content">
                                <div id="product-list-section">
                                    <div class="product-table">
                                        <div class="event-search">
                                            <div class="event-search__wrapper">
                                                <input type="text" id="productSearchInput" class="event-search__input" placeholder="Tìm kiếm tên sản phẩm...">
                                                <button class="event-search__btn" id="productSearchBtn">
                                                    <i class="fas fa-search"></i> Tìm kiếm
                                                </button>
                                            </div>
                                        </div>
                                        <div class="product-table__header">
                                            <button class="btn btn--default-color product-table__btn">Thêm sản phẩm</button>
                                        </div>
                                        <div class="product-table__inner">

                                            <div class="product-table__row table-header">
                                                <div class="product-table__cell">Ảnh</div>
                                                <div class="product-table__cell">Tên sản phẩm</div>
                                                <div class="product-table__cell">Post</div> <div class="product-table__cell">Giá</div>
                                                <div class="product-table__cell">Xem</div>
                                                <div class="product-table__cell">Sửa</div>
                                                <div class="product-table__cell">Xóa</div>
                                            </div>

                                            <div id="product-list-container">
                                                <div style="text-align: center; padding: 20px;">Đang tải dữ liệu...</div>
                                            </div>

                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div id="product-event-section" style="display: none;">
                            <div class="event-manager">
                                <div class="event-header">
                                    <button class="btn btn--default-color event-header__btn">Thêm sự kiện giảm giá</button>
                                </div>
                                <div class="event-search">
                                    <div class="event-search__wrapper">
                                        <input type="text" class="event-search__input" placeholder="Tìm kiếm tên sự kiện hoặc mức giảm giá...">
                                        <button class="event-search__btn">
                                            <i class="fas fa-search"></i> Tìm kiếm
                                        </button>
                                    </div>
                                </div>
                                <div class="event-table">

                                    <div class="product-table">
                                        <div id="discount-list-container">
                                        </div>
                                    </div>

                                </div>
                            </div>
                        </div>
                    </section>

                    <section id="add-event-page" class="manage-detail" style="display: none;">
                        <h2 class="manage__heading">Thêm sự kiện giảm giá mới</h2>

                        <div class="event-card">
                            <button type="submit" form="addEventForm" class="event-btn event-btn--save">
                                <i class="fa-solid fa-floppy-disk"></i> Lưu sự kiện
                            </button>

                            <div class="event-card__body">
                                <form id="addEventForm" class="event-form">
                                    <div class="event-form__group">
                                        <label class="event-form__label">Tên sự kiện:</label>
                                        <input type="text" name="eventName" class="event-form__input" placeholder="Ví dụ: Sale Hè Rực Rỡ" required>
                                    </div>

                                    <div class="event-form__row">
                                        <div class="event-form__group">
                                            <label class="event-form__label">Loại giảm giá:</label>
                                            <select name="discountType" id="discountType" class="event-form__input">
                                                <option value="percentage">Giảm theo phần trăm (%)</option>
                                                <option value="amount">Giảm theo số tiền (đ)</option>
                                            </select>
                                        </div>
                                        <div class="event-form__group">
                                            <label class="event-form__label">Mức giảm:</label>
                                            <div class="event-form__input-wrapper">
                                                <input type="number" name="discountValue" class="event-form__input" placeholder="0" required>
                                                <span id="discountUnit" class="event-form__unit">%</span>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="event-form__row">
                                        <div class="event-form__group">
                                            <label class="event-form__label">Ngày bắt đầu:</label>
                                            <input type="date" name="startDate" class="event-form__input" required>
                                        </div>
                                        <div class="event-form__group">
                                            <label class="event-form__label">Ngày kết thúc:</label>
                                            <input type="date" name="endDate" class="event-form__input" required>
                                        </div>
                                    </div>

                                    <div class="event-form__group">
                                        <label class="event-form__label1">Mô tả sự kiện:</label>
                                        <textarea name="eventDesc" class="event-form__input event-form__input--textarea" rows="3" placeholder="Mô tả ngắn gọn chương trình..."></textarea>
                                    </div>

                                    <div class="event-form__group" style="display: none">
                                        <label class="event-form__label">Chọn Slide cho sự kiện:</label>
                                        <div class="event-select" id="eventSlideSelect">
                                            <div class="event-select__selected">-- Đang tải danh sách Slide... --</div>

                                            <div class="event-select__options" id="listSlideOptions">
                                                <div class="event-option">
                                                    <span>Đang tải dữ liệu...</span>
                                                </div>
                                            </div>
                                        </div>
                                        <input type="hidden" name="eventSlideTarget" id="eventSlideTargetHidden" value="0">
                                    </div>
                                    <label class="event-form__label2">Phạm vi áp dụng giảm giá:</label>
                                    <div class="event-form__apply-type">

                                        <div class="event-form__apply-row">
                                            <label class="event-radio">
                                                <input type="radio" name="applyScope" value="all" checked>
                                                <span>Tất cả sản phẩm</span>
                                            </label>
                                        </div>

                                        <div class="event-form__apply-row">
                                            <label class="event-radio">
                                                <input type="radio" name="applyScope" value="category">
                                                <span>Theo danh mục</span>
                                            </label>

                                            <div id="scopeCategory" class="event-scope-box" style="display: none;">
                                                <div class="category-select-wrapper">
                                                    <select name="applyCategories" class="event-form__input">
                                                        <option value="">-- Chọn một danh mục --</option>
                                                        <option value="1">Gia dụng - Nhà cửa</option>
                                                        <option value="2">Phụ kiện ô tô</option>
                                                        <option value="3">Thời trang</option>
                                                        <option value="4">Âm thanh - Camera</option>
                                                    </select>
                                                </div>
                                            </div>
                                        </div>

                                    </div>
                                </form>
                            </div>

                            <div class="event-card__footer">
                                <button type="button" class="bton btn--primary event-btn--cancel" onclick="backToEventList()">Hủy bỏ</button>
                            </div>
                        </div>
                    </section>

                    <section id="discount-list-page">
                        <div id="discount-list-container"></div>
                    </section>

                    <section id="view-event-page" class="ev-container" style="display: none;">
                        <div class="ev-header">
                            <h2 class="ev-title">Chi tiết chương trình</h2>
                        </div>

                        <div class="ev-card">
                            <div class="ev-grid">
                                <div class="ev-group ev-col-2">
                                    <label class="ev-label">Tên sự kiện</label>
                                    <div class="ev-view-box ev-view-box--bold" id="view-eventName"></div>
                                </div>

                                <div class="ev-group ev-col-2">
                                    <label class="ev-label">Phạm vi áp dụng (Danh mục)</label>
                                    <div class="ev-view-box" id="view-categoryName" style="color: #0056b3; font-weight: 600; background: #eef6ff;"></div>
                                </div>

                                <div class="ev-group">
                                    <label class="ev-label">Loại giảm giá</label>
                                    <div class="ev-view-box" id="view-discountType"></div>
                                </div>

                                <div class="ev-group">
                                    <label class="ev-label">Mức giảm</label>
                                    <div class="ev-view-box ev-view-box--red" id="view-discountValue"></div>
                                </div>

                                <div class="ev-group">
                                    <label class="ev-label">Ngày bắt đầu</label>
                                    <div class="ev-view-box" id="view-startDate"></div>
                                </div>

                                <div class="ev-group">
                                    <label class="ev-label">Ngày kết thúc</label>
                                    <div class="ev-view-box" id="view-endDate"></div>
                                </div>

                                <div class="ev-group ev-col-2">
                                    <label class="ev-label">Mô tả</label>
                                    <div class="ev-view-box" id="view-descrip"></div>
                                </div>
                            </div>
                        </div>

                        <div class="ev-footer">
                            <button class="ev-btn ev-btn--outline" onclick="backToEventList()">Quay lại danh sách</button>
                        </div>
                    </section>

                    <section id="edit-event-page" class="ev-container" style="display: none;">
                        <div class="ev-header">
                            <h2 class="ev-title">Cập nhật sự kiện</h2>
                            <button class="ev-btn ev-btn--blue" onclick="saveDiscountUpdate()">
                                <i class="fa-solid fa-check"></i> Lưu thay đổi
                            </button>
                        </div>

                        <div class="ev-card">
                            <form id="editEventForm">
                                <div class="ev-grid">
                                    <div class="ev-group ev-col-2">
                                        <label class="ev-label">Tên sự kiện</label>
                                        <input type="text" class="ev-input" id="edit-eventName" placeholder="Ví dụ: Sale Tết Nguyên Đán 2026">
                                    </div>

                                    <div class="ev-group ev-col-2">
                                        <label class="ev-label" style="color: #0056b3;">Phạm vi áp dụng hiện tại:</label>
                                        <div id="edit-currentCategoryName" class="ev-view-box" style="background: #f0f7ff; font-weight: 600; padding: 10px; border-radius: 4px; border: 1px solid #d0e3ff;">
                                        </div>
                                    </div>

                                    <div class="ev-group">
                                        <label class="ev-label">Loại giảm giá</label>
                                        <div class="ev-input" style="background: #f5f5f5; color: #666; cursor: not-allowed; display: flex; align-items: center;">
                                            Phần trăm (%)
                                        </div>
                                        <input type="hidden" id="edit-discountType" value="percentage">
                                    </div>

                                    <div class="ev-group">
                                        <label class="ev-label">Mức giảm (%)</label>
                                        <input type="number" class="ev-input" id="edit-discountValue" min="1" max="100" placeholder="20">
                                    </div>

                                    <div class="ev-group">
                                        <label class="ev-label">Ngày bắt đầu</label>
                                        <input type="date" class="ev-input" id="edit-startDate">
                                    </div>

                                    <div class="ev-group">
                                        <label class="ev-label">Ngày kết thúc</label>
                                        <input type="date" class="ev-input" id="edit-endDate">
                                    </div>

                                    <div class="ev-group ev-col-2">
                                        <label class="ev-label">Mô tả sự kiện</label>
                                        <textarea class="ev-input" id="edit-eventDesc" rows="3" style="height: auto;" placeholder="Mô tả nội dung khuyến mãi..."></textarea>
                                    </div>

                                    <div class="ev-group ev-col-2">
                                        <label class="ev-label" style="font-weight: 600; margin-bottom: 10px; display: block;">Thay đổi phạm vi áp dụng</label>
                                        <div class="ev-radio-group" style="display: flex; gap: 20px;">
                                            <label class="ev-radio" style="cursor: pointer; display: flex; align-items: center; gap: 8px;">
                                                <input type="radio" name="editApplyScope" value="all">
                                                <span>Tất cả sản phẩm</span>
                                            </label>
                                            <label class="ev-radio" style="cursor: pointer; display: flex; align-items: center; gap: 8px;">
                                                <input type="radio" name="editApplyScope" value="category">
                                                <span>Theo danh mục</span>
                                            </label>
                                        </div>

                                        <div id="editScopeCategory" class="ev-scope-box" style="display: none; margin-top: 15px; padding: 15px; border: 1px dashed #ddd; border-radius: 8px;">
                                            <label class="ev-label">Chọn danh mục mới:</label>
                                            <select class="ev-input" id="editApplyCategories">
                                                <option value="0">-- Chọn một danh mục --</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                            </form>
                        </div>

                        <div class="ev-footer" style="margin-top: 20px; border-top: 1px solid #eee; padding-top: 20px;">
                            <button class="ev-btn ev-btn--outline" onclick="backToEventList()">Hủy bỏ</button>
                        </div>
                    </section>

                    <section id="add-product" class="manage-detail" style="display:none;">
                        <h2 class="manage__heading">Thêm sản phẩm mới</h2>

                        <div class="product-table">
                            <div class="product-table__header">
                                <button type="button" onclick="saveFullProduct()" class="product-table__save">
                                    <i class="fa-solid fa-floppy-disk"></i> Lưu sản phẩm
                                </button>
                            </div>

                            <div class="product-table__inner">
                                <form id="addProductFormInline"
                                      class="add-product-form"
                                      method="POST"
                                      action="api/add-product"
                                      enctype="multipart/form-data">

                                    <div class="add-product-form__row">
                                        <div class="add-product-form__field">
                                            <label class="add-product-form__label">Tên sản phẩm:</label>
                                            <input type="text" name="productName" class="add-product-form__input" required>
                                        </div>
                                        <div class="add-product-form__field">
                                            <label class="add-product-form__label">Giá sản phẩm:</label>
                                            <input type="number" name="productPrice" class="add-product-form__input" required>
                                        </div>
                                        <div class="add-product-form__field">
                                            <label class="add-product-form__label">Số lượng:</label>
                                            <input type="number" name="productStock" class="add-product-form__input" required>
                                        </div>
                                    </div>

                                    <div class="add-product-form__row" style="align-items: center;">
                                        <div class="add-product-form__field" style="flex: 1;">
                                            <label class="add-product-form__label">Ảnh đại diện (Thêm từng ảnh):</label>
                                            <div class="add-product-input-group">
                                                <input type="file" id="mainImgTemp" class="add-product-form__input" accept="image/*">
                                                <button type="button" class="bton btn--primary" onclick="addMainImage()">Thêm ảnh</button>
                                            </div>

                                            <div id="mainImageStatusList" class="added-items-list" style="margin-top: 10px;"></div>
                                        </div>
                                        <div class="add-product-form__field" style="width: 100px;">
                                            <label class="add-product-form__label">Post ngay:</label>
                                            <input type="checkbox" id="postStatus" name="isPost" value="1" class="product-table__checkbox" style="width: 20px; height: 20px;">
                                        </div>
                                    </div>

                                    <div class="add-product-form__field">
                                        <label class="add-product-form__label">Nhãn hiệu:</label>
                                        <select name="brandID" class="add-product-form__input" id="brandSelect" required>
                                            <option value="">-- Đang tải dữ liệu... --</option>
                                            <option value="add-new">+ Thêm nhãn hiệu mới</option>
                                        </select>
                                    </div>

                                    <div class="add-product-form__field">
                                        <label class="add-product-form__label">Từ khóa (Tag):</label>
                                        <select name="tagID" class="add-product-form__input" id="tagSelect">
                                            <option value="">-- Đang tải dữ liệu... --</option>
                                            <option value="add-new">+ Thêm từ khóa mới</option>
                                        </select>
                                    </div>
                                    <div class="add-product-form__field">
                                        <label class="add-product-form__label">Danh mục:</label>
                                        <select name="cateID" class="add-product-form__input" id="cateSelect">
                                            <option value="">-- Đang tải dữ liệu... --</option>
                                            <option value="add-new">+ Thêm danh mục mới</option>
                                        </select>
                                    </div>
                                    <div class="add-product-form__section">
                                        <label class="add-product-form__label">Mô tả sản phẩm:</label>
                                        <div class="add-product-input-group">
                                            <input type="text" id="descTitle" placeholder="Tiêu đề mô tả" class="add-product-form__input">
                                            <textarea id="descContent" placeholder="Nội dung mô tả" class="add-product-form__input"></textarea>
                                            <button type="button" class="bton btn--primary" onclick="addDescription()">Thêm mô tả</button>
                                        </div>
                                        <div id="descriptionList" class="added-items-list"></div>
                                    </div>

                                    <div class="add-product-form__section">
                                        <label class="add-product-form__label">Chi tiết sản phẩm (Ảnh & Nội dung):</label>
                                        <div class="add-product-input-group">
                                            <input type="file" id="detailImg" class="add-product-form__input">
                                            <input type="text" id="detailTitle" placeholder="Tiêu đề chi tiết" class="add-product-form__input">
                                            <textarea id="detailContent" placeholder="Nội dung chi tiết" class="add-product-form__input"></textarea>
                                            <button type="button" class="bton btn--primary" onclick="addDetail()">Thêm chi tiết</button>
                                        </div>
                                        <div id="detailList" class="added-items-list"></div>
                                    </div>

                                </form>
                            </div>
                        </div>
                    </section>

                    <div id="brandModal" class="admin-modal" style="display: none; position: fixed; top:0; left:0; width:100%; height:100%; background: rgba(0,0,0,0.5); z-index: 9999; justify-content: center; align-items: center;">
                        <div class="admin-modal__content" style="background: #fff; padding: 20px; border-radius: 8px; width: 400px;">
                            <h3>Thêm Nhãn Hiệu Mới</h3>
                            <form id="addBrandFormQuick">
                                <input type="text" name="brandName" placeholder="Tên nhãn hiệu" class="add-product-form__input" required style="width: 100%; margin-bottom: 10px;">
                                <input type="text" name="brandCountry" placeholder="Quốc gia" class="add-product-form__input" style="width: 100%; margin-bottom: 10px;">
                                <input type="file" name="brandLogo" accept="image/*" class="add-product-form__input" style="width: 100%; margin-bottom: 10px;">
                                <div class="admin-modal__actions" style="display: flex; justify-content: flex-end; gap: 10px;">
                                    <button type="button" class="bton btn--primary" onclick="closeModal('brandModal')">Hủy</button>
                                    <button type="button" class="bton btn--primary" onclick="saveNewBrand()">Lưu nhãn hiệu</button>
                                </div>
                            </form>
                        </div>
                    </div>

                    <div id="tagModal" class="admin-modal" style="display: none; position: fixed; top:0; left:0; width:100%; height:100%; background: rgba(0,0,0,0.5); z-index: 9999; justify-content: center; align-items: center;">
                        <div class="admin-modal__content" style="background: #fff; padding: 20px; border-radius: 8px; width: 400px;">
                            <h3>Thêm Từ Khóa Mới</h3>
                            <form id="addTagFormQuick">
                                <input type="text" id="newTagName" name="tagName" placeholder="Tên từ khóa" class="add-product-form__input" required style="width: 100%; margin-bottom: 10px;">
                                <textarea id="newTagDesc" name="tagDesc" placeholder="Mô tả từ khóa" class="add-product-form__input" style="width: 100%; margin-bottom: 10px;"></textarea>
                                <div class="admin-modal__actions" style="display: flex; justify-content: flex-end; gap: 10px;">
                                    <button type="button" class="bton btn--primary" onclick="closeModal('tagModal')">Hủy</button>
                                    <button type="button" class="bton btn--primary" onclick="saveNewTag()">Lưu từ khóa</button>
                                </div>
                            </form>
                        </div>
                    </div>

                    <div id="cateModal" class="admin-modal" style="display: none; position: fixed; top:0; left:0; width:100%; height:100%; background: rgba(0,0,0,0.5); z-index: 9999; justify-content: center; align-items: center;">
                        <div class="admin-modal__content" style="background: #fff; padding: 20px; border-radius: 8px; width: 400px;">
                            <h3>Thêm Danh mục Mới</h3>
                            <form id="addCateFormQuick">
                                <input type="text" id="newCateName" name="cateName" placeholder="Tên danh mục" class="add-product-form__input" required style="width: 100%; margin-bottom: 10px;">
                                <textarea id="newCateDesc" name="cateDesc" placeholder="Mô tả danh mục" class="add-product-form__input" style="width: 100%; margin-bottom: 10px;"></textarea>
                                <div class="admin-cate__actions" style="display: flex; justify-content: flex-end; gap: 10px;">
                                    <button type="button" class="bton btn--primary" onclick="closeModal('cateModal')">Hủy</button>
                                    <button type="button" class="bton btn--primary" onclick="saveNewCategory()">Lưu từ khóa</button>
                                </div>
                            </form>
                        </div>
                    </div>

                    <div id="viewProductModal" class="admin-modal">
                        <div class="admin-modal__content admin-modal__content--large">
                            <div class="modal-header">
                                <h3 class="manage__heading">Chi tiết sản phẩm</h3>
                            </div>

                            <div class="modal-body">
                                <div class="view-grid">
                                    <div class="view-col">
                                        <div class="view-image-box">
                                            <img id="v-image" src="" alt="Ảnh sản phẩm" class="view-img-main" onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/assets/img/no-image.png'">
                                        </div>
                                        <div class="view-time">
                                            <p><strong>Ngày tạo:</strong> <span id="v-createdAt">---</span></p>
                                            <p><strong>Cập nhật:</strong> <span id="v-updatedAt">---</span></p>
                                        </div>
                                    </div>

                                    <div class="view-col">
                                        <h2 id="v-name" class="view-product-title">---</h2>

                                        <div class="view-info-group">
                                            <p><strong>Nhãn hiệu:</strong> <span class="badge" id="v-brand">---</span></p>
                                            <p><strong>Từ khóa:</strong> <span class="badge badge--tag" id="v-tags">---</span></p>
                                        </div>

                                        <div class="view-price-card">
                                            <div id="box-oldPrice" style="display:none">
                                                <label>Giá gốc:</label>
                                                <span id="v-oldPrice"></span>
                                            </div>
                                            <div id="box-discount" style="display:none">
                                                <label>Giảm giá:</label>
                                                <span id="v-discount"></span>%
                                            </div>
                                            <div class="price-item price-item--main">
                                                <span>Giá mới:</span><span id="v-newPrice" class="text-price">0đ</span>
                                            </div>
                                        </div>

                                        <div class="view-inventory">
                                            <p><strong>Số lượng còn lại:</strong> <span id="v-stock">0</span></p>
                                            <p><strong>Số lượng đã bán:</strong> <span id="v-sold">0</span></p>
                                            <p><strong>Trạng thái Post:</strong> <input type="checkbox" id="v-isPost" class="product-table__checkbox" disabled></p>
                                        </div>
                                    </div>
                                </div>

                                <div class="view-section">
                                    <h4 class="view-section-title">Mô tả sản phẩm</h4>
                                    <div id="v-descriptionList" class="view-list"></div>
                                </div>

                                <div class="view-section">
                                    <h4 class="view-section-title">Chi tiết kỹ thuật</h4>
                                    <div id="v-detailList" class="view-detail-grid"></div>
                                </div>
                            </div>
                            <div class="product-view-footer">
                                <button type="button" class="btn btn--primary btn--back-rect" onclick="backToList()">
                                    Quay lại
                                </button>
                            </div>
                        </div>
                    </div>

                    <div id="editProductPage" class="admin-content-page" style="display: none;">
                        <div class="admin-modal__content--large">
                            <div class="modal-header">
                                <h3 class="manage__heading">Chỉnh sửa sản phẩm</h3>
                            </div>

                            <div class="modal-body">
                                <form id="editProductForm" enctype="multipart/form-data">

                                    <input type="hidden" id="edit-id" name="id" value="">
                                    <input type="hidden" id="edit-oldImageName" name="oldImageName" value="">

                                    <div class="view-grid">
                                        <div class="view-col">
                                            <div class="view-image-box">
                                               <img id="edit-v-image" src="${pageContext.request.contextPath}/assets/img/no-image.png" alt="Ảnh sản phẩm" class="view-img-main">
                                                <div class="upload-action">
                                                    <label for="input-file-edit" class="btn-upload">
                                                        <i class="fa-solid fa-camera"></i> Thay đổi ảnh
                                                    </label>
                                                    <input type="file" id="input-file-edit" name="image" hidden onchange="previewImage(this, 'edit-v-image')">
                                                </div>
                                            </div>
                                            <div class="view-time">
                                                <p><strong>Ngày tạo:</strong> <span id="view-created-at">---</span></p>
                                            </div>
                                        </div>

                                        <div class="view-col">
                                            <div class="edit-info-list">
                                                <div class="info-row">
                                                    <label class="info-label">Tên sản phẩm:</label>
                                                    <input type="text" id="edit-name" name="name" class="form-input primary-focus" placeholder="Nhập tên sản phẩm">
                                                </div>

                                                <div class="info-row">
                                                    <label class="info-label">Nhãn hiệu:</label>
                                                    <select id="edit-brand" name="brandId" class="form-input">
                                                        <option value="">Đang tải...</option>
                                                    </select>
                                                </div>

                                                <div class="info-row">
                                                    <label class="info-label">Từ khóa (Tags):</label>
                                                    <select id="edit-tags" name="keywordId" class="form-input">
                                                        <option value="">Đang tải...</option>
                                                    </select>
                                                </div>

                                                <div class="view-price-card">
                                                    <div class="price-edit-row">
                                                        <label class="price-label">Giá gốc (đ):</label>
                                                        <input type="number" id="edit-oldPrice" name="oldPrice" class="form-input-small" value="0">
                                                    </div>
                                                    <div class="price-edit-row">
                                                        <label class="price-label">Giảm giá (%):</label>
                                                        <input type="number" id="edit-discount" name="discount" class="form-input-small" value="0" readonly style="background-color: #f0f0f0;">
                                                    </div>
                                                    <div class="price-edit-row">
                                                        <label class="price-label primary-text">Giá mới (đ):</label>
                                                        <input type="number" id="edit-newPrice" class="form-input-small price-edit-input" readonly style="background-color: #f0f0f0;">
                                                    </div>
                                                </div>

                                                <div class="view-inventory" style="margin-top: 20px; border-top: 1px dashed #ddd; padding-top: 15px;">
                                                    <div class="inventory-row">
                                                        <div class="info-row no-border">
                                                            <label class="info-label">Kho hàng:</label>
                                                            <input type="number" id="edit-stock" name="stock" class="form-input-small" style="width: 80px;" value="0">
                                                        </div>
                                                        <div class="info-row no-border">
                                                            <label class="info-label">Đã bán:</label>
                                                            <input type="number" id="edit-sold" name="sold" class="form-input-small" style="width: 80px;" value="0">
                                                        </div>
                                                    </div>
                                                    <div class="info-row no-border mt-10">
                                                        <label class="info-label">Trạng thái Post:</label>
                                                        <input type="checkbox" id="edit-isPost" name="isPost" class="product-table__checkbox" style="width: 20px; height: 20px;">
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="view-section">
                                        <h4 class="view-section-title">Mô tả sản phẩm</h4>
                                        <div id="edit-v-descriptionList" class="edit-mode-list">
                                        </div>
                                        <button type="button" class="btn-add-more" onclick="addDescriptionRow()">+ Thêm dòng mô tả</button>
                                    </div>

                                    <div class="view-section">
                                        <h4 class="view-section-title">Chi tiết sản phẩm</h4>
                                        <div id="edit-v-detailList" class="edit-mode-list">
                                        </div>
                                        <button type="button" class="btn-add-more" onclick="addDetailRow()">+ Thêm khối chi tiết</button>
                                    </div>

                                    <div class="product-view-footer" style="margin-top: 30px; border-top: 1px solid #eee; padding-top: 20px; text-align: right;">
                                        <button type="button" class="bton btn-cancel" onclick="closeEditModal()">Hủy bỏ</button>

                                        <button type="button" class="bton btn--primary btn--back-rect btn-save" onclick="updateProduct()">Lưu thay đổi</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>

                    <section id="purchase-history" class="admin-section">
                        <h2 class="manage__heading">Thống kê lịch sử mua hàng theo khách</h2>

                        <div class="purchase-history-card">
                            <form class="customer-search" method="get" action="${pageContext.request.contextPath}/admin/purchase-history">
                                <input type="text"
                                       name="q"
                                       class="customer-search__input"
                                       placeholder="Nhập tên, email hoặc số điện thoại khách hàng"
                                       value="${q}">
                                <button type="submit" class="customer-search__btn">Tìm kiếm</button>
                            </form>

                            <div class="customer-table-wrap">
                                <table class="customer-table">
                                    <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Khách hàng</th>
                                        <th>Email</th>
                                        <th>SĐT</th>
                                        <th>Số đơn</th>
                                        <th>Tổng chi tiêu</th>
                                        <th>Đơn gần nhất</th>
                                        <th>Thao tác</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach var="item" items="${purchaseStats}">
                                        <tr>
                                            <td>${item.userId}</td>
                                            <td>${item.customerName}</td>
                                            <td>${item.email}</td>
                                            <td>${empty item.phone ? '-' : item.phone}</td>
                                            <td>${item.totalOrders}</td>
                                            <td>${item.totalSpent}</td>
                                            <td>${empty item.lastOrderDate ? '-' : item.lastOrderDate}</td>
                                            <td>
                                                <a href="${pageContext.request.contextPath}/admin/purchase-history?userId=${item.userId}"
                                                   class="btn btn--default-color">
                                                    Xem chi tiết
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>

                                    <c:if test="${empty purchaseStats}">
                                        <tr>
                                            <td colspan="8" class="purchase-history-empty">Không có dữ liệu khách hàng</td>
                                        </tr>
                                    </c:if>
                                    </tbody>
                                </table>
                            </div>

                            <c:if test="${selectedUserId > 0}">
                                <div class="purchase-history-detail">
                                    <h3 class="purchase-history-detail__title">Chi tiết đơn hàng của khách ID: ${selectedUserId}</h3>

                                    <div class="customer-table-wrap">
                                        <table class="customer-table">
                                            <thead>
                                            <tr>
                                                <th>Mã đơn</th>
                                                <th>Khách hàng</th>
                                                <th>Trạng thái giao hàng</th>
                                                <th>Trạng thái thanh toán</th>
                                                <th>Ngày tạo</th>
                                                <th>Tổng tiền</th>
                                            </tr>
                                            </thead>
                                            <tbody>
                                            <c:forEach var="o" items="${selectedOrders}">
                                                <tr>
                                                    <td>${o.id}</td>
                                                    <td>${o.customerName}</td>
                                                    <td>${o.statusTransport}</td>
                                                    <td>${o.statusPayment}</td>
                                                    <td>${o.createdAt}</td>
                                                    <td>${o.totalPrice}</td>
                                                </tr>
                                            </c:forEach>

                                            <c:if test="${empty selectedOrders}">
                                                <tr>
                                                    <td colspan="6" class="purchase-history-empty">Khách này chưa có đơn hàng</td>
                                                </tr>
                                            </c:if>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </c:if>
                        </div>
                    </section>

                    <section id="order" class="manage-detail">
                        <h2 class="manage__heading">
                            <i class="fa-solid fa-box-open" style="margin-right:8px;"></i>Quản lý đơn hàng
                        </h2>

                        <div class="order-page-body">

                            <form id="searchOrderForm" action="${pageContext.request.contextPath}/order-search" method="get">
                                <input type="hidden" name="statusFilter" id="hiddenStatusFilter" value="">
                                <input type="hidden" name="paymentFilter" id="hiddenPaymentFilter" value="">

                                <div class="order-filter-bar">
                                    <div class="order-filter-bar__row">
                                        <div class="ofb-label">
                                            <i class="fa-solid fa-filter"></i> Tìm kiếm
                                        </div>
                                        <div class="ofb-search-wrap">
                                            <i class="fa-solid fa-magnifying-glass"></i>
                                            <input type="text"
                                                   name="keyword"
                                                   class="ofb-search-input"
                                                   placeholder="Nhập mã đơn hoặc tên khách hàng..."
                                                   value="${keyword}">
                                        </div>
                                        <button type="submit" class="ofb-btn-search">
                                            <i class="fa-solid fa-search"></i> Tìm kiếm
                                        </button>
                                        <button type="button" id="btnReloadAll" class="ofb-btn-reload">
                                            <i class="fa-solid fa-rotate-right"></i> Tất cả đơn
                                        </button>
                                    </div>


                                    <div class="order-filter-bar__chips">
                                        <span class="ofb-chips-label">Trạng thái:</span>
                                        <div class="ofb-chip-group" id="statusChipGroup">
                                            <span class="ofb-chip active"          data-val="">Tất cả</span>
                                            <span class="ofb-chip chip-new"        data-val="0">Đơn mới</span>
                                            <span class="ofb-chip chip-ship"       data-val="2">Đang giao</span>
                                            <span class="ofb-chip chip-done"       data-val="3">Đã giao</span>
                                            <span class="ofb-chip chip-cancel"     data-val="4">Đã hủy</span>
                                        </div>

                                        <div class="ofb-divider"></div>

                                        <span class="ofb-chips-label">Thanh toán:</span>
                                        <div class="ofb-chip-group" id="paymentChipGroup">
                                            <span class="ofb-chip active"      data-val="">Tất cả</span>
                                            <span class="ofb-chip chip-unpaid" data-val="0">Chưa TT</span>
                                            <span class="ofb-chip chip-paid"   data-val="2">Đã TT</span>
                                        </div>
                                    </div>
                                </div>
                            </form>


                            <div class="order-toolbar">
                                <div class="order-toolbar__title">
                                    Danh sách đơn hàng
                                    <span class="order-toolbar__count" id="orderCountBadge">0</span>
                                </div>
                                <div class="order-toolbar__actions">
                                    <button class="btn-delete-selected" id="btnDeleteSelected">
                                        <i class="fa-solid fa-trash-can"></i> Xóa đã chọn
                                    </button>
                                </div>
                            </div>

                            <div class="order-card">
                                <!-- Header -->
                                <div class="order-card__head">
                                    <div class="order-card__head-cell">
                                        <input type="checkbox" id="checkAllOrders" style="width:18px;height:18px;accent-color:#fff;cursor:pointer;">
                                    </div>
                                    <div class="order-card__head-cell">Mã</div>
                                    <div class="order-card__head-cell" style="justify-content:flex-start;padding-left:16px;">Khách hàng</div>
                                    <div class="order-card__head-cell">Trạng thái</div>
                                    <div class="order-card__head-cell">Thanh toán</div>
                                    <div class="order-card__head-cell">Ngày tạo</div>
                                    <div class="order-card__head-cell">Tổng tiền</div>
                                </div>
                                <div id="order-main-content">
                                    <jsp:include page="_order_list.jsp" />
                                </div>
                            </div>

                        </div>

                        <script>
                        (function() {
                            var form       = document.getElementById('searchOrderForm');
                            var hiddenSt   = document.getElementById('hiddenStatusFilter');
                            var hiddenPay  = document.getElementById('hiddenPaymentFilter');
                            var mainContent = document.getElementById('order-main-content');
                            var countBadge  = document.getElementById('orderCountBadge');

                            function updateCount() {
                                if (!countBadge || !mainContent) return;
                                countBadge.textContent = mainContent.querySelectorAll('.order-item').length;
                            }

                            function doAjaxSearch() {
                                if (!form || !mainContent) return;
                                var keyword = form.querySelector('[name=keyword]').value || '';
                                var status  = hiddenSt.value  || '';
                                var payment = hiddenPay.value || '';
                                var params = 'keyword=' + encodeURIComponent(keyword)
                                           + '&statusFilter='  + encodeURIComponent(status)
                                           + '&paymentFilter=' + encodeURIComponent(payment);
                                var url = form.action + '?' + params;
                                mainContent.innerHTML = '<div style="text-align:center;padding:30px;color:#aaa;"><i class=\"fa-solid fa-spinner fa-spin\"></i> Đang tải...</div>';
                                fetch(url, { headers: { 'X-Requested-With': 'XMLHttpRequest' } })
                                    .then(function(r){ return r.text(); })
                                    .then(function(html){
                                        mainContent.innerHTML = html;
                                        updateCount();
                                        rebindCheckAll();
                                    })
                                    .catch(function(){ mainContent.innerHTML = '<div style="padding:20px;color:red;">Lỗi tải dữ liệu!</div>'; });
                            }

                            function initChipGroup(groupId, hiddenInput) {
                                var group = document.getElementById(groupId);
                                if (!group) return;
                                group.querySelectorAll('.ofb-chip').forEach(function(chip) {
                                    chip.addEventListener('click', function() {
                                        group.querySelectorAll('.ofb-chip').forEach(function(c){ c.classList.remove('active'); });
                                        chip.classList.add('active');
                                        hiddenInput.value = chip.dataset.val;
                                        doAjaxSearch();
                                    });
                                });
                            }

                            initChipGroup('statusChipGroup',  hiddenSt);
                            initChipGroup('paymentChipGroup', hiddenPay);

                            if (form) {
                                form.addEventListener('submit', function(e) {
                                    e.preventDefault();
                                    doAjaxSearch();
                                });
                            }

                            var btnReload = document.getElementById('btnReloadAll');
                            if (btnReload) {
                                btnReload.addEventListener('click', function() {
                                    document.getElementById('searchOrderForm').querySelector('[name=keyword]').value = '';
                                    hiddenSt.value = '';
                                    hiddenPay.value = '';
                                    document.querySelectorAll('#statusChipGroup .ofb-chip').forEach(function(c, i){ c.classList.toggle('active', i===0); });
                                    document.querySelectorAll('#paymentChipGroup .ofb-chip').forEach(function(c, i){ c.classList.toggle('active', i===0); });
                                    doAjaxSearch();
                                });
                            }

                            var btnDelSel = document.getElementById('btnDeleteSelected');
                            if (btnDelSel) {
                                btnDelSel.addEventListener('click', function() {
                                    var checked = mainContent.querySelectorAll('.order-item__checkbox:checked');
                                    if (checked.length === 0) { alert('Vui lòng chọn ít nhất 1 đơn hàng!'); return; }
                                    if (!confirm('Xóa ' + checked.length + ' đơn hàng đã chọn?')) return;
                                    var fd = new FormData();
                                    checked.forEach(function(cb){ fd.append('orderIds', cb.value); });
                                    fetch('${pageContext.request.contextPath}/order-delete', {
                                        method: 'POST',
                                        headers: { 'X-Requested-With': 'XMLHttpRequest' },
                                        body: fd
                                    }).then(function(r){ return r.text(); })
                                      .then(function(html){ mainContent.innerHTML = html; updateCount(); rebindCheckAll(); });
                                });
                            }

                            function rebindCheckAll() {
                                var ca = document.getElementById('checkAllOrders');
                                if (!ca) return;
                                ca.checked = false;
                                ca.addEventListener('change', function() {
                                    mainContent.querySelectorAll('.order-item__checkbox').forEach(function(cb){ cb.checked = ca.checked; });
                                });
                            }

                            rebindCheckAll();
                            updateCount();

                            mainContent && mainContent.addEventListener('click', function(e) {
                                var btn = e.target.closest('.js-update-order');
                                if (!btn || !mainContent.contains(btn)) return;

                                e.preventDefault();
                                e.stopPropagation();

                                var row = btn.closest('.order-item');
                                var box = btn.closest('.order-update-box');
                                var select = box ? box.querySelector('select[name="status"]') : null;

                                var orderId = btn.dataset.orderId || (box ? box.dataset.orderId : '') || (row ? row.dataset.orderId : '');
                                var type = btn.dataset.type || (box ? box.dataset.type : '');
                                var status = select ? select.value : '';

                                if (!orderId || !type || status === '') {
                                    alert('Thiếu dữ liệu cập nhật: orderId=' + orderId + ', type=' + type + ', status=' + status);
                                    return;
                                }

                                var params = new URLSearchParams();
                                params.set('orderId', orderId);
                                params.set('type', type);
                                params.set('status', status);

                                btn.disabled = true;
                                btn.classList.add('btn-save--saved');

                                fetch('${pageContext.request.contextPath}/order-update-status', {
                                    method: 'POST',
                                    body: params.toString(),
                                    headers: {
                                        'X-Requested-With': 'XMLHttpRequest',
                                        'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8'
                                    }
                                })
                                .then(function(r) {
                                    if (!r.ok) {
                                        return r.text().then(function(msg) {
                                            throw new Error(msg || 'Cập nhật thất bại');
                                        });
                                    }
                                    return r.text();
                                })
                                .then(function(html) {
                                    mainContent.innerHTML = html;
                                    updateCount();
                                    rebindCheckAll();
                                    alert('Cập nhật thành công!');
                                })
                                .catch(function(err) {
                                    alert('Lỗi cập nhật: ' + err.message);
                                    btn.disabled = false;
                                    btn.classList.remove('btn-save--saved');
                                });
                            });
                        })();
                        </script>
                    </section>
                </div>
            </div>
        </div>
    </div>
</main>
</body>

<script>

    const sectionWarehouse = document.getElementById("warehouse");
    const sectionConfig = document.getElementById("config");
    const sectionProduct = document.getElementById("product");
    const sectionAdd = document.getElementById("add-product");
    const sectionOrder = document.getElementById("order");
    const sectionCustomer = document.getElementById("customer");
    const sectionPurchaseHistory = document.getElementById("purchase-history");
    const sectionCustomerDetail = document.getElementById("customer-detail");
    const sectionCustomerEdit = document.getElementById("customer-edit");
    const sectionNews = document.getElementById("news");
    const newsMenuButtons = document.querySelectorAll(".news-menu__btn");
    const sectionSlideDetail = document.getElementById("slide-detail");
    const sectionBlogDetail = document.getElementById("blog-detail");
    const sectionSlideEdit = document.getElementById("slide-edit");
    const sectionBlogEdit = document.getElementById("blog-edit");
    const sectionSlide = document.getElementById("news-slide");
    const sectionBlog = document.getElementById("news-blog");
    const sectionSlideAdd = document.getElementById("add-slide");
    const sectionBlogAdd  = document.getElementById("add-blog");
    const btnAddSlide = document.querySelector("#news-slide .add-table__btn");
    const btnAddBlog  = document.querySelector("#news-blog .add-table__btn");
    const productMenuButtons = document.querySelectorAll(".product-menu__btn");
    const sectionProductDetail = document.getElementById("viewProductModal");
    const sectionProductEdit = document.getElementById("editProductPage");
    const sectionProductList = document.getElementById("product-list-section");
    const sectionProductEvent = document.getElementById("product-event-section");
    const sectionEventAdd = document.getElementById("add-event-page");
    const btnAddEventTrigger = document.querySelector(".event-header__btn");

    slideSelect = document.getElementById('eventSlideSelect');
    const selectedBox = slideSelect ? slideSelect.querySelector('.event-select__selected') : null;
    const optionsBox = slideSelect ? slideSelect.querySelector('.event-select__options') : null;
    const hiddenInput = document.getElementById('eventSlideTargetHidden');
    const options = slideSelect ? slideSelect.querySelectorAll('.event-option') : [];
    const uploadGroup = document.getElementById('eventUploadGroup');
    const editScopeRadios = document.querySelectorAll('input[name="editApplyScope"]');
    const editBoxCategory = document.getElementById('editScopeCategory');
    const editBoxSpecific = null;
    const sectionEventView = document.getElementById("view-event-page");
    const sectionEventEdit = document.getElementById("edit-event-page");
    const editSlideSelect = document.getElementById('editEventSlideSelect');
    const sidebarItems = document.querySelectorAll(".product-sidebar__item");
    const sidebarSubLinks = document.querySelectorAll(".product-sub__link");
    const productContents = {
        "product-list": document.getElementById("product-list-section"),
        "product-event": document.getElementById("product-event-section")
    };

    const newsSections = {
        "news-slide": document.getElementById("news-slide"),
        "news-blog": document.getElementById("news-blog")
    };

    const menuLinks = document.querySelectorAll(".manage-nav__link");
    const btnAdd = document.querySelector(".product-table__btn");

    // Hàm ẩn tất cả section
    function hideAllSections() {
        sectionProduct.style.display = "none";
        sectionAdd.style.display = "none";
        sectionOrder.style.display = "none";
        sectionConfig.style.display = "none";
        sectionCustomer.style.display = "none";
        sectionPurchaseHistory.style.display = "none";
        sectionCustomerDetail.style.display = "none";
        sectionCustomerEdit.style.display = "none";
        sectionNews.style.display = "none";
        sectionProductDetail.style.display = "none";
        sectionProductEdit.style.display = "none";
        sectionProductEvent.style.display = "none";
        sectionEventAdd.style.display = "none";
        sectionEventView.style.display = "none";
        sectionEventEdit.style.display = "none";
        sectionWarehouse.style.display = "none";

    }

    const serverTab = "${tab}";

    function setActiveMenu(targetKey) {
        menuLinks.forEach(link => link.classList.remove("manage-nav__link--active"));

        menuLinks.forEach(link => {
            const href = link.getAttribute("href") || "";

            if (targetKey === "config" && (href === "#config" || href.includes("/admin/revenue"))) {
                link.classList.add("manage-nav__link--active");
            }
            if (targetKey === "news" && href === "#news") {
                link.classList.add("manage-nav__link--active");
            }
            if (targetKey === "product" && href === "#product") {
                link.classList.add("manage-nav__link--active");
            }
            if (targetKey === "warehouse" && href === "#warehouse") {
                link.classList.add("manage-nav__link--active");
            }
            if (targetKey === "order" && href.includes("/order-admin")) {
                link.classList.add("manage-nav__link--active");
            }
            if (targetKey === "customers" && href.includes("/admin/customers")) {
                link.classList.add("manage-nav__link--active");
            }
            if (targetKey === "purchaseHistory" && href.includes("/admin/purchase-history")) {
                link.classList.add("manage-nav__link--active");
            }
        });
    }

    function openMainSection(targetKey) {
        hideAllSections();

        if (targetKey === "customers") {
            sectionCustomer.style.display = "block";
        } else if (targetKey === "purchaseHistory") {
            sectionPurchaseHistory.style.display = "block";
        } else if (targetKey === "product") {
            sectionProduct.style.display = "block";
        } else if (targetKey === "order") {
            sectionOrder.style.display = "block";
        } else if (targetKey === "news") {
            sectionNews.style.display = "block";
            showNewsDefault();
        }
        else if (targetKey === "warehouse") {
            sectionWarehouse.style.display = "block";
        }else {
            sectionConfig.style.display = "block";
        }

        setActiveMenu(targetKey);
    }

    window.addEventListener("DOMContentLoaded", () => {
        if (serverTab && serverTab.trim() !== "") {
            openMainSection(serverTab);
            return;
        }

        const hash = window.location.hash;

        if (hash === "#config") {
            openMainSection("config");
        } else if (hash === "#news") {
            openMainSection("news");
        } else if (hash === "#product") {
            openMainSection("product");
        } else if (hash === "#order") {
            openMainSection("order");
        } else {
            openMainSection("product"); // mặc định mở product
        }
    });

    menuLinks.forEach(link => {
        link.addEventListener("click", function (e) {
            const href = this.getAttribute("href") || "";

            if (!href.startsWith("#")) return;

            e.preventDefault();
            const targetId = href.substring(1);

            if (targetId === "config") openMainSection("config");
            if (targetId === "news") openMainSection("news");
            if (targetId === "product") openMainSection("product");
            if (targetId === "order") openMainSection("order");
            if (targetId === "customer" || targetId === "customers") openMainSection("customers");
            if (targetId === "warehouse") openMainSection("warehouse");
        });
    });

    productMenuButtons.forEach(btn => {
        btn.addEventListener("click", () => {
            const targetId = btn.getAttribute("data-target");

            // Ẩn các content trong product
            Object.values(productContents).forEach(content => {
                if(content) content.style.display = "none";
            });
            productMenuButtons.forEach(b => b.classList.remove("active"));

            if(productContents[targetId]) {
                productContents[targetId].style.display = "block";
            }
            btn.classList.add("active");
        });
    });

    sidebarItems.forEach(item => {
        const parentLink = item.querySelector(".product-sidebar__link");

        parentLink.addEventListener("click", (e) => {
            e.preventDefault();

            const isActive = item.classList.contains("active") || item.classList.contains("product-sidebar__item--active");

            sidebarItems.forEach(i => {
                i.classList.remove("active");
                i.classList.remove("product-sidebar__item--active");


                const childLinks = i.querySelectorAll(".product-sub__link");
                childLinks.forEach(link => link.classList.remove("active"));
            });

            if (!isActive) {

                item.classList.add("active");

                const firstSub = item.querySelector(".product-sub__link");
                if (firstSub) {
                    firstSub.classList.add("active");
                }
            } else {
                console.log("Đã đóng menu");
            }
        });
    });


    sidebarSubLinks.forEach(sub => {
        sub.addEventListener("click", (e) => {
            e.preventDefault();
            e.stopPropagation();

            sidebarSubLinks.forEach(s => s.classList.remove("active"));

            sub.classList.add("active");
        });
    });

    function initProductDefault() {
        Object.values(productContents).forEach(c => { if(c) c.style.display = "none"; });
        productContents["product-list"].style.display = "block";
        productMenuButtons.forEach(b => b.classList.remove("active"));
        document.querySelector(".product-menu__btn[data-target='product-list']").classList.add("active");

        sidebarItems.forEach(i => i.classList.remove("active"));
        sidebarSubLinks.forEach(s => s.classList.remove("active"));

        if(sidebarItems[0]) sidebarItems[0].classList.add("active");
        if(sidebarSubLinks[0]) sidebarSubLinks[0].classList.add("active");
    }
    productMenuButtons.forEach(button => {
        button.addEventListener("click", function() {
            productMenuButtons.forEach(btn => btn.classList.remove("active"));
            this.classList.add("active");

            const target = this.getAttribute("data-target");

            if (target === "product-list") {

                sectionProductList.style.display = "block";
                sectionProductEvent.style.display = "none";
                document.querySelector(".product-sidebar").style.display = "block";
            }
            else if (target === "product-event") {

                sectionProductList.style.display = "none";
                sectionProductEvent.style.display = "block";
                document.querySelector(".product-sidebar").style.display = "none";
            }
        });
    });

    if (btnAddEventTrigger) {
        btnAddEventTrigger.addEventListener("click", () => {
            hideAllSections();
            sectionEventAdd.style.display = "block";
            window.scrollTo({ top: 0, behavior: "smooth" });
        });
    }

    function backToEventList() {

        sectionEventAdd.style.display = "none";


        sectionProduct.style.display = "block";


        sectionProductEvent.style.display = "block";
        sectionProductList.style.display = "none";
        sectionEventView.style.display = "none";
        sectionEventEdit.style.display = "none";


        const sidebar = document.querySelector(".product-sidebar");
        if (sidebar) sidebar.style.display = "none";


        productMenuButtons.forEach(btn => {
            if (btn.getAttribute("data-target") === "product-event") {
                btn.classList.add("active");
            } else {
                btn.classList.remove("active");
            }
        });

        window.scrollTo({ top: 0, behavior: "smooth" });
    }


    const scopeRadios = document.querySelectorAll('input[name="applyScope"]');
    const boxCategory = document.getElementById('scopeCategory');
    const boxSpecific = null;

    scopeRadios.forEach(radio => {
        radio.addEventListener('change', (e) => {
            const val = e.target.value;


            boxCategory.style.display = "none";

            if (val === "category") {
                boxCategory.style.display = "block";
            }
        });
    });

    if (slideSelect && selectedBox && optionsBox) {
        selectedBox.addEventListener('click', (e) => {
            e.stopPropagation();
            slideSelect.classList.toggle('active');

            if (slideSelect.classList.contains('active')) {
                optionsBox.style.display = 'block';
            } else {
                optionsBox.style.display = 'none';
            }
        });

        options.forEach(option => {
            option.addEventListener('click', (e) => {
                e.stopPropagation();

                const val = option.getAttribute('data-value')
                selectedBox.innerHTML = option.innerHTML;

                if(hiddenInput) hiddenInput.value = val;

                slideSelect.classList.remove('active');
                optionsBox.style.display = 'none';
            });
        });

        document.addEventListener('click', () => {
            if (slideSelect.classList.contains('active')) {
                slideSelect.classList.remove('active');
                optionsBox.style.display = 'none';
            }
        });
    }
    editScopeRadios.forEach(radio => {
        radio.addEventListener('change', (e) => {
            editBoxCategory.style.display = (e.target.value === "category") ? "block" : "none";
        });
    });
    document.querySelectorAll(".event-table__row .event-col-action:nth-child(5)").forEach(btn => {

        btn.addEventListener("click", function() {
            hideAllSections();


            if (sectionEventView) {
                sectionEventView.style.display = "block";
                window.scrollTo({ top: 0, behavior: "smooth" });
            }
        });
    });

    // Chức năng Sửa sự kiện
    document.querySelectorAll(".event-table__row .event-col-action:nth-child(6)").forEach(btn => {
        // Tìm cột Sửa (thường là cột thứ 6 trong hàng)
        btn.addEventListener("click", function() {
            hideAllSections();

            if (sectionEventEdit) {
                sectionEventEdit.style.display = "block";
                window.scrollTo({ top: 0, behavior: "smooth" });
            }
        });
    });
    if (editSlideSelect) {
        const editSelectedBox = editSlideSelect.querySelector('.ev-slide-sel__selected');
        const editOptionsBox = editSlideSelect.querySelector('.ev-slide-sel__options');
        const editHiddenInput = document.getElementById('editEventSlideTargetHidden');
        const editOptions = editSlideSelect.querySelectorAll('.ev-slide-opt');

        // Click vào hộp đã chọn để sổ menu ra hoặc đóng lại
        editSelectedBox.addEventListener('click', (e) => {
            e.stopPropagation(); // Ngăn sự kiện nổi bọt lên document

            // Đóng các dropdown khác nếu có (tùy chọn)
            const isOpen = editOptionsBox.style.display === 'block';
            editOptionsBox.style.display = isOpen ? 'none' : 'block';
            editSlideSelect.classList.toggle('active', !isOpen);
        });

        // Click chọn từng Option
        editOptions.forEach(option => {
            option.addEventListener('click', (e) => {
                e.stopPropagation();

                // Lấy giá trị data-value
                const val = option.getAttribute('data-value');
                if (val === null) return; // Bỏ qua nếu click trúng phần header không có value

                // Cập nhật giao diện của hộp "Đã chọn" (Copy toàn bộ nội dung HTML của option vào hộp chính)
                editSelectedBox.innerHTML = option.innerHTML;

                // Cập nhật giá trị vào input hidden để gửi đi khi lưu form
                editHiddenInput.value = val;

                // Đóng menu sổ xuống
                editOptionsBox.style.display = 'none';
                editSlideSelect.classList.remove('active');

                console.log("Đã chọn slide:", val);
            });
        });

        document.addEventListener('click', () => {
            if (editOptionsBox.style.display === 'block') {
                editOptionsBox.style.display = 'none';
                editSlideSelect.classList.remove('active');
            }
        });
    }
    // Click "Thêm sản phẩm"
    btnAdd.addEventListener("click", () => {
        hideAllSections();       // ẩn tất cả trước
        sectionAdd.style.display = "block"; // chỉ hiện form thêm sản phẩm
    });

    // Nếu muốn quay lại bảng sản phẩm, có thể thêm nút "Quay lại"
    const backBtn = document.createElement("button");
    backBtn.textContent = "Quay lại danh sách sản phẩm";
    backBtn.className = "btn btn--default-color product-table__back-btn";
    sectionAdd.appendChild(backBtn);

    backBtn.addEventListener("click", () => {
        sectionAdd.style.display = "none";
        sectionProduct.style.display = "block";
    });
    //  Gán sự kiện cho các nút "Xem" trong bảng sản phẩm
    document.querySelectorAll(".product-table__row .product-table__view").forEach(btn => {
        if (btn.textContent.trim() === "Xem") {
            btn.addEventListener("click", function() {
                hideAllSections();

                sectionProductDetail.style.display = "block";
                sectionProductDetail.style.position = "static";
                sectionProductDetail.style.backgroundColor = "transparent";
                sectionProductDetail.style.padding = "0";

                window.scrollTo({ top: 0, behavior: "smooth" });

            });
        }
    });


    document.querySelectorAll(".product-table__row .product-table__edit").forEach(btn => {
        if (btn.textContent.trim() === "Sửa") {
            btn.addEventListener("click", function() {
                hideAllSections(); // Bước này sẽ ẩn trang Product (Danh sách)

                sectionProductEdit.style.display = "block"; // Hiện trang Edit
                sectionProductEdit.style.position = "static";
                sectionProductEdit.style.backgroundColor = "transparent";
                sectionProductEdit.style.padding = "0";

                window.scrollTo({ top: 0, behavior: "smooth" });
            });
        }
    });

    function backToList() {
        sectionProductDetail.style.display = "none";
        sectionProduct.style.display = "block";
        window.scrollTo({ top: 0, behavior: "smooth" });
    }

    // Hàm quay lại cho trang SỬA sản phẩm
    function backFromEdit() {
        // Ẩn trang Edit
        sectionProductEdit.style.display = "none";
        // Hiện lại trang danh sách
        sectionProduct.style.display = "block";
        window.scrollTo({ top: 0, behavior: "smooth" });
    }


    // Xử lý submit form
    const formInline = document.getElementById("addProductFormInline");
    formInline.addEventListener("submit", (e) => {
        e.preventDefault();
        console.log("Thêm sản phẩm inline:", {
            name: document.getElementById("productNameInline").value,
            image: document.getElementById("productImageInline").files[0],
            date: document.getElementById("productDateInline").value
        });

        // Sau khi submit xong, quay lại bảng sản phẩm
        sectionAdd.style.display = "none";
        sectionProduct.style.display = "block";
        formInline.reset();
    });


    // Click nút "Đóng"
    const btnBackCustomer = document.querySelector(
        "#customer-detail .btn--default-color"
    );

    if (btnBackCustomer) {
        btnBackCustomer.addEventListener("click", () => {
            sectionCustomerDetail.style.display = "none";
            sectionCustomer.style.display = "block";

            window.scrollTo({ top: 0, behavior: "smooth" });
        });
    }
    // SỬA KHÁCH HÀNG (mở form + đổ dữ liệu)
    function updateCustomerEditStatusBadge(status) {
        const badge = document.getElementById("customerEditStatusBadge");
        if (!badge) return;

        if (String(status) === "1") {
            badge.textContent = "Đang hoạt động";
            badge.classList.remove("offline");
            badge.classList.add("online");
        } else {
            badge.textContent = "Bị khóa";
            badge.classList.remove("online");
            badge.classList.add("offline");
        }
    }
    document.addEventListener("DOMContentLoaded", () => {
      document.querySelectorAll(".customer-table__edit").forEach(btn => {
        btn.addEventListener("click", () => {
          hideAllSections();
          sectionCustomerEdit.style.display = "block";
          window.scrollTo({ top: 0, behavior: "smooth" });

          // đổ dữ liệu từ data-* vào form
          document.getElementById("editId").value = btn.dataset.id || "";
          document.getElementById("editName").value = btn.dataset.name || "";
          document.getElementById("editEmail").value = btn.dataset.email || "";
          document.getElementById("editPhone").value = btn.dataset.phone || "";
          document.getElementById("editAddress").value = btn.dataset.address || "";
          document.getElementById("editCreatedAt").value = btn.dataset.created || "-";
          document.getElementById("editUpdatedAt").value = btn.dataset.updated || "-";

          // role/status -> đổ vào SELECT (phải chắc id không trùng)
          const roleEl = document.getElementById("editRole");
          if (roleEl) roleEl.value = (btn.dataset.role ?? "0");

          const statusEl = document.getElementById("editStatus");
          if (statusEl) {
              statusEl.value = (btn.dataset.status ?? "1");
              updateCustomerEditStatusBadge(statusEl.value);
          }

          // password luôn để trống
          const passEl = document.getElementById("editPassword");
          if (passEl) passEl.value = "";
        });
      });
              const editStatusEl = document.getElementById("editStatus");
              if (editStatusEl) {
                editStatusEl.addEventListener("change", function () {
                  updateCustomerEditStatusBadge(this.value);
                });
              }
      // XEM KHÁCH HÀNG (mở detail + đổ dữ liệu)
      document.querySelectorAll(".customer-table__view").forEach(btn => {
        btn.addEventListener("click", () => {
          hideAllSections();
          sectionCustomerDetail.style.display = "block";
          window.scrollTo({ top: 0, behavior: "smooth" });

          document.getElementById("customerDetailName").textContent = btn.dataset.name || "";
          document.getElementById("customerDetailEmail").textContent = btn.dataset.email || "";
          document.getElementById("customerDetailPhone").textContent = btn.dataset.phone || "";
          document.getElementById("customerDetailAddress").textContent = btn.dataset.address || "";
          document.getElementById("customerDetailCreatedAt").textContent = btn.dataset.created || "-";
          document.getElementById("customerDetailUpdatedAt").textContent = btn.dataset.updated || "-";

          // status badge (online/offline)
          const st = btn.dataset.status; // "1" hoặc "0"
          const statusBadge = document.getElementById("customerDetailStatus");
          if (statusBadge) {
            if (st === "1") {
              statusBadge.textContent = "Đang hoạt động";
              statusBadge.classList.remove("offline");
              statusBadge.classList.add("online");
            } else {
              statusBadge.textContent = "Bị khóa";
              statusBadge.classList.remove("online");
              statusBadge.classList.add("offline");
            }
          }

          const av = btn.dataset.avatar || "";
          const avatarEl = document.getElementById("customerDetailAvatar");
          const contextPath = "${pageContext.request.contextPath}";
          const defaultAvatar = contextPath + "/assets/img/default-avatar.png";

          if (avatarEl) {
            avatarEl.onerror = function () {
              this.onerror = null;
              this.src = defaultAvatar;
            };

            if (!av) {
              avatarEl.src = defaultAvatar;
            } else if (
              av.startsWith("http://") ||
              av.startsWith("https://") ||
              av.startsWith(contextPath + "/")
            ) {
              avatarEl.src = av;
            } else {
              avatarEl.src = contextPath + "/" + av.replace(/^\/+/, "");
            }
          }

          // role text
          const r = btn.dataset.role; // "1" hoặc "0"
          const roleEl = document.getElementById("customerDetailRole");
          if (roleEl) roleEl.textContent = (r === "1") ? "Admin" : "User";

          // status text riêng
          const stTextEl = document.getElementById("customerDetailStatusText");
          if (stTextEl) stTextEl.textContent = (st === "1") ? "Đang hoạt động" : "Bị khóa";
        });
      });
    });


    function hideCustomerEdit() {
        hideAllSections();
        sectionCustomer.style.display = "block";
        window.scrollTo({ top: 0, behavior: "smooth" });
    }

    function hideAllNewsSections() {
        Object.values(newsSections).forEach(sec => sec.style.display = "none");
        newsMenuButtons.forEach(btn => btn.classList.remove("active"));
    }


    function showNewsDefault() {
        sectionNews.style.display = "block";
        hideAllNewsSections();
        newsSections["news-slide"].style.display = "block";
        document.querySelector(".news-menu__btn[data-target='news-slide']").classList.add("active");
    }

    // Click menu sidebar trong News
    newsMenuButtons.forEach(btn => {
        btn.addEventListener("click", () => {
            const targetId = btn.getAttribute("data-target");
            hideAllNewsSections();
            if(newsSections[targetId]) newsSections[targetId].style.display = "block";
            btn.classList.add("active");
        });
    });
    function hideAllDetailSections() {
        sectionSlideDetail.style.display = "none";
        sectionBlogDetail.style.display = "none";
        sectionSlideEdit.style.display = "none";
        sectionBlogEdit.style.display = "none";
    }

    document.querySelectorAll("#news-slide .news-table__view").forEach(btn => {
        btn.addEventListener("click", () => {
            hideAllSections();
            hideAllDetailSections();
            sectionSlideDetail.style.display = "block";
            window.scrollTo({ top: 0, behavior: "smooth" });
        });
    });

    document.querySelectorAll("#news-blog .news-table__view").forEach(btn => {
        btn.addEventListener("click", () => {
            hideAllSections();
            hideAllDetailSections();
            sectionBlogDetail.style.display = "block";
            window.scrollTo({ top: 0, behavior: "smooth" });
        });
    });

    document.querySelectorAll(".news-table__edit").forEach(btn => {
        btn.addEventListener("click", () => {
            const parentTable = btn.closest(".news-table");
            hideAllSections();
            hideAllDetailSections();
            if (parentTable.id === "news-slide") sectionSlideEdit.style.display = "block";
            if (parentTable.id === "news-blog") sectionBlogEdit.style.display = "block";
            window.scrollTo({ top: 0, behavior: "smooth" });
        });
    });

    function showNewsWithTab(tabId) {
        sectionNews.style.display = "block";

        hideAllNewsSections();

        if (newsSections[tabId]) {
            newsSections[tabId].style.display = "block";
            document
                .querySelector(".news-menu__btn[data-target='" + tabId + "']")
                .classList.add("active");
        }

        window.scrollTo({ top: 0, behavior: "smooth" });
    }

    function hideSlideDetail() {
        sectionSlideDetail.style.display = "none";
        showNewsWithTab("news-slide");
    }

    function hideBlogDetail() {
        sectionBlogDetail.style.display = "none";
        showNewsWithTab("news-blog");
    }

    // Nút hủy Slide/Blog Edit
    function hideSlideEdit() {
        sectionSlideEdit.style.display = "none";
        showNewsWithTab("news-slide");
    }

    function hideBlogEdit() {
        sectionBlogEdit.style.display = "none";
        showNewsWithTab("news-blog");
    }

    function hideAllNewsViews() {
        sectionSlide.style.display = "none";
        sectionBlog.style.display  = "none";

        sectionSlideAdd.style.display = "none";
        sectionBlogAdd.style.display  = "none";

        sectionSlideDetail.style.display = "none";
        sectionBlogDetail.style.display  = "none";
        sectionSlideEdit.style.display   = "none";
        sectionBlogEdit.style.display    = "none";

        newsMenuButtons.forEach(btn => btn.classList.remove("active"));
    }

    if (btnAddSlide) {
        btnAddSlide.addEventListener("click", () => {
            hideAllSections();
            hideAllNewsViews();

            sectionNews.style.display = "block";
            sectionSlideAdd.style.display = "block";

            document
                .querySelector(".news-menu__btn[data-target='news-slide']")
                .classList.add("active");

            window.scrollTo({ top: 0, behavior: "smooth" });
        });
    }

    if (btnAddBlog) {
        btnAddBlog.addEventListener("click", () => {
            hideAllSections();
            hideAllNewsViews();

            sectionNews.style.display = "block";
            sectionBlogAdd.style.display = "block";

            document
                .querySelector(".news-menu__btn[data-target='news-blog']")
                .classList.add("active");

            window.scrollTo({ top: 0, behavior: "smooth" });
        });
    }

    function hideSlideAdd() {
        hideAllNewsViews();
        sectionNews.style.display = "block";
        sectionSlide.style.display = "block";

        document
            .querySelector(".news-menu__btn[data-target='news-slide']")
            .classList.add("active");

        window.scrollTo({ top: 0, behavior: "smooth" });
    }

    function hideBlogAdd() {
        hideAllNewsViews();
        sectionNews.style.display = "block";
        sectionBlog.style.display = "block";

        document
            .querySelector(".news-menu__btn[data-target='news-blog']")
            .classList.add("active");

        window.scrollTo({ top: 0, behavior: "smooth" });
    }
    document.getElementById('brandSelect').addEventListener('change', function() {
        if (this.value === 'add-new') {
            openModal('brandModal');
            this.value = "";
        }
    });

    document.getElementById('tagSelect').addEventListener('change', function() {
        if (this.value === 'add-new') {
            openModal('tagModal');
            this.value = "";
        }
    });
    document.getElementById('cateSelect').addEventListener('change', function() {
        if (this.value === 'add-new') {
            openModal('cateModal');
            this.value = "";
        }
    });

</script>

<%--<script>--%>
<%--    document.getElementById('addSlideForm').addEventListener('submit', function(e) {--%>
<%--        e.preventDefault();--%>

<%--        const formData = new FormData(this);--%>

<%--        const saveBtn = this.closest('.slide-table').querySelector('.slide-table__save');--%>
<%--        saveBtn.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i> Đang lưu...';--%>
<%--        saveBtn.disabled = true;--%>

<%--        fetch('${pageContext.request.contextPath}/api/add-slide', {--%>
<%--            method: 'POST',--%>
<%--            body: formData--%>
<%--        })--%>
<%--            .then(response => response.json())--%>
<%--            .then(data => {--%>
<%--                if (data.status === "success") {--%>
<%--                    alert("Thêm slide thành công!");--%>
<%--                    location.reload();--%>
<%--                } else {--%>
<%--                    alert("Lỗi: " + data.message);--%>
<%--                }--%>
<%--            })--%>
<%--            .catch(error => {--%>
<%--                console.error('Error:', error);--%>
<%--                alert("Đã có lỗi xảy ra khi kết nối server.");--%>
<%--            })--%>
<%--            .finally(() => {--%>
<%--                saveBtn.innerHTML = '<i class="fa-solid fa-floppy-disk"></i> Lưu slide';--%>
<%--                saveBtn.disabled = false;--%>
<%--            });--%>
<%--    });--%>
<%--</script>--%>

<script>
    document.addEventListener("DOMContentLoaded", function() {
        quill = new Quill('#editor', {
            theme: 'snow',
            modules: {
                toolbar: [
                    [{ header: [1, 2, 3, false] }],
                    ['bold', 'italic', 'underline', 'strike'],
                    [{ list: 'ordered' }, { list: 'bullet' }],
                    ['link', 'image'],
                    ['clean']
                ]
            }
        });

        quill.setText('Nội dung');
    });


    function openModal(id) {
        const modal = document.getElementById(id);
        if (modal) {
            modal.style.display = 'flex';
        }
    }

    function closeModal(id) {
        const modal = document.getElementById(id);
        if (modal) {
            modal.style.display = 'none';
        }

        if (id === 'brandModal') {
            const brandSelect = document.getElementById('brandSelect');
            if (brandSelect) brandSelect.value = '';
        }
        if (id === 'tagModal') {
            const tagSelect = document.getElementById('tagSelect');
            if (tagSelect) tagSelect.value = '';
        }
        if (id === 'cateModal') {
            const cateSelect = document.getElementById('cateSelect');
            if (cateSelect) cateSelect.value = '';
        }
    }

    window.onclick = function(event) {
        if (event.target.classList.contains('admin-modal')) {
            event.target.style.display = "none";
        }
    }

    function saveNewBrand() {
        const form = document.getElementById('addBrandFormQuick');
        if(!form) return;

        const formData = new FormData(form);

        fetch('/WebGiaDung/api/add-brands', {
            method: 'POST',
            body: formData
        })
            .then(response => {
                if (!response.ok) throw new Error("Mạng có vấn đề hoặc Server lỗi");
                return response.json();
            })
            .then(data => {
                if (data.status === "success") {
                    const select = document.getElementById('brandSelect');
                    if (select) {
                        const newOption = new Option(data.brandName, data.brandID, true, true);
                        select.add(newOption, select.options[select.length - 1]);
                    }

                    closeModal('brandModal');
                    form.reset();
                    alert("Thêm nhãn hiệu thành công!");
                } else {
                    alert("Không thể lưu: " + data.message);
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert("Lỗi kết nối server!");
            });
    }

    function saveNewTag() {
        const tagName = document.getElementById('newTagName').value;
        const tagDesc = document.getElementById('newTagDesc').value;

        if (!tagName) {
            alert("Vui lòng nhập tên từ khóa");
            return;
        }

        const params = new URLSearchParams();
        params.append('tagName', tagName);
        params.append('tagDesc', tagDesc);

        fetch('/WebGiaDung/api/add-tag', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: params
        })
            .then(response => response.json())
            .then(data => {
                if (data.status === "success") {
                    const select = document.getElementById('tagSelect');
                    const newOption = new Option(tagName, data.tagID, true, true);
                    select.add(newOption, select.options[select.length - 1]);

                    closeModal('tagModal');
                    document.getElementById('addTagFormQuick').reset();
                    alert("Thêm từ khóa thành công!");
                } else {
                    alert("Lỗi: " + data.message);
                }
            })
            .catch(error => console.error('Error:', error));
    }


    function saveNewCategory() {
        const cateName = document.getElementById('newCateName').value;
        const cateDesc = document.getElementById('newCateDesc').value;

        const params = new URLSearchParams();
        params.append('cateName', cateName);
        params.append('cateDesc', cateDesc);

        fetch('/WebGiaDung/api/add-category', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: params
        })
            .then(response => response.json())
            .then(data => {
                if (data.status === "success") {
                    const select = document.getElementById('cateSelect');

                    const newOption = new Option(data.cateName, data.cateID, true, true);
                    select.add(newOption, select.options[select.length - 1]);

                    closeModal('cateModal');
                    // Reset form
                    document.getElementById('addCateFormQuick').reset();
                    alert("Thêm danh mục thành công!");
                } else {
                    alert("Lỗi: " + data.message);
                }
            })
            .catch(error => console.error('Error:', error));
    }

    function removeItem(id) {
        var element = document.getElementById(id);
        if (element) {
            element.remove();
        }
    }

    function addMainImage() {
        var fileInput = document.getElementById('mainImgTemp');

        if (!fileInput.files || fileInput.files.length === 0) {
            alert("Vui lòng chọn một file ảnh trước!");
            return;
        }

        var list = document.getElementById('mainImageStatusList');
        var file = fileInput.files[0];

        var itemId = 'main-img-' + Date.now();

        var newFileInput = fileInput.cloneNode();
        newFileInput.style.display = 'none';
        newFileInput.name = "productImages[]";

        var html = '<div class="added-item" id="' + itemId + '">' +
            '<span>' +
            '<i class="fas fa-image"></i> ' +
            '<strong>Ảnh:</strong> ' + file.name +
            '</span>' +
            '<button type="button" onclick="removeItem(\'' + itemId + '\')" class="btn-remove">Xóa</button>' +
            '</div>';

        var wrapper = document.createElement('div');
        wrapper.innerHTML = html;
        var itemDiv = wrapper.firstElementChild;

        itemDiv.appendChild(newFileInput);
        list.appendChild(itemDiv);

        fileInput.value = '';
    }
    function addDescription() {
        const title = document.getElementById('descTitle').value;
        const content = document.getElementById('descContent').value;

        if (!title || !content) {
            alert("Vui lòng nhập đầy đủ tiêu đề và nội dung mô tả!");
            return;
        }

        const list = document.getElementById('descriptionList');
        const itemIdx = list.children.length;

        const html = '<div class="added-item" id="desc-item-' + itemIdx + '">' +
            '<span><strong>' + title + ':</strong> ' + content + '</span>' +
            '<input type="hidden" name="descTitles[]" value="' + title + '">' +
            '<input type="hidden" name="descContents[]" value="' + content + '">' +
            '<button type="button" onclick="removeItem(\'desc-item-' + itemIdx + '\')" class="btn-remove">Xóa</button>' +
            '</div>';
        list.insertAdjacentHTML('beforeend', html);

        document.getElementById('descTitle').value = '';
        document.getElementById('descContent').value = '';
    }

    function addDetail() {
        const fileInput = document.getElementById('detailImg');
        const title = document.getElementById('detailTitle').value;
        const content = document.getElementById('detailContent').value;

        if (!fileInput.files[0] || !title) {
            alert("Vui lòng chọn ảnh và nhập tiêu đề chi tiết!");
            return;
        }

        const list = document.getElementById('detailList');
        const itemIdx = list.children.length;

        const newFileInput = fileInput.cloneNode();
        newFileInput.style.display = 'none';
        newFileInput.name = "detImages[]";

    const html =
        '<div class="added-item" id="det-item-' + itemIdx + '">' +
        '<span><strong></strong> (Đã chọn ảnh)</span>' +
        '<span><strong>' + title + ':</strong> ' + content + '</span>' +
        '<input type="hidden" name="detTitles[]" value="' + title + '">' +
        '<input type="hidden" name="detContents[]" value="' + content + '">' +
        '<button type="button" onclick="removeItem(\'det-item-' + itemIdx + '\')" class="btn-remove">Xóa</button>' +
        '</div>';

        const wrapper = document.createElement('div');
        wrapper.innerHTML = html;
        const itemDiv = wrapper.firstElementChild;
        itemDiv.appendChild(newFileInput);
        list.appendChild(itemDiv);

        fileInput.value = '';
        document.getElementById('detailTitle').value = '';
        document.getElementById('detailContent').value = '';
    }

    function removeItem(id) {
        document.getElementById(id).remove();
    }

    document.addEventListener("DOMContentLoaded", function() {
        fetchData('/WebGiaDung/api/brands', 'brandSelect', '-- Chọn nhãn hiệu --');
        fetchData('/WebGiaDung/api/keywords', 'tagSelect', '-- Chọn từ khóa --');
        fetchData('/WebGiaDung/api/categories', 'cateSelect', '-- Chọn danh mục --');
    });

    function fetchData(url, selectId, defaultText) {
        const selectElem = document.getElementById(selectId);

        fetch(url)
            .then(response => {
                if (!response.ok) throw new Error('HTTP error! status: ' + response.status);
                return response.json();
            })
            .then(data => {
                selectElem.innerHTML = '<option value="">' + defaultText + '</option>';

                data.forEach(item => {
                    let opt = document.createElement('option');
                    opt.value = item.id;
                    opt.textContent = item.name;
                    selectElem.appendChild(opt);
                });

                let addNewOpt = document.createElement('option');
                addNewOpt.value = "add-new";
                addNewOpt.textContent = "+ Thêm mới";
                selectElem.appendChild(addNewOpt);
            })
            .catch(error => {
                console.error('Lỗi:', error);
                selectElem.innerHTML = `<option value="">Lỗi tải dữ liệu (404/500)</option>`;
            });
    }

    let selectedProductFiles = [];

    async function saveFullProduct() {
        const form = document.getElementById('addProductFormInline');
        if (!form || !form.reportValidity()) return;

        const brandID = document.getElementById('brandSelect').value;
        const tagID = document.getElementById('tagSelect').value;
        const cateID = document.getElementById('cateSelect').value;

        if (!brandID || brandID === 'add-new' ||
            !tagID || tagID === 'add-new' ||
            !cateID || cateID === 'add-new') {
            alert("Vui lòng chọn Nhãn hiệu, Danh mục và Từ khóa hợp lệ!");
            return;
        }

        const formData = new FormData(form);

        selectedProductFiles.forEach(file => {
            formData.append('productImages[]', file);
        });

        const postCheckbox = document.getElementById('postStatus');
        const isPostValue = (postCheckbox && postCheckbox.checked) ? "1" : "0";
        formData.set('postStatus', isPostValue);

        formData.set('brandID', brandID);
        formData.set('tagID', tagID);
        formData.set('cateID', cateID);

        const editorContent = document.querySelector('#editor .ql-editor');
        if (editorContent) {
            formData.append('productFullDescription', editorContent.innerHTML);
        }

        console.log("Đang tiến hành lưu sản phẩm và dữ liệu liên quan...");

        try {
            const response = await fetch('/WebGiaDung/api/add-product', {
                method: 'POST',
                body: formData
            });

            const result = await response.json();
            if (result.status === "success") {
                alert("Lưu sản phẩm, mô tả và chi tiết thành công!");

                form.reset();
                selectedProductFiles = [];

                const mainImgList = document.getElementById('mainImageStatusList');
                if (mainImgList) mainImgList.innerHTML = "";

                const descList = document.getElementById('descriptionList');
                if (descList) descList.innerHTML = "";
                const detailList = document.getElementById('detailList');
                if (detailList) detailList.innerHTML = "";

                loadProducts(0);
            } else {
                alert("Lỗi từ server: " + result.message);
            }

        } catch (error) {
            console.error("Chi tiết lỗi:", error);
            alert("Lỗi hệ thống: " + error.message);
        }
    }


    function addMainImage() {
        const fileInput = document.getElementById('mainImgTemp');
        if (!fileInput || fileInput.files.length === 0) {
            alert("Vui lòng chọn một file ảnh trước!");
            return;
        }

        const file = fileInput.files[0];
        selectedProductFiles.push(file);

        const statusList = document.getElementById('mainImageStatusList');
        const itemIndex = selectedProductFiles.length - 1;

        const textLabel = (itemIndex === 0) ? '[Ảnh đại diện] ' : '[Ảnh phụ] ';

        const itemHtml = '<div class="added-item" id="img-item-' + itemIndex + '" style="display:flex; justify-content:space-between; margin-bottom:5px; background:#f4f4f4; padding:5px 10px; border-radius:4px;">' +
            '<span>' + textLabel + file.name + '</span>' +
            '<button type="button" style="color:red; border:none; background:none; cursor:pointer;" onclick="removeTempImage(' + itemIndex + ')">Xóa</button>' +
            '</div>';

        statusList.insertAdjacentHTML('beforeend', itemHtml);
        fileInput.value = "";
    }


    function removeTempImage(index) {
        selectedProductFiles.splice(index, 1);
        document.getElementById('mainImageStatusList').innerHTML = "";

        selectedProductFiles.forEach((file, idx) => {
            const statusList = document.getElementById('mainImageStatusList');
            const textLabel = (idx === 0) ? ' [Ảnh đại diện] ' : '[Ảnh phụ] ';

            const itemHtml = '<div class="added-item" id="img-item-' + idx + '" style="display:flex; justify-content:space-between; margin-bottom:5px; background:#f4f4f4; padding:5px 10px; border-radius:4px;">' +
                '<span>' + textLabel + file.name + '</span>' +
                '<button type="button" style="color:red; border:none; background:none; cursor:pointer;" onclick="removeTempImage(' + idx + ')">Xóa</button>' +
                '</div>';

            statusList.insertAdjacentHTML('beforeend', itemHtml);
        });
    }
</script>

<script>

    var contextPath = '${pageContext.request.contextPath}';

    document.addEventListener("DOMContentLoaded", function () {
        fetch('WebGiaDung/api/categories-list')
            .then(res => res.json())
            .then(data => renderCategoriesExact(data))
            .catch(err => console.error(err));

        loadProducts(0);

        const searchBtn = document.querySelector('.event-search__btn');
        const searchInput = document.querySelector('.event-search__input');

        if (searchBtn && searchInput) {
            searchBtn.addEventListener('click', function() {
                searchProducts(searchInput.value);
            });

            searchInput.addEventListener('keypress', function (e) {
                if (e.key === 'Enter') {
                    searchProducts(searchInput.value);
                }
            });
        }
    });

    function searchProducts(keyword) {
        console.log("Đang tìm kiếm:", keyword);
        fetch(contextPath + '/api/search-products?query=' + encodeURIComponent(keyword))
            .then(res => {
                if (!res.ok) return res.text().then(text => { throw new Error(text) });
                return res.json();
            })
            .then(data => {
                console.log("Dữ liệu search trả về:", data);
                renderProductTable(data);
            })
            .catch(err => console.error('Lỗi search:', err));
    }
    function loadProducts(cateId) {

        fetch(contextPath + '/api/products-by-category?cateId=' + cateId)
            .then(res => res.json())
            .then(data => {
                renderProductTable(data);
            })
            .catch(err => {
                console.error('Lỗi tải sản phẩm:', err);
            });
    }

    function renderProductTable(products) {
        var container = document.getElementById('product-list-container');
        if (!container) return;

        if (!products || products.length === 0) {
            container.innerHTML = '<p style="padding:20px; text-align:center;">Không có sản phẩm nào.</p>';
            return;
        }

        var html = '';

        products.forEach(function(p) {
            var formattedPrice = new Intl.NumberFormat('vi-VN').format(p.price) + ' đ';
            var imgUrl = contextPath + '/assets/img/products/' + p.image + '?v=' + new Date().getTime();

            var checkStatus = (p.post == 1) ? 'checked' : '';

            html += '<article class="product-table__row">';

            // Cột Ảnh
            html += '    <div class="product-table__cell">';
            html += '        <img src="' + imgUrl + '" alt="" class="product-table__img">';
            html += '    </div>';

            // Cột Tên
            html += '    <div class="product-table__cell">';
            html += '        <span class="product-table__text">' + p.name + '</span>';
            html += '    </div>';


            html += '    <div class="product-table__cell">';
            html += '        <input type="checkbox" class="product-table__checkbox" value="' + p.id + '" ' + checkStatus + '>';
            html += '    </div>';

            // Cột Giá
            html += '    <div class="product-table__cell">';
            html += '        <span class="product-table__text">' + formattedPrice + '</span>';
            html += '    </div>';


            html += '    <div class="product-table__cell">';
            html += '        <button class="product-table__view" onclick="viewProduct(' + p.id + ')">Xem</button>';
            html += '    </div>';

            html += '    <div class="product-table__cell">';
            html += '        <button class="product-table__edit" onclick="editProduct(' + p.id + ')">Sửa</button>';
            html += '    </div>';


            html += '    <div class="product-table__cell">';
            html += '        <button class="product-table__delete" onclick="deleteProduct(' + p.id + ')">Xóa</button>';
            html += '    </div>';

            html += '</article>';
        });

        container.innerHTML = html;
    }

    function renderCategoriesExact(list) {
        var container = document.getElementById('category-list');
        if (!container) return;

        var html = '';

        list.forEach(function(parent) {
            var hasChild = parent.children && parent.children.length > 0;

            // HTML CHO MENU CON
            var subHtml = '';
            if (hasChild) {
                subHtml += '<ul class="product-sub" style="display: none;">';
                parent.children.forEach(function(child) {
                    // QUAN TRỌNG: Sửa href thành javascript:void(0) và thêm onclick loadProducts
                    subHtml += '<li class="product-sub__item">';
                    subHtml +=    '<a href="javascript:void(0)" onclick="loadProducts(' + child.id + ')" class="product-sub__link">';
                    subHtml +=       child.name;
                    subHtml +=    '</a>';
                    subHtml += '</li>';
                });
                subHtml += '</ul>';
            }

            var parentOnClick = hasChild ? '' : 'onclick="loadProducts(' + parent.id + ')"';
            var parentHref = 'javascript:void(0)';

            html += '<li class="product-sidebar__item">';
            html +=    '<a href="' + parentHref + '" ' + parentOnClick + ' class="product-sidebar__link">';
            html +=       parent.name;
            html +=    '</a>';
            html +=    subHtml;
            html += '</li>';
        });

        container.innerHTML = html;
        initAccordion();
    }

    function initAccordion() {
        var links = document.querySelectorAll('.product-sidebar__item > .product-sidebar__link');
        links.forEach(function(link) {
            link.addEventListener('click', function(e) {
                var subMenu = this.nextElementSibling;
                if (subMenu && subMenu.classList.contains('product-sub')) {
                    e.preventDefault();
                    if (subMenu.style.display === 'none' || subMenu.style.display === '') {
                        subMenu.style.display = 'block';
                        this.parentElement.classList.add('product-sidebar__item--active');
                    } else {
                        subMenu.style.display = 'none';
                        this.parentElement.classList.remove('product-sidebar__item--active');
                    }
                }
            });
        });
    }


    function viewProduct(id) {
        console.log("Đang xem sản phẩm ID: " + id);

        if (typeof hideAllSections === 'function') {
            hideAllSections();
        }


        var sectionProductDetail = document.getElementById('viewProductModal');

        if (sectionProductDetail) {

            sectionProductDetail.style.display = "block";
            sectionProductDetail.style.position = "static";
            sectionProductDetail.style.backgroundColor = "transparent";
            sectionProductDetail.style.padding = "0";


            window.scrollTo({ top: 0, behavior: "smooth" });
        } else {
            console.error("Không tìm thấy div id='viewProductModal'");
            return;
        }

        fetch(contextPath + '/api/product-detail?id=' + id)
            .then(res => {
                if (!res.ok) throw new Error("Lỗi kết nối server");
                return res.json();
            })
            .then(data => {
                if (data.error) {
                    alert(data.error);

                    backToList();
                } else {

                    fillProductModal(data);
                }
            })
            .catch(err => {
                console.error(err);
                alert("Không thể tải thông tin sản phẩm.");
            });
    }


    function fillProductModal(p) {
        '${pageContext.request.contextPath}';

        var imgPath = contextPath + '/assets/img/products/' + p.image + '?v=' + new Date().getTime();

        var elImg = document.getElementById('v-image');
        if(elImg) elImg.src = imgPath;

        if(document.getElementById('v-createdAt')) document.getElementById('v-createdAt').innerText = p.createdAt || '---';
        if(document.getElementById('v-updatedAt')) document.getElementById('v-updatedAt').innerText = p.updatedAt || '---';
        if(document.getElementById('v-name')) document.getElementById('v-name').innerText = p.name;
        if(document.getElementById('v-brand')) document.getElementById('v-brand').innerText = p.brandName || '---';
        if (document.getElementById('v-tags')) {
            if (p.keywords && Array.isArray(p.keywords) && p.keywords.length > 0) {
                var keywordNames = p.keywords.map(function(k) {
                    return k.name;
                }).join(', ');

                document.getElementById('v-tags').innerText = keywordNames;
            } else {
                document.getElementById('v-tags').innerText = '---';
            }
        }

        if(document.getElementById('v-stock')) document.getElementById('v-stock').innerText = p.quantity;
        if(document.getElementById('v-sold')) document.getElementById('v-sold').innerText = p.quantitySaled;
        if(document.getElementById('v-isPost')) {
            document.getElementById('v-isPost').checked = (p.post == 1 || p.post === true || p.post === "true");
        }

        var priceFmt = { format: v => new Intl.NumberFormat('vi-VN').format(v) + ' đ' };
        if(document.getElementById('v-newPrice')) document.getElementById('v-newPrice').innerText = priceFmt.format(p.price);

        var boxOldPrice = document.getElementById('box-oldPrice');
        var boxDiscount = document.getElementById('box-discount');
        var oldPriceEl = document.getElementById('v-oldPrice');
        var discountEl = document.getElementById('v-discount');

        if (p.discountPercent > 0) {
            if(oldPriceEl) oldPriceEl.innerText = priceFmt.format(p.firstPrice);
            if(discountEl) discountEl.innerText = p.discountPercent;

            if(boxOldPrice) {
                boxOldPrice.style.display = 'block';
                boxOldPrice.style.marginBottom = '10px';
                boxOldPrice.style.lineHeight = '1.8';
            }
            if(boxDiscount) {
                boxDiscount.style.display = 'block';
                boxDiscount.style.marginBottom = '10px';
                boxDiscount.style.lineHeight = '1.8';
            }
        } else {
            if(boxOldPrice) boxOldPrice.style.display = 'none';
            if(boxDiscount) boxDiscount.style.display = 'none';
        }




        var descContainer = document.getElementById('v-descriptionList');
        if(descContainer) {
            descContainer.innerHTML = '';
            if (p.descriptions && p.descriptions.length > 0) {
                var htmlDesc = '';
                p.descriptions.forEach(function(d) {
                    htmlDesc += '<div class="view-text-item">';
                    htmlDesc +=     '<h5>' + d.title + '</h5>';
                    htmlDesc +=     '<p>' + d.description + '</p>';
                    htmlDesc += '</div>';
                });
                descContainer.innerHTML = htmlDesc;
            } else {
                descContainer.innerHTML = '<p style="color:#888; font-style:italic">Không có mô tả bổ sung.</p>';
            }
        }

        var detailContainer = document.getElementById('v-detailList');
        if(detailContainer) {
            detailContainer.innerHTML = '';
            if (p.details && p.details.length > 0) {
                var htmlDetail = '';
                p.details.forEach(function(dt) {
                    var dtImgSrc = dt.image ? (contextPath + '/assets/img/details/' + dt.image) : '';

                    var imgTag = dtImgSrc ? '<img src="' + dtImgSrc + '" alt="Detail">' : '';

                    htmlDetail += '<div class="view-detail-card">';
                    htmlDetail +=     imgTag;
                    htmlDetail +=     '<div class="view-detail-info">';
                    htmlDetail +=         '<h5>' + dt.title + '</h5>';
                    htmlDetail +=         '<p>' + dt.description + '</p>';
                    htmlDetail +=     '</div>';
                    htmlDetail += '</div>';
                });
                detailContainer.innerHTML = htmlDetail;
            } else {
                detailContainer.innerHTML = '<p style="color:#888; font-style:italic">Không có chi tiết sản phẩm.</p>';
            }
        }
    }
    var contextPath = '${pageContext.request.contextPath}';

    document.addEventListener("DOMContentLoaded", function () {

        fetch(contextPath + '/api/categories-list')
            .then(res => res.json())
            .then(data => renderCategoriesExact(data))
            .catch(err => console.error(err));

        loadProducts(0);

        document.getElementById('edit-oldPrice').addEventListener('input', calculateNewPrice);
        document.getElementById('edit-discount').addEventListener('input', calculateNewPrice);
    });


    document.addEventListener("DOMContentLoaded", function () {

        if(typeof loadProducts === "function") loadProducts(0);
        loadBrandOptions();
        loadKeywordOptions();
    });


    function editProduct(id) {
        console.log("Bắt đầu sửa sản phẩm ID: " + id);

        if (typeof hideAllSections === 'function') {
            hideAllSections();
        }


        var editPage = document.getElementById('editProductPage');
        if (editPage) {
            editPage.style.display = 'block';

            // Reset form
            document.getElementById('editProductForm').reset();
            document.getElementById('edit-v-image').src = contextPath + '/assets/img/no-image.png';
            document.getElementById('edit-v-descriptionList').innerHTML = '';
            document.getElementById('edit-v-detailList').innerHTML = '';

            window.scrollTo({ top: 0, behavior: "smooth" });
        } else {
            console.error("Không tìm thấy div id='editProductPage'");
            return;
        }


        fetch(contextPath + '/api/product-detail?id=' + id)
            .then(res => {
                if (!res.ok) throw new Error("Lỗi server " + res.status);
                return res.json();
            })
            .then(data => {
                if (data.error) {
                    alert("Server báo lỗi: " + data.error);
                } else {
                    fillEditForm(data);
                }
            })
            .catch(err => {
                console.error("Lỗi:", err);
                alert("Không thể tải thông tin: " + err.message);
            });
    }

    function fillEditForm(p) {
        console.log("Dữ liệu nhận được:", p);

        document.getElementById('edit-id').value = p.id || "";
        document.getElementById('edit-name').value = p.name || "";

        var createdSpan = document.getElementById('view-created-at');
        if (createdSpan) createdSpan.innerText = p.createdAt || "---";

        setSelectValue('edit-brand', p.brandId);
        if (p.keywords && Array.isArray(p.keywords) && p.keywords.length > 0) {
            setSelectValue('edit-tags', p.keywords[0].id);
        } else {
            setSelectValue('edit-tags', "");
        }

        document.getElementById('edit-oldPrice').value = p.firstPrice || 0;
        document.getElementById('edit-discount').value = p.discountPercent || 0;
        document.getElementById('edit-newPrice').value = p.price|| 0;

        document.getElementById('edit-stock').value = p.quantity || 0;
        document.getElementById('edit-sold').value = p.quantitySaled || 0;
        document.getElementById('edit-isPost').checked = (p.post === 1);

        var imgPath = p.image ? (contextPath + '/assets/img/products/' + p.image) : (contextPath + '/assets/img/no-image.png');
        document.getElementById('edit-v-image').src = imgPath;
        document.getElementById('edit-oldImageName').value = p.image || "";

        var descContainer = document.getElementById('edit-v-descriptionList');
        if(descContainer) {
            descContainer.innerHTML = "";
            if (p.descriptions && p.descriptions.length > 0) {
                p.descriptions.forEach(d => {

                    addDescriptionRow(d.id || 0, d.title, d.description);
                });
            }
        }

        var detailContainer = document.getElementById('edit-v-detailList');
        if(detailContainer) {
            detailContainer.innerHTML = "";
            if (p.details && p.details.length > 0) {
                p.details.forEach(dt => {

                    addDetailRow(dt.id || 0, dt.title, dt.description, dt.image);
                });
            }
        }
    }

    var isUpdating = false;

    function calculateNewPrice() {
        var oldPrice = parseFloat(document.getElementById('edit-oldPrice').value) || 0;
        var discount = parseFloat(document.getElementById('edit-discount').value) || 0;
        var newPrice = oldPrice - (oldPrice * discount / 100);
        document.getElementById('edit-newPrice').value = Math.round(newPrice);
    }

    function updateProduct() {
        var id = document.getElementById('edit-id').value;
        if (!id) { alert("Lỗi: Thiếu ID sản phẩm."); return; }
        if (isUpdating) return;

        var btnSave = document.querySelector("#editProductPage .btn-save");
        isUpdating = true;

        var formData = new FormData();
        formData.append("id", id);
        formData.append("name", getValue("edit-name"));

        formData.append("price_first", getValue("edit-oldPrice") || 0);
        formData.append("price_total", getValue("edit-newPrice") || 0);
        formData.append("quantity", getValue("edit-stock") || 0);

        formData.append("categories_id", getValue("edit-tags") || 0);
        formData.append("brands_id", getValue("edit-brand") || 0);

        var isPost = document.getElementById("edit-isPost").checked ? 1 : 0;
        formData.append("post", isPost);

        formData.append("old_image", getValue("edit-oldImageName"));
        var mainFileInput = document.getElementById("input-file-edit");
        if (mainFileInput.files.length > 0) {
            formData.append("image", mainFileInput.files[0]);
        }

        // Xử lý Description
        document.querySelectorAll("#edit-v-descriptionList .edit-item-box").forEach(function(item) {
            var dTitle = item.querySelector("input[name='descTitle']").value;
            if (dTitle && dTitle.trim() !== "") {
                formData.append("desc_id", item.querySelector("input[name='descId']").value || "0");
                formData.append("desc_title", dTitle);
                formData.append("desc_content", item.querySelector("textarea[name='descContent']").value);
            }
        });

        // Xử lý Detail
        document.querySelectorAll("#edit-v-detailList .edit-detail-card").forEach(function(item, index) {
            formData.append("detail_id", item.querySelector("input[name='detailId']").value || "0");
            formData.append("detail_title", item.querySelector("input[name='detailTitle']").value);
            formData.append("detail_desc", item.querySelector("textarea[name='detailContent']").value);
            formData.append("detail_old_image", item.querySelector("input[name='detailOldImage']").value);

            var fileInput = item.querySelector("input[name='detailImage']");
            var fileKey = "detail_image_" + index;
            if (fileInput.files.length > 0) {
                formData.append(fileKey, fileInput.files[0]);
            }
        });

        fetch(contextPath + '/admin/product-edit', {
            method: 'POST',
            body: formData
        })
            .then(response => {
                if (response.redirected) {
                    if(response.url.includes("success")) {
                        alert("Cập nhật thành công!");
                    } else {
                        alert("Có lỗi xảy ra (Redirect Error).");
                    }
                } else {

                    return response.text().then(text => {
                        console.error("Server Error Content:", text);
                        alert("Cập nhật thất bại! Vui lòng kiểm tra Console (F12) để xem chi tiết.");
                        isUpdating = false;
                        resetButton(btnSave);
                    });
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert("Lỗi kết nối server: " + error);
                isUpdating = false;
                resetButton(btnSave);
            });
    }

    function getValue(id) {
        var el = document.getElementById(id);
        return el ? el.value : "";
    }

    function resetButton(btn) {
        if (btn) {
            btn.innerText = "Lưu thay đổi";
            btn.disabled = false;
        }
    }
    function addDescriptionRow(id = 0, title = "", content = "") {
        var container = document.getElementById('edit-v-descriptionList');
        var div = document.createElement('div');
        div.className = 'edit-item-box';

       div.innerHTML =
           '<input type="hidden" name="descId" value="' + id + '">' +
           '<input type="text" class="form-input edit-sub-title" name="descTitle" placeholder="Tiêu đề">' +
           '<textarea class="form-textarea" name="descContent" rows="2" placeholder="Nội dung mô tả..."></textarea>' +
           '<button type="button" class="btn-remove-item" onclick="this.parentElement.remove()" style="color:red; margin-top:5px; cursor:pointer;">Xóa dòng này</button>';

        div.querySelector('input[name="descTitle"]').value = title;
        div.querySelector('textarea[name="descContent"]').value = content;

        container.appendChild(div);
    }

    function addDetailRow(id = 0, title = "", content = "", imageName = "") {
        var container = document.getElementById('edit-v-detailList');
        var imgSrc = imageName ? (contextPath + '/assets/img/details/' + imageName) : (contextPath + '/assets/img/no-image.png');

        var div = document.createElement('div');
        div.className = 'edit-detail-card';

        var html = '';
        // Thêm input hidden name="detailId"
        html += '<input type="hidden" name="detailId" value="' + id + '">';

        html += '<input type="hidden" name="detailOldImage" value="' + imageName + '">';
        html += '<div class="edit-card-img">';
        html += '    <img src="' + imgSrc + '" alt="Detail" class="detail-img-preview">';
        html += '    <label class="change-img-mini">';
        html += '        <i class="fa-solid fa-camera"></i>';
        html += '        <input type="file" name="detailImage" hidden onchange="previewDetailImage(this)">';
        html += '    </label>';
        html += '</div>';

        html += '<div class="view-detail-info">';
        html += '    <input type="text" class="form-input edit-sub-title" name="detailTitle" placeholder="Tiêu đề" value="' + (title || "") + '">';
        html += '    <textarea class="form-textarea" name="detailContent" rows="3" placeholder="Nội dung chi tiết...">' + (content || "") + '</textarea>';
        html += '</div>';

        html += '<button type="button" class="btn-remove-detail" onclick="this.parentElement.remove()" style="position: absolute; top: 5px; right: 5px; color: red; border: none; background: none; font-size: 20px;">&times;</button>';

        div.innerHTML = html;
        container.appendChild(div);
    }

    function previewDetailImage(input) {
        if (input.files && input.files[0]) {
            var reader = new FileReader();
            reader.onload = function(e) {
                var img = input.closest('.edit-card-img').querySelector('img');
                img.src = e.target.result;
            }
            reader.readAsDataURL(input.files[0]);
        }
    }

    // Preview ảnh chính
    function previewImage(input, imgId) {
        if (input.files && input.files[0]) {
            var reader = new FileReader();
            reader.onload = function(e) {
                document.getElementById(imgId).src = e.target.result;
            }
            reader.readAsDataURL(input.files[0]);
        }
    }

    // Tính giá mới
    function calculateNewPrice() {
        var oldPrice = parseFloat(document.getElementById('edit-oldPrice').value) || 0;
        var discount = parseInt(document.getElementById('edit-discount').value) || 0;
        var newPrice = oldPrice * (100 - discount) / 100;
        document.getElementById('edit-newPrice').value = Math.round(newPrice);
    }


    function setSelectValue(id, value) {
        var select = document.getElementById(id);
        if(select) select.value = value;
    }

    function closeEditModal() {
        const editPage = document.getElementById('editProductPage');
        if (editPage) editPage.style.display = 'none';

        const productMainSection = document.getElementById('product');
        if (productMainSection) {
            productMainSection.style.display = 'block';
        }

        const productListSub = document.getElementById('product-list-section');
        if (productListSub) {
            productListSub.style.display = 'block';
        }
        const productEventSub = document.getElementById('product-event-section');
        if (productEventSub) {
            productEventSub.style.display = 'none';
        }

        const sidebar = document.querySelector(".product-sidebar");
        if (sidebar) {
            sidebar.style.display = "block";
        }

        const menuButtons = document.querySelectorAll(".product-menu__btn");
        if (menuButtons.length > 0) {
            menuButtons.forEach(btn => {
                if (btn.getAttribute("data-target") === "product-list") {
                    btn.classList.add("active");
                } else {
                    btn.classList.remove("active");
                }
            });
        }

        window.scrollTo({ top: 0, behavior: "smooth" });
    }

    function loadBrandOptions() {
        fetch(contextPath + '/api/brands')
            .then(res => res.json())
            .then(data => {
                var select = document.getElementById('edit-brand');
                if (!select) return;
                var html = '<option value="">-- Chọn nhãn hiệu --</option>';
                data.forEach(item => {
                    html += '<option value="' + item.id + '">' + item.name + '</option>';
                });
                select.innerHTML = html;
            })
            .catch(err => console.error(err));
    }

    function loadKeywordOptions() {
        fetch(contextPath + '/api/keywords')
            .then(res => res.json())
            .then(data => {
                var select = document.getElementById('edit-tags');
                if (!select) return;
                var html = '<option value="">-- Chọn từ khóa --</option>';
                data.forEach(item => {
                    html += '<option value="' + item.id + '">' + item.name + '</option>';
                });
                select.innerHTML = html;
            })
            .catch(err => console.error(err));
    }
    function deleteProduct(id) {
        if(confirm('Bạn có chắc muốn xóa sản phẩm này? Hành động này không thể hoàn tác.')) {


            fetch(contextPath + '/admin/product-delete', {
                method: 'POST',
                headers: {

                    'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
                },

                body: 'id=' + id
            })
                .then(response => response.json())
                .then(data => {
                    if (data.status === 'success') {
                        alert("Đã xóa sản phẩm thành công!");
                        loadProducts(0);
                    } else {
                        alert("Lỗi: " + data.message);
                    }
                })
                .catch(err => {
                    console.error('Lỗi mạng:', err);
                    alert("Không thể kết nối đến server.");
                });
        }
    }
</script>
<script>
    document.addEventListener("DOMContentLoaded", function() {
        loadCategories();
        setupFormSubmit();
        setupScopeToggle();
    });

    async function loadCategories() {
        try {
            const response = await fetch(window.location.origin + '/WebGiaDung/api/categories');
            const data = await response.json();
            const select = document.querySelector('select[name="applyCategories"]');
            if (select) {
                select.innerHTML = '<option value="0">-- Chọn một danh mục --</option>';
                data.forEach(cat => {
                    select.add(new Option(cat.name, cat.id));
                });
            }
        } catch (err) { console.error("Lỗi load categories:", err); }
    }

    function setupScopeToggle() {
        const radios = document.querySelectorAll('input[name="applyScope"]');
        const scopeBox = document.getElementById('scopeCategory');

        radios.forEach(radio => {
            radio.addEventListener('change', (e) => {
                if (e.target.value === 'category') {
                    scopeBox.style.display = 'block';
                } else {
                    scopeBox.style.display = 'none';

                    const select = document.querySelector('select[name="applyCategories"]');
                    if (select) select.value = "0";
                }
            });
        });
    }

    function setupFormSubmit() {
        const form = document.getElementById('addEventForm');
        if (!form) return;

        form.addEventListener('submit', async function(e) {
            e.preventDefault();
            e.stopImmediatePropagation();

            const contextPath = window.location.pathname.substring(0, window.location.pathname.indexOf("/", 1));
            const url = contextPath + '/admin/add-discount';

            const formData = new FormData(this);

            if (formData.get('applyScope') === 'all') {
                formData.set('applyCategories', '0');
            }

            const saveBtn = document.querySelector('.event-btn--save');
            const originalText = saveBtn.innerHTML;
            saveBtn.disabled = true;
            saveBtn.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i> Đang xử lý...';

            try {
                const response = await fetch(url, {
                    method: 'POST',
                    body: formData
                });

                const responseText = await response.text();
                let result;
                try {
                    result = JSON.parse(responseText);
                } catch (e) {
                    console.error("Server trả về lỗi không phải JSON:", responseText);
                    throw new Error("Server bị lỗi nội bộ (500). Kiểm tra Console Java!");
                }

                if (result.status === "success") {
                    alert("Lưu sự kiện thành công!");
                    location.reload();
                } else {
                    alert(" Lỗi: " + result.message);
                }
            } catch (error) {
                console.error("Chi tiết lỗi:", error);
                alert(error.message);
            } finally {
                saveBtn.disabled = false;
                saveBtn.innerHTML = originalText;
            }
        });
    }
    function setupDiscountUnitChange() {
        const discountTypeSelect = document.getElementById('discountType');
        const discountUnitSpan = document.getElementById('discountUnit');

        if (discountTypeSelect && discountUnitSpan) {
            discountTypeSelect.addEventListener('change', function() {
                if (this.value === 'percentage') {
                    discountUnitSpan.textContent = '%';
                } else if (this.value === 'amount') {
                    discountUnitSpan.textContent = 'đ';
                }
            });
        }
    }

    document.addEventListener('DOMContentLoaded', function() {
        setupFormSubmit();
        setupDiscountUnitChange();
    });
</script>
<script>
    document.addEventListener("DOMContentLoaded", function() {
        document.querySelectorAll('input[name="applyScope"]').forEach(radio => {
            radio.addEventListener('change', function() {
                const scopeCategory = document.getElementById('scopeCategory');
                if (this.value === 'category') {
                    scopeCategory.style.display = 'block';
                    loadCategories();
                } else {
                    scopeCategory.style.display = 'none';
                }
            });
        });
    });
</script>
<script>
    // Phải khai báo contextPath từ JSP
    var contextPath = '${pageContext.request.contextPath}';

    document.addEventListener("DOMContentLoaded", function () {
        loadAllDiscounts();
    });

    function loadAllDiscounts() {
        fetch(contextPath + '/api/admin/discounts-list')
            .then(res => {
                if (!res.ok) throw new Error("Lỗi Server");
                return res.json();
            })
            .then(data => {
                renderDiscountTable(data);
            })
            .catch(err => console.error("Không tải được giảm giá:", err));
    }

    function renderDiscountTable(discounts) {
        var container = document.getElementById('discount-list-container');
        if (!container) return;

        var html = '<div class="event-table__row event-table__row--header">';
        html += '    <div class="event-table__cell event-col-name">Tên sự kiện</div>';
        html += '    <div class="event-table__cell event-col-discount">Giảm giá</div>';
        html += '    <div class="event-table__cell event-col-post">Post</div>';
        html += '    <div class="event-table__cell event-col-date">Ngày bắt đầu</div>';
        html += '    <div class="event-table__cell event-col-date">Ngày kết thúc</div>';
        html += '    <div class="event-table__cell event-col-action">Xem</div>';
        html += '    <div class="event-table__cell event-col-action">Sửa</div>';
        html += '    <div class="event-table__cell event-col-action">Xóa</div>';
        html += '</div>';

        if (discounts && discounts.length > 0) {
            discounts.forEach(function (d) {
                var discountDisplay = d.discount + "%";

                html += '<article class="event-table__row">';
                html += '    <div class="event-table__cell event-col-name">';
                html += '        <span class="event-table__text event-table__text--bold">' + d.name + '</span>';
                html += '    </div>';
                html += '    <div class="event-table__cell event-col-discount">';
                html += '        <span class="event-table__text event-table__text--red">' + discountDisplay + '</span>';
                html += '    </div>';
                html += '    <div class="event-table__cell event-col-post"><input type="checkbox" ' + (d.status == 1 ? "checked" : "") + '></div>';
                html += '    <div class="event-table__cell event-col-date">';
                html += '        <span class="event-table__text">' + d.startDate + '</span>';
                html += '    </div>';
                html += '    <div class="event-table__cell event-col-date">';
                html += '        <span class="event-table__text">' + d.endDate + '</span>';
                html += '    </div>';

                html += '    <div class="event-table__cell event-col-action">';
                html += '        <button class="event-btn-view" onclick="viewDiscount(' + d.id + ')">Xem</button>';
                html += '    </div>';
                html += '    <div class="event-table__cell event-col-action">';
                html += '        <button class="event-btn-edit" onclick="editDiscount(' + d.id + ')">Sửa</button>';
                html += '    </div>';
                html += '    <div class="event-table__cell event-col-action">';
                html += '        <button class="event-btn-delete" onclick="deleteDiscount(' + d.id + ')">Xóa</button>';
                html += '    </div>';
                html += '</article>';
            });
        } else {
            html += '<p style="padding: 20px; text-align: center;">Không có dữ liệu giảm giá nào.</p>';
        }

        container.innerHTML = html;
    }
</script>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
    $(document).ready(function() {

        $(document).on('submit', '#searchOrderForm', function(e) {
            e.preventDefault();
            $.ajax({
                url: $(this).attr('action'),
                type: 'GET',
                data: $(this).serialize(),
                headers: { "X-Requested-With": "XMLHttpRequest" },
                success: function(data) {
                    $('#order-main-content').html(data);
                }
            });
        });

        // 2. CHỌN TẤT CẢ CHECKBOX
        $(document).on('change', '#selectAll', function() {
            $('.order-table__checkbox').prop('checked', this.checked);
        });

        // 3. AJAX XÓA NHIỀU (Sửa lại logic click nút thay vì submit form)
        $(document).on('click', '#btnDeleteAll', function() {
            let selectedIds = [];
            $('input[name="orderIds"]:checked').each(function() {
                selectedIds.push($(this).val());
            });

            if (selectedIds.length === 0) {
                alert("Vui lòng chọn ít nhất một đơn hàng!");
                return;
            }

            if (confirm('Bạn có chắc chắn muốn xóa các mục đã chọn?')) {
                $.ajax({
                    url: '${pageContext.request.contextPath}/order-delete',
                    type: 'POST',
                    data: { orderIds: selectedIds }, // Gửi mảng ID
                    traditional: true, // Quan trọng để gửi mảng qua AJAX cho Java nhận diện
                    headers: { "X-Requested-With": "XMLHttpRequest" },
                    success: function(response) {
                        $('#order-main-content').html(response);
                        alert("Đã xóa thành công!");
                    }
                });
            }
        });

    });

    $(document).on('click', '#btnReloadAll', function() {

        $('input[name="keyword"]').val('');

        $.ajax({
            url: '${pageContext.request.contextPath}/order-search',
            type: 'GET',
            data: { keyword: '' },
            headers: { "X-Requested-With": "XMLHttpRequest" },
            success: function(data) {
                $('#order-main-content').html(data);
            }
        });
    });
</script>
<script>

    // --- HÀM XEM (GIỮ NGUYÊN) ---
    function viewDiscount(id) {
        fetch(contextPath + '/api/admin/discount-detail?id=' + id)
            .then(res => res.json())
            .then(d => {
                if (d.status === "error") throw new Error(d.message);
                document.getElementById('view-eventName').textContent = d.name;
                document.getElementById('view-descrip').textContent = d.description || "Không có mô tả";
                document.getElementById('view-startDate').textContent = d.startDate;
                document.getElementById('view-endDate').textContent = d.endDate;
                document.getElementById('view-categoryName').textContent = d.categoryName;

                const isPercent = (d.typeDiscount === "percentage" || d.typeDiscount == 1);
                document.getElementById('view-discountType').textContent = isPercent ? "Phần trăm (%)" : "Tiền mặt (đ)";
                document.getElementById('view-discountValue').textContent = d.discount + (isPercent ? "%" : " đ");

                if (typeof hideAllSections === "function") hideAllSections();
                const viewPage = document.getElementById('view-event-page');
                if (viewPage) {
                    viewPage.style.display = 'block';
                    window.scrollTo(0, 0);
                }
            })
            .catch(err => alert("Lỗi tải: " + err.message));
    }

    // --- HÀM SỬA (FIX DẤU NGOẶC + DATE) ---
    async function editDiscount(id) {
        try {
            const res = await fetch(contextPath + '/api/admin/discount-detail?id=' + id);
            const d = await res.json();
            if (d.status === "error") throw new Error(d.message);

            hideAllSections();
            document.getElementById('edit-event-page').style.display = 'block';

            if (document.getElementById('edit-currentCategoryName')) {
                document.getElementById('edit-currentCategoryName').textContent = d.categoryName;
            }

            document.getElementById('edit-eventName').value = d.name;
            document.getElementById('edit-discountType').value = d.typeDiscount == 1 ? "percentage" : "amount";
            document.getElementById('edit-discountValue').value = d.discount;
            document.getElementById('edit-eventDesc').value = d.description || "";
            document.getElementById('editEventForm').dataset.currentId = id;

            // Chuyển dd/MM/yyyy (từ Controller) sang yyyy-MM-dd (cho input date)
            const formatDateForInput = (dateStr) => {
                if (!dateStr || !dateStr.includes('/')) return "";
                const parts = dateStr.split('/');
                if(parts.length !== 3) return "";
                return parts[2] + '-' + parts[1].padStart(2, '0') + '-' + parts[0].padStart(2, '0');
            };

            document.getElementById('edit-startDate').value = formatDateForInput(d.startDate);
            document.getElementById('edit-endDate').value = formatDateForInput(d.endDate);

            await loadEditCategories();

            const idCate = d.id_cate || 0;
            const scopeBox = document.getElementById('editScopeCategory');
            if (idCate > 0) {
                const rb = document.querySelector('input[name="editApplyScope"][value="category"]');
                if(rb) rb.checked = true;
                if(scopeBox) scopeBox.style.display = 'block';
                document.getElementById('editApplyCategories').value = idCate;
            } else {
                const rbAll = document.querySelector('input[name="editApplyScope"][value="all"]');
                if(rbAll) rbAll.checked = true;
                if(scopeBox) scopeBox.style.display = 'none';
            }
        } catch (err) {
            alert("Lỗi: " + err.message);
        }
    }
    async function loadEditCategories() {
        try {
            const response = await fetch(window.location.origin + '/WebGiaDung/api/categories');
            const data = await response.json();
            const select = document.getElementById('editApplyCategories');
            if (select) {
                select.innerHTML = '<option value="">-- Chọn một danh mục --</option>';
                data.forEach(cat => select.add(new Option(cat.name, cat.id)));
            }
        } catch (err) { console.error(err); }
    }

    async function saveDiscountUpdate() {
        const form = document.getElementById('editEventForm');
        const discountId = form.dataset.currentId;

        const sDate = document.getElementById('edit-startDate').value;
        const eDate = document.getElementById('edit-endDate').value;

        if (!sDate || !eDate) {
            alert("Vui lòng không để trống ngày tháng!");
            return;
        }

        const payload = {
            id: parseInt(discountId),
            name: document.getElementById('edit-eventName').value,
            type: document.getElementById('edit-discountType').value,
            value: parseFloat(document.getElementById('edit-discountValue').value),
            startDate: sDate,
            endDate: eDate,
            description: document.getElementById('edit-eventDesc').value,
            scope: document.querySelector('input[name="editApplyScope"]:checked').value,
            categoryId: document.getElementById('editApplyCategories').value
        };

        try {
            const response = await fetch(contextPath + '/api/admin/update-discount', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(payload)
            });

            const result = await response.json();
            if (result.success) {
                alert("Cập nhật thành công!");
                backToEventList();
                if (typeof loadDiscountList === 'function') loadDiscountList();
            } else {
                alert("Cập nhật thất bại: " + result.message);
            }
        } catch (err) {
            alert("Lỗi kết nối Server.");
        }
    }

    // Event Radios
    document.querySelectorAll('input[name="editApplyScope"]').forEach(radio => {
        radio.addEventListener('change', (e) => {
            const box = document.getElementById('editScopeCategory');
            if (box) box.style.display = (e.target.value === 'category') ? 'block' : 'none';
        });
    });
</script>
<script>

    let selectedProductId = null;
    let searchTimeout = null;

    // rút gọn tên sp
    function truncateName(name) {
        if (!name) return "";
        var words = name.split(/\s+/);
        return words.length > 5 ? words.slice(0, 5).join(' ') + '...' : name;
    }

    // Tạo mã phiếu tự động
    function generateReceiptCode() {
        const now = new Date();
        const year = now.getFullYear();
        const month = String(now.getMonth() + 1).padStart(2, '0');
        const day = String(now.getDate()).padStart(2, '0');
        const hours = String(now.getHours()).padStart(2, '0');
        const minutes = String(now.getMinutes()).padStart(2, '0');
        const seconds = String(now.getSeconds()).padStart(2, '0');

        const code = 'PN-' + year + month + day + '-' + hours + minutes + seconds;

        const receiptInput = document.getElementById('receipt-code');
        if (receiptInput) {
            receiptInput.value = code;
        }
    }

    // hàm tinh tổng tiền nhập hàng
    function calculateTotalPrice() {
        const qtyEl = document.getElementById('import-qty');
        const costEl = document.getElementById('unit-cost');
        const displayEl = document.getElementById('total-price-display');

        if (qtyEl && costEl && displayEl) {
            const qty = parseFloat(qtyEl.value) || 0;
            const unitCost = parseFloat(costEl.value) || 0;
            const total = qty * unitCost;

            displayEl.value = total.toLocaleString('vi-VN');
        }
    }

    // chọn sản phẩm để nhập hàng
    function onSelectProduct(id, name, stock, imgUrl, price) {
        selectedProductId = id;

        document.getElementById('display-name').innerText = name;
        document.getElementById('display-pre-stock').innerText = stock;
        document.getElementById('display-img').src = imgUrl;
        document.getElementById('unit-cost').value = price;

        document.getElementById('import-qty').value = "";
        calculateTotalPrice();

        var dropdown = document.getElementById('search-dropdown');
        if(dropdown) dropdown.style.display = 'none';

        var searchInput = document.getElementById('search-prod');
        if(searchInput) searchInput.value = name;

        document.getElementById('import-qty').focus();

        console.log("Đã chọn SP ID:", id);
    }

    // load danh sách sp sap hết hàng
    function loadLowStockProducts() {
        var container = document.getElementById('low-stock-list');
        var contextPath = '${pageContext.request.contextPath}';

        fetch(contextPath + '/api/low-stock-products')
            .then(res => res.json())
            .then(data => {
                container.innerHTML = '';
                if (!data || data.length === 0) {
                    container.innerHTML = '<p style="text-align:center; font-size:13px; color:#888;">Kho hiện tại đủ hàng.</p>';
                    return;
                }

                data.forEach(p => {
                    var displayImg = contextPath + '/assets/img/products/' + p.image;
                    var safeName = p.name.replace(/'/g, "\\'");


                    var card = '<div class="stock-card ' + (p.quantity <= 0 ? 'danger' : 'warning') + '">' +
                        '<div class="img-wrapper">' +
                        '<img src="' + displayImg + '" alt="product">' +
                        '</div>' +
                        '<div class="stock-info">' +
                        '<h4 class="product-name-mini">' + p.name + '</h4>' +
                        '<p class="stock-qty-mini">Tồn kho: <strong style="color: #ffc107;">' + p.quantity + '</strong></p>'  +
                        '</div>' +
                        '<button class="btn-add-mini" onclick="onSelectProduct(' + p.id + ', \'' + safeName + '\', ' + p.quantity + ', \'' + displayImg + '\', ' + p.firstPrice + ')">Nhập</button>' +
                        '</div>';
                    container.insertAdjacentHTML('beforeend', card);
                });
            })
            .catch(err => console.error('Lỗi loadLowStock:', err));
    }

    function handleProductSearch(query) {
        var dropdown = document.getElementById('search-dropdown');
        var contextPath = '${pageContext.request.contextPath}';

        if (query.trim().length === 0) {
            dropdown.style.display = 'none';
            return;
        }

        clearTimeout(searchTimeout);
        searchTimeout = setTimeout(function() {
            fetch(contextPath + '/api/search-products?query=' + encodeURIComponent(query.trim()))
                .then(res => res.json())
                .then(data => {
                    dropdown.innerHTML = '';
                    if (data && data.length > 0) {
                        dropdown.style.display = 'block';
                        data.forEach(function(p) {
                            var displayImg = contextPath + '/assets/img/products/' + p.image;
                            var safeName = p.name.replace(/'/g, "\\'");

                            // Nối chuỗi bằng dấu + tránh xung đột JSP
                            var itemHtml = '<div class="search-item" style="display: flex; align-items: center; padding: 10px; cursor: pointer; border-bottom: 1px solid #eee;" ' +
                                'onclick="onSelectProduct(' + p.id + ', \'' + safeName + '\', ' + p.quantity + ', \'' + displayImg + '\', ' + p.firstPrice + ')">' +
                                '<img src="' + displayImg + '" style="width: 45px; height: 45px; object-fit: cover; border-radius: 4px; margin-right: 12px;" alt="img">' +
                                '<div style="flex-grow: 1;">' +
                                '<div style="font-weight: bold; font-size: 14px; color: #333; margin-bottom: 4px;">' + p.name + '</div>' +
                                '<div style="font-size: 12px; color: #666;">Tồn: <strong style="color: #d9534f;">' + p.quantity + '</strong></div>' +
                                '</div>' +
                                '</div>';

                            dropdown.insertAdjacentHTML('beforeend', itemHtml);
                        });
                    } else {
                        dropdown.innerHTML = '<div style="padding:15px; text-align:center; color:#888;">Không thấy sản phẩm!</div>';
                        dropdown.style.display = 'block';
                    }
                })
                .catch(err => console.error("Lỗi tìm kiếm: ", err));
        }, 300);
    }


    document.addEventListener('DOMContentLoaded', function() {
        loadLowStockProducts();
        generateReceiptCode();
    });

    document.addEventListener('click', function(event) {
        var searchWrapper = document.querySelector('.search-input-wrapper');
        var dropdown = document.getElementById('search-dropdown');
        if (searchWrapper && !searchWrapper.contains(event.target)) {
            if(dropdown) dropdown.style.display = 'none';
        }
    });

   // gửi dữ liệu lưu phiếu nhập kho
    const btnConfirm = document.querySelector('.btn-confirm-warehouse');
    if (btnConfirm) {
        btnConfirm.addEventListener('click', function() {
            const receiptCode = document.getElementById('receipt-code').value.trim();
            const supplierName = document.getElementById('supplier-name').value;
            const importQty = parseInt(document.getElementById('import-qty').value) || 0;
            const unitCost = parseFloat(document.getElementById('unit-cost').value) || 0;
            const preStockQty = parseInt(document.getElementById('display-pre-stock').innerText) || 0;

            if (!receiptCode) {
                alert("Vui lòng nhập mã phiếu!");
                document.getElementById('receipt-code').focus();
                return;
            }

            if (!selectedProductId) {
                alert("Vui lòng chọn sản phẩm trước khi xác nhận!");
                return;
            }

            if (importQty <= 0 || unitCost <= 0) {
                alert("Vui lòng nhập số lượng và đơn giá hợp lệ!");
                return;
            }

            const data = {
                receiptCode: receiptCode,
                supplierName: supplierName,
                productId: selectedProductId,
                preStockQty: preStockQty,
                importQty: importQty,
                unitCost: unitCost,
                totalPrice: importQty * unitCost
            };

            fetch('${pageContext.request.contextPath}/api/admin/warehouse/import', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(data)
            })
                .then(res => res.json())
                .then(result => {
                    if (result.success) {
                        alert("Nhập kho thành công!");
                        location.reload();
                    } else {
                        alert("Lỗi: " + result.message);
                    }
                })
                .catch(err => {
                    console.error("Fetch Error:", err);
                    alert("Lỗi kết nối server!");
                });
        });
    }
</script>
<script>

    var APP_PATH = '<%= request.getContextPath() %>';

    document.addEventListener("DOMContentLoaded", function() {
        // Chỉ chạy load dữ liệu nếu đang ở đúng trang có bảng này
        if (document.getElementById('inbound-table-body')) {
            loadInboundHistory();
        }
    });

    // Hàm định dạng tiền tệ
    function formatVND(amount) {
        return new Intl.NumberFormat('vi-VN').format(amount || 0) + ' đ';
    }

    // Hàm định dạng ngày tháng: 2026-04-20T19:49:04 -> 20/04/2026 19:49
    function formatTime(isoString) {
        if (!isoString) return "N/A";
        try {
            var parts = isoString.split('T');
            var dateParts = parts[0].split('-');
            var timePart = parts[1] ? parts[1].substring(0, 5) : "";
            return dateParts[2] + '/' + dateParts[1] + '/' + dateParts[0] + ' ' + timePart;
        } catch (e) { return isoString; }
    }

    function loadInboundHistory() {
        var apiUrl = APP_PATH + '/api/admin/warehouse/history';
        var tbody = document.getElementById('inbound-table-body');

        fetch(apiUrl)
            .then(function(res) { return res.json(); })
            .then(function(data) {
                tbody.innerHTML = '';
                if (!data || data.length === 0) {
                    tbody.innerHTML = '<tr><td colspan="7" style="text-align:center; padding:20px;">Chưa có dữ liệu.</td></tr>';
                    return;
                }

                data.forEach(function(item, index) {
                    var preStock = parseInt(item.preStockQty) || 0;
                    var importQty = parseInt(item.importQty) || 0;
                    var totalAfter = preStock + importQty;

                    // Tạo row
                    var tr = document.createElement('tr');
                    tr.innerHTML =
                        '<td>' + formatTime(item.createdAt) + '</td>' +
                        '<td><strong>' + item.receiptCode + '</strong></td>' +
                        '<td style="text-align: left;">' + item.productName + '</td>' +
                        '<td>' + importQty + '</td>' +
                        '<td style="color:#d9534f; font-weight:bold;">' + formatVND(item.totalPrice) + '</td>' +
                        '<td><b style="color:#007bff;">' + totalAfter + '</b></td>' +
                        '<td><button class="btn-detail" id="btn-view-' + index + '">Xem chi tiết</button></td>';

                    tbody.appendChild(tr);


                    document.getElementById('btn-view-' + index).addEventListener('click', function() {
                        showInboundDetail(item);
                    });
                });
            })
            .catch(function(err) {
                console.error("Lỗi:", err);
                tbody.innerHTML = '<tr><td colspan="7" style="color:red; text-align:center;">Không thể tải dữ liệu API.</td></tr>';
            });
    }

    function showInboundDetail(item) {
        // Đổ dữ liệu vào Modal
        document.getElementById('modal-code').innerText = item.receiptCode;
        document.getElementById('modal-name').innerText = item.productName;
        document.getElementById('modal-supplier').innerText = item.supplierName || "N/A";
        document.getElementById('modal-date').innerText = formatTime(item.createdAt);
        document.getElementById('modal-pre-stock').innerText = item.preStockQty;
        document.getElementById('modal-qty').innerText = item.importQty;
        document.getElementById('modal-unit-cost').innerText = formatVND(item.unitCost);
        document.getElementById('modal-total').innerText = formatVND(item.totalPrice);

        // Xử lý ảnh
        var imgName = (item.productImage && item.productImage !== 'null') ? item.productImage : 'default.png';
        document.getElementById('modal-img').src = APP_PATH + '/assets/img/products/' + imgName;

        // Hiện modal
        var modal = document.getElementById('inbound-detail-modal');
        modal.style.display = 'flex';
    }

    function closeInboundModal() {
        document.getElementById('inbound-detail-modal').style.display = 'none';
    }

    // Đóng khi click ngoài
    window.onclick = function(event) {
        var modal = document.getElementById('inbound-detail-modal');
        if (event.target === modal) {
            closeInboundModal();
        }
    };
</script>

<script>
    function switchSubTab(event, tabId) {

        const tabItems = document.querySelectorAll('.sub-tab-item');
        tabItems.forEach(item => {
            item.classList.remove('active');
        });


        const tabContents = document.querySelectorAll('.sub-tab-content');
        tabContents.forEach(content => {
            content.classList.remove('active');
            content.style.display = 'none';
        });

        event.currentTarget.classList.add('active');

        const activeContent = document.getElementById(tabId);
        if (activeContent) {
            activeContent.classList.add('active');
            activeContent.style.display = 'block';
        }
    }
</script>

<script>
    document.addEventListener("DOMContentLoaded", function() {
        const startDateInput = document.querySelector('input[name="startDate"]');
        const endDateInput = document.querySelector('input[name="endDate"]');

        const getLocalToday = () => {
            const now = new Date();
            const offset = now.getTimezoneOffset() * 60000;
            return new Date(now - offset).toISOString().split('T')[0];
        };

        const today = getLocalToday();


        startDateInput.setAttribute('min', today);
        endDateInput.setAttribute('min', today);


        startDateInput.addEventListener('change', function() {
            const startVal = this.value;

            endDateInput.setAttribute('min', startVal);

            if (endDateInput.value && startVal > endDateInput.value) {
                alert("Lỗi: Ngày bắt đầu không được sau ngày kết thúc!");
                this.value = ""; // Xóa giá trị sai
            }
        });

        endDateInput.addEventListener('change', function() {
            const startVal = startDateInput.value;
            const endVal = this.value;

            if (startVal && endVal < startVal) {
                alert("Lỗi: Ngày kết thúc không được trước ngày bắt đầu!");
                this.value = "";
            }
        });
    });
</script>

<script>
    function toggleRvPanel(headEl) {
        var panel = headEl.closest('.rv-panel');
        panel.classList.toggle('is-open');
    }
</script>

<script>
    window.contextPath = "${pageContext.request.contextPath}";
    const PURE_CONTEXT_PATH = "${pageContext.request.contextPath}";
</script>
<script src="${pageContext.request.contextPath}/assets/js/script.js"></script>

<script>
    // add slide

    document.addEventListener("DOMContentLoaded", function () {
        if (document.getElementById("slideTableContainer")) {
            loadSlideTable();
        }

        const addSlideForm = document.getElementById("addSlideForm"); // form điền
        const sectionSlideAdd = document.getElementById("add-slide"); // section chứa nút thêm slide
        const sectionNewsSlideList = document.getElementById("news-slide"); // vùng chứa list slide

        if(addSlideForm) {
            addSlideForm.addEventListener("submit", function (e) {
               e.preventDefault();
               // bắt buộc dùng FD khi gửi dữ liệu có chứa file ảnh qua API
               const formData = new FormData(addSlideForm);
               const btnSave = addSlideForm.closest(".manage-detail")?.querySelector(".slide-table__save") ||
                   addSlideForm.querySelector("button[type='submit']");
               let oldBtnHtml = "";
               if (btnSave) {
                   oldBtnHtml = btnSave.innerHTML;
                   btnSave.disabled = true;
                   btnSave.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i> Đang lưu...';
               }

               fetch(PURE_CONTEXT_PATH + "/api/add-slide", {
                   method: "POST",
                   body: formData // truyền trực tiếp đt FD
               })
                   .then(function (response) {
                   if(!response.ok) {
                       throw new Error("Lỗi mạng hoặc lỗi server: " + response.status);
                   }
                   return response.json();
                })
                   .then(function (data) {
                   if(btnSave) {
                       btnSave.disabled = false;
                       btnSave.innerHTML = oldBtnHtml;
                   }
                   if(data.status === "success") {
                       alert("Thêm slide mới thành công!");

                       addSlideForm.reset();

                       if(sectionSlideAdd) sectionSlideAdd.style.display = "none";
                       if(sectionNewsSlideList) sectionNewsSlideList.style.display = "block";

                       const newsMenu = document.querySelector(".news-menu");
                       if (newsMenu) newsMenu.style.display = "flex";

                       loadSlideTable();
                       window.scrollTo({top: 0, behavior: "smooth"});
                   } else {
                       alert("Thất bại: " + (data.message || "Không thể lưu side."));
                   }
                })
                    .catch(function (error) {
                        // Khôi phục lại trạng thái nút nếu xảy ra lỗi
                        if (btnSave) {
                            btnSave.disabled = false;
                            btnSave.innerHTML = oldBtnHtml;
                        }
                        console.error("Lỗi AJAX thêm slide:", error);
                        alert("Đã xảy ra lỗi hệ thống khi gửi dữ liệu!");
                    });
            });
        }
});

    function loadSlideTable() {
        var container = document.getElementById("slideTableContainer");
        if (!container) return;

        fetch(PURE_CONTEXT_PATH + "/api/admin/manage-slide")
            .then(function(response) {
                if (!response.ok) {
                    throw new Error("Lỗi kết nối API: " + response.status);
                }
                return response.json();
            })
            .then(function(data) {
                var headerRow = container.querySelector(".news-table__row--header");
                container.innerHTML = "";
                if (headerRow) container.appendChild(headerRow);

                if (!data || data.length === 0) {
                    var emptyRow = document.createElement("div");
                    emptyRow.className = "news-table__row";
                    emptyRow.style.cssText = "text-align: center; justify-content: center; padding: 20px; color: #666;";
                    emptyRow.textContent = "Hiện tại chưa có slide nào trong hệ thống.";
                    container.appendChild(emptyRow);
                    return;
                }

                data.forEach(function(slide) {
                    var row = document.createElement("article");
                    row.className = "news-table__row";


                    var cellImg = document.createElement("div");
                    cellImg.className = "news-table__cell";
                    var img = document.createElement("img");

                    var bannerPath = slide.banner;
                    if(bannerPath && !bannerPath.startsWith("http") && !bannerPath.startsWith("/")) {
                        img.src = PURE_CONTEXT_PATH + "/" + bannerPath;
                    } else {
                        img.src = bannerPath;
                    }
                    img.className = "news-table__img";
                    cellImg.appendChild(img);
                    row.appendChild(cellImg);


                    var cellTitle = document.createElement("div");
                    cellTitle.className = "news-table__cell";
                    cellTitle.textContent = slide.title;
                    row.appendChild(cellTitle);


                    var cellStatus = document.createElement("div");
                    cellStatus.className = "news-table__cell";
                    var spanStatus = document.createElement("span");
                    spanStatus.className = slide.status === 1 ? "status status--active" : "status status--inactive";
                    spanStatus.textContent = slide.status === 1 ? "Đang post" : "Chưa post";
                    cellStatus.appendChild(spanStatus);
                    row.appendChild(cellStatus);

                    var cellCreate = document.createElement("div");
                    cellCreate.className = "news-table__cell";
                    cellCreate.textContent = slide.createdAt;
                    row.appendChild(cellCreate);

                    var cellUpdate = document.createElement("div");
                    cellUpdate.className = "news-table__cell";
                    cellUpdate.textContent = slide.updatedAt;
                    row.appendChild(cellUpdate);

                    var cellCheck = document.createElement("div");
                    cellCheck.className = "news-table__cell";
                    var checkbox = document.createElement("input");
                    checkbox.type = "checkbox";
                    checkbox.disabled = true;
                    checkbox.checked = (slide.status === 1);
                    cellCheck.appendChild(checkbox);
                    row.appendChild(cellCheck);

                    var cellView = document.createElement("div");

                    cellView.className = "news-table__cell";

                    var btnView = document.createElement("button");

                    btnView.className = "news-table__view";

                    btnView.textContent = "Xem";

                    btnView.onclick = function() {
                        if (typeof openSlideDetail === "function") {
                            openSlideDetail(slide.id);
                        }
                    };

                    cellView.appendChild(btnView);

                    row.appendChild(cellView);

                    var cellEdit = document.createElement("div");
                    cellEdit.className = "news-table__cell";
                    var btnEdit = document.createElement("button");
                    btnEdit.className = "news-table__edit";
                    btnEdit.textContent = "Sửa";
                    btnEdit.onclick = function() {
                        if(typeof openSlideEdit === "function") {
                            openSlideEdit(slide.id);
                        }
                    };
                    cellEdit.appendChild(btnEdit);
                    row.appendChild(cellEdit);


                    var cellDelete = document.createElement("div");
                    cellDelete.className = "news-table__cell";
                    var btnDelete = document.createElement("button");
                    btnDelete.className = "news-table__delete";
                    btnDelete.textContent = "Xóa";
                    btnDelete.onclick = function() {
                        if(typeof deleteSlide === "function") {
                            deleteSlide(slide.id, row);
                        }
                    };
                    cellDelete.appendChild(btnDelete);
                    row.appendChild(cellDelete);

                    container.appendChild(row);
                });
            })
            .catch(function(error) {
                console.error("Lỗi fetch:", error);
            });
    }

    // xem slide
    window.openSlideDetail = function (slideId) {
        const sectionSlideDetail = document.getElementById("slide-detail");
        const sectionNewsSlideList = document.getElementById("news-slide");
        const newsMenu = document.querySelector(".news-menu");

        if(!sectionSlideDetail) return;

        fetch(PURE_CONTEXT_PATH + "/api/admin/manage-slide?action=detail&id=" + slideId)
            .then(function (response) {
                if (!response.ok) {
                    throw new Error("Lỗi kết nối API: " + response.status);
                }
                return response.json();
            })
            .then(function (data){
            if(data.status === "success") {
                document.getElementById("detailSlideTitle").textContent = data.title;
                document.getElementById("detailSlideCreatedAt").textContent = data.createdAt;
                document.getElementById("detailSlideUpdatedAt").textContent = data.updatedAt;

                const checkbox = document.getElementById("detailSlideCheckbox");
                if(checkbox) {
                    checkbox.checked = (data.statusValue === 1);
                }

                const statusSpan = document.getElementById("detailSlideStatusSpan");
                const statusText = document.getElementById("detailSlideStatusText");

                if(data.statusValue === 1) {
                    if(statusText) statusText.textContent = "Đang post";
                    if(statusSpan) {
                        statusSpan.textContent = "Đang post";
                        statusSpan.className = "slide-detail__status active";
                    }
                }  else {
                    if(statusText) statusText.textContent = "Chưa post";
                    if (statusSpan) {
                        statusSpan.textContent = "Chưa post";
                        statusSpan.className = "slide-detail__status inactive"; // Thêm class mờ màu (Tạm ẩn)
                    }
                }

                const imgTag = document.getElementById("detailSlideImg");
                if(imgTag) {
                    var bannerPath = data.banner; // assets/img/slides/anh.jpg
                    if (bannerPath && !bannerPath.startsWith("http") && !bannerPath.startsWith("/")) {
                        imgTag.src = PURE_CONTEXT_PATH + "/" + bannerPath;
                    } else {
                        imgTag.src = bannerPath || "";
                    }
                }

                if (typeof hideAllNewsViews === "function") {
                    hideAllNewsViews(); // Ẩn toàn bộ các view khác
                } else {
                    if (sectionNewsSlideList) sectionNewsSlideList.style.display = "none"; // Ẩn bảng danh sách slide
                }

                if (newsMenu) newsMenu.style.display = "none"; // ẩn menu

                // hiển thị detail
                sectionSlideDetail.classList.remove("hidden");
                sectionSlideDetail.style.display = "block";

                window.scrollTo({ top: 0, behavior: "smooth" });
            } else {
                alert("Không thể tải thông tin chi tiết: " + (data.message || "Lỗi không xác định."));
            }
        })
            .catch(function(error) {
                console.error("Lỗi AJAX lấy chi tiết slide:", error);
                alert("Đã xảy ra lỗi hệ thống khi tải thông tin slide!");
            });
    }

    // sửa slide
    window.openSlideEdit = function(slideId) {
        const sectionSlideEdit = document.getElementById("slide-edit");
        const sectionNewsSlideList = document.getElementById("news-slide");
        const newsMenu = document.querySelector(".news-menu");

        if(!sectionSlideEdit) return;

        fetch(PURE_CONTEXT_PATH + "/api/admin/manage-slide?action=detail&id=" + slideId)
            .then(function (response) {
                if (!response.ok) throw new Error("Lỗi kết nối API: " + response.status);
                return response.json();
            })
            .then(function (data) {
                if(data.status === "success") {
                    document.getElementById("editSlideId").value = data.id;
                    document.getElementById("editSlideTitle").value = data.title;
                    document.getElementById("editSlideStatus").value = data.statusValue; // Chọn 1 hoặc 0
                    document.getElementById("editSlideCreatedAt").value = data.createdAt;
                    document.getElementById("editSlideUpdatedAt").value = data.updatedAt;

                    // Cập nhật Badge hiển thị trạng thái bên cạnh ảnh
                    const statusSpan = document.getElementById("editSlideStatusSpan");
                    if(data.statusValue === 1) {
                        statusSpan.textContent = "Đang post";
                        statusSpan.className = "slide-detail__status active";
                    } else {
                        statusSpan.textContent = "Chưa post";
                        statusSpan.className = "slide-detail__status inactive";
                    }

                    // ảnh cũ
                    const imgTag = document.getElementById("editSlideImg");
                    if(imgTag) {
                        var bannerPath = data.banner;
                        if(bannerPath && !bannerPath.startsWith("http") && !bannerPath.startsWith("/")) {
                            imgTag.src = PURE_CONTEXT_PATH + "/" + bannerPath;
                        } else {
                            imgTag.src = bannerPath || "";
                        }
                    }

                    // ẩn
                    if (typeof hideAllNewsViews === "function") {
                        hideAllNewsViews();
                    } else {
                        if (sectionNewsSlideList) sectionNewsSlideList.style.display = "none";
                    }
                    if (newsMenu) newsMenu.style.display = "none";

                    // hiện
                    sectionSlideEdit.style.display = "block";
                    window.scrollTo({ top: 0, behavior: "smooth" });
                } else {
                    alert("Không thể tải thông tin slide: " + data.message);
                }
        })
            .catch(function(error) {
                console.error("Lỗi lấy thông tin sửa slide:", error);
                alert("Đã xảy ra lỗi hệ thống!");
            });
    }

    // lắng nghe sự kiện submit gửi form để gửi dl đã sửa lên server ngầm
    document.addEventListener("DOMContentLoaded", function () {
        const slideEditForm = document.getElementById("slideEditForm");
        const sectionSlideEdit = document.getElementById("slide-edit");
        const sectionNewsSlideList = document.getElementById("news-slide");

        if(slideEditForm) {
            slideEditForm.addEventListener("submit", function (e) {
                e.preventDefault();

                const formData = new FormData(slideEditForm);
                const btnUpdate = document.getElementById("btnUpdateSlide");
                let oldBtnHtml = btnUpdate ? btnUpdate.innerHTML : "Lưu thay đổi";

                if(btnUpdate) {
                    btnUpdate.disabled = true;
                    btnUpdate.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i> Đang lưu...';
                }

                // gọi api
                fetch(PURE_CONTEXT_PATH + "/api/admin/manage-slide?action=update", {
                    method: "POST",
                    body: formData
                })
                    .then(function (response) {
                        if (!response.ok) throw new Error("Lỗi kết nối Server: " + response.status);
                        return response.json();
                })
                    .then(function (data) {
                        if(btnUpdate) {
                            btnUpdate.disabled = false;
                            btnUpdate.innerHTML = oldBtnHtml;
                        }
                        if(data.status === "success") {
                            alert("Cập nhật slide thành công!");
                            slideEditForm.reset(); // xóa trống dl file vừa chọn

                            // ẩn
                            if (sectionSlideEdit) sectionSlideEdit.style.display = "none";
                            // hiện
                            if (sectionNewsSlideList) sectionNewsSlideList.style.display = "block";

                            const newsMenu = document.querySelector(".news-menu");
                            if (newsMenu) newsMenu.style.display = "flex";

                            // Gọi lại hàm load danh sách để bảng tự động cập nhật tên/ảnh mới ngầm
                            loadSlideTable();
                            window.scrollTo({ top: 0, behavior: "smooth" });
                        } else {
                            alert("Thất bại: " + data.message);
                        }
                    })
                    .catch(function (error) {
                        if (btnUpdate) {
                            btnUpdate.disabled = false;
                            btnUpdate.innerHTML = oldBtnHtml;
                        }
                        console.error("Lỗi AJAX cập nhật slide:", error);
                        alert("Đã xảy ra lỗi hệ thống khi lưu dữ liệu!");
                    });
            })
        }
    })

    // xóa slide
    window.deleteSlide = function (slideId, rowElement) {
        if(!confirm("Bạn có chắc muốn xóa slide này không? Khôi phục sẽ không khả thi!")) {
            return;
        }

        fetch(PURE_CONTEXT_PATH + "/api/admin/manage-slide?action=delete&id=" + slideId, {
            method: "POST"
        })
            .then(function (response) {
                if(!response.ok) {
                    throw new Error("Lỗi kết nối với server: " + response.status);
                }
                return response.json();
            })
            .then(function (data) {
                if(data.status === "success") {
                    alert("Xóa slide thành công!");

                // thêm hiệu ứng làm mờ dòng rồi xóa
                if(rowElement) {
                    rowElement.style.transition = "all 0.5s ease";
                    rowElement.style.opacity = "0";
                    rowElement.style.transform = "translateX(30px)";


                    // đợi hiệu ứng chạy xong 500ms thì xóa hẳn
                    setTimeout(function () {
                        rowElement.remove();
                        loadSlideTable();
                    }, 500);
                } else {
                    loadSlideTable();
                }
                } else {
                    alert("Xóa thất bại: " + (data.message || "Lỗi không xác định từ cơ sở dữ liệu."));
                }
            }) .catch(function (error) {
            console.error("Lỗi hệ thống khi thực hiện xóa slide:", error);
            alert("Đã xảy ra lỗi hệ thống, không thể thực hiện lệnh xóa!");
        });
    }
</script>

</html>
