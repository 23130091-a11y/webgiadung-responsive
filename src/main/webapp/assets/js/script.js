/* Script slider */
const slides = document.querySelectorAll("#slider .slide");
let index = 0;
/* Kiểm tra trong code html có #slider mới active */
if (slides.length > 0) {
    slides[index].classList.add("active");

    function nextSlide() {
        slides[index].classList.remove("active");
        index = (index + 1) % slides.length;
        slides[index].classList.add("active");
    };

    slides[index].classList.add("active");
    setInterval(nextSlide, 3000);
}

// Script Navigation button 
document.querySelectorAll('.featured').forEach(section => {
    const list = section.querySelector('.product-list');
    const btnLeft = section.querySelector('.scroll-btn.left');
    const btnRight = section.querySelector('.scroll-btn.right');
    if (btnLeft && btnRight && list) {
        btnLeft.addEventListener('click', () => {
            list.scrollBy({ left: -300, behavior: 'smooth' });
        });

        btnRight.addEventListener('click', () => {
            list.scrollBy({ left: 300, behavior: 'smooth' });
        });
    }
});



//Click button view
const slideWrappers = document.querySelectorAll('.slide-wrapper');

slideWrappers.forEach(wrapper => {
    const button = wrapper.querySelector('.button-view');
    const icon = button.querySelector('i');
    
    button.addEventListener('click', () => {
        wrapper.classList.toggle('active');

        if(wrapper.classList.contains('active')) {
            icon.classList.remove('fa-chevron-down');
            icon.classList.add('fa-chevron-up');
        } else {
            icon.classList.remove('fa-chevron-up');
            icon.classList.add('fa-chevron-down');
        }
    });
});
//admin

    (function () {
    const revenueForm = document.getElementById('revenueFilterForm');
    const revenueTableBody = document.getElementById('revenueTableBody');
    const revenueCancelledOrdersValue = document.getElementById('revenueCancelledOrdersValue');
    const revenueStatusCancelled = document.getElementById('revenueStatusCancelled');
    const revenueContextPath = '${pageContext.request.contextPath}';

    if (!revenueForm || !revenueTableBody) return;

    const revenueState = {
    orders: [],
    loaded: false
};

    function normalizeText(value) {
    return (value || '').replace(/\s+/g, ' ').trim();
}

    function parseMoney(value) {
    const digits = String(value || '').replace(/[^\d-]/g, '');
    return digits ? Number(digits) : 0;
}

    function formatMoney(value) {
    return new Intl.NumberFormat('vi-VN').format(Number(value || 0)) + ' VND';
}

    function pad(number) {
    return String(number).padStart(2, '0');
}

    function normalizeDate(rawValue) {
    const value = normalizeText(rawValue);
    if (!value) return null;

    let match = value.match(/(\d{2})\/(\d{2})\/(\d{4})/);
    if (match) return `${match[3]}-${match[2]}-${match[1]}`;

    match = value.match(/(\d{4})-(\d{2})-(\d{2})/);
    if (match) return `${match[1]}-${match[2]}-${match[3]}`;

    const parsed = new Date(value);
    if (!Number.isNaN(parsed.getTime())) {
    return `${parsed.getFullYear()}-${pad(parsed.getMonth() + 1)}-${pad(parsed.getDate())}`;
}

    return null;
}

    function displayDate(dateKey) {
    if (!dateKey) return '---';
    const parts = dateKey.split('-');
    return `${parts[2]}/${parts[1]}/${parts[0]}`;
}

    function getCellText(cell) {
    if (!cell) return '';
    const select = cell.querySelector('select');
    if (select) {
    const option = select.options[select.selectedIndex];
    if (option) return normalizeText(option.textContent || option.value);
}
    return normalizeText(cell.textContent);
}

    function deriveStatus(transportValue, paymentValue, row) {
    const haystack = `${transportValue} ${paymentValue} ${row.className}`.toLowerCase();

    if (/hủy|huỷ|cancel/.test(haystack)) return 'cancelled';
    if (/hoàn tất|hoan tat|completed|done|đã giao|da giao|giao thành công/.test(haystack)) return 'done';
    if (/đang giao|dang giao|shipping|vận chuyển|van chuyen/.test(haystack)) return 'shipping';
    if (/chờ|cho xu ly|chờ xử lý|pending|xử lý|xu ly|processing/.test(haystack)) return 'pending';

    return 'other';
}

    function extractOrdersFromHtml(html) {
    const parser = new DOMParser();
    const doc = parser.parseFromString(html, 'text/html');
    const rows = Array.from(doc.querySelectorAll('.order-table__row'));
    const orders = [];

    rows.forEach((row) => {
    if (row.classList.contains('table-header')) return;

    const cells = Array.from(row.querySelectorAll('.order-table__cell'));
    if (cells.length < 6) return;

    const offset = cells.length >= 7 ? 1 : 0;

    const idCell = cells[offset];
    const customerCell = cells[offset + 1];
    const transportCell = cells[offset + 2];
    const paymentCell = cells[offset + 3];
    const createdCell = cells[offset + 4];
    const totalCell = cells[offset + 5];

    if (!idCell || !customerCell || !transportCell || !paymentCell || !createdCell || !totalCell) return;

    const orderId = getCellText(idCell);
    const customerName = getCellText(customerCell);
    const statusTransport = getCellText(transportCell);
    const statusPayment = getCellText(paymentCell);
    const createdDate = normalizeDate(getCellText(createdCell));
    const totalPrice = parseMoney(getCellText(totalCell));
    const statusKey = deriveStatus(statusTransport, statusPayment, row);

    if (!orderId || !createdDate) return;

    orders.push({
    orderId,
    customerName,
    createdDate,
    totalPrice,
    statusKey
});
});

    return orders;
}

    async function loadRevenueOrders() {
    const response = await fetch(revenueContextPath + '/order-search?keyword=', {
    method: 'GET',
    headers: {
    'X-Requested-With': 'XMLHttpRequest'
}
});

    if (!response.ok) {
    throw new Error('Không thể tải dữ liệu đơn hàng.');
}

    const html = await response.text();
    revenueState.orders = extractOrdersFromHtml(html);
    revenueState.loaded = true;
}

    function getFilters() {
    const formData = new FormData(revenueForm);
    return {
    fromDate: normalizeText(formData.get('fromDate')),
    toDate: normalizeText(formData.get('toDate')),
    status: normalizeText(formData.get('status'))
};
}

    function filterOrders(orders, filters) {
    return orders.filter((order) => {
    if (filters.fromDate && order.createdDate < filters.fromDate) return false;
    if (filters.toDate && order.createdDate > filters.toDate) return false;
    if (filters.status && order.statusKey !== filters.status) return false;
    return true;
});
}

    function getBadge(cancelledCount) {
    if (cancelledCount > 0) {
    return { className: 'revenue-badge--danger', label: 'Có đơn hủy' };
}
    return { className: 'revenue-badge--success', label: 'Ổn định' };
}

    function groupOrdersByDate(orders) {
    const grouped = new Map();

    orders.forEach((order) => {
    if (!grouped.has(order.createdDate)) {
    grouped.set(order.createdDate, []);
}
    grouped.get(order.createdDate).push(order);
});

    return Array.from(grouped.entries())
    .sort((a, b) => b[0].localeCompare(a[0]))
    .map(([dateKey, rows]) => {
    const grossRevenue = rows.reduce((sum, item) => sum + item.totalPrice, 0);
    const cancelledOrders = rows.filter(item => item.statusKey === 'cancelled');
    const cancelledCount = cancelledOrders.length;
    const cancelledValue = cancelledOrders.reduce((sum, item) => sum + item.totalPrice, 0);
    const netRevenue = grossRevenue - cancelledValue;
    const badge = getBadge(cancelledCount);

    return {
    dateKey,
    totalOrders: rows.length,
    grossRevenue,
    cancelledCount,
    cancelledValue,
    netRevenue,
    badge
};
});
}

    function renderCancelledSummary(filteredOrders) {
    const cancelledCount = filteredOrders.filter(order => order.statusKey === 'cancelled').length;

    if (revenueCancelledOrdersValue) {
    revenueCancelledOrdersValue.textContent = String(cancelledCount);
}

    if (revenueStatusCancelled) {
    revenueStatusCancelled.textContent = String(cancelledCount);
}
}

    function renderRevenueTable(filteredOrders) {
    const rows = groupOrdersByDate(filteredOrders);

    if (!rows.length) {
    revenueTableBody.innerHTML = `
                <tr>
                    <td colspan="7" class="revenue-empty">Không có dữ liệu phù hợp với bộ lọc hiện tại.</td>
                </tr>
            `;
    return;
}

    revenueTableBody.innerHTML = rows.map((row) => `
            <tr>
                <td>${displayDate(row.dateKey)}</td>
                <td>${row.totalOrders}</td>
                <td>${formatMoney(row.grossRevenue)}</td>
                <td>${row.cancelledCount}</td>
                <td>${formatMoney(row.cancelledValue)}</td>
                <td>${formatMoney(row.netRevenue)}</td>
                <td><span class="revenue-badge ${row.badge.className}">${row.badge.label}</span></td>
            </tr>
        `).join('');
}

    async function renderRevenueCancelledOnly() {
    try {
    if (!revenueState.loaded) {
    await loadRevenueOrders();
}

    const filters = getFilters();
    const filteredOrders = filterOrders(revenueState.orders, filters);

    renderCancelledSummary(filteredOrders);
    renderRevenueTable(filteredOrders);
} catch (error) {
    revenueTableBody.innerHTML = `
                <tr>
                    <td colspan="7" class="revenue-empty">Không thể tải dữ liệu đơn hàng.</td>
                </tr>
            `;

    if (revenueCancelledOrdersValue) {
    revenueCancelledOrdersValue.textContent = '0';
}

    if (revenueStatusCancelled) {
    revenueStatusCancelled.textContent = '0';
}

    console.error(error);
}
}

    revenueForm.addEventListener('submit', function (event) {
    event.preventDefault();
    renderRevenueCancelledOnly();
});

    window.addEventListener('DOMContentLoaded', renderRevenueCancelledOnly);
})();
