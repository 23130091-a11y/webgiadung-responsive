<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Giỏ hàng</title>

    <!-- Reset CSS -->
    <link rel="stylesheet" href="assets/css/reset.css">
    <link rel="stylesheet" href="assets/css/grid.css">
    <link rel="stylesheet" href="assets/css/cart.css">
    <link rel="stylesheet" href="assets/css/base.css">
    <link rel="stylesheet" href="assets/css/style.css">

    <!-- Font -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link
            href="https://fonts.googleapis.com/css2?family=Open+Sans:ital,wght@0,300..800;1,300..800&family=Poppins:ital,wght@0,300;0,400;0,500;0,600;0,700;1,300;1,400;1,500;1,600;1,700&display=swap"
            rel="stylesheet">
    <!-- Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css"
          integrity="sha512-2SwdPD6INVrV/lHTZbO2nodKhrnDdJK9/kg2XD1r9uGqPo1cUbujc+IYdlYdEErWNu69gVcYgdxlmVmzTWnetw=="
          crossorigin="anonymous" referrerpolicy="no-referrer" />
</head>

<body>
<c:if test="${not empty sessionScope.orderMsg}">
    <div style="max-width:1200px;margin:12px auto;padding:10px 14px;border:1px solid #c3e6cb;background:#d4edda;color:#155724;border-radius:6px;">
            ${sessionScope.orderMsg}
    </div>
    <c:remove var="orderMsg" scope="session"/>
</c:if>

<c:if test="${not empty sessionScope.orderError}">
    <div style="max-width:1200px;margin:12px auto;padding:10px 14px;border:1px solid #f5c6cb;background:#f8d7da;color:#721c24;border-radius:6px;">
            ${sessionScope.orderError}
    </div>
    <c:remove var="orderError" scope="session"/>
</c:if>
<!-- header -->
<%@ include file="/common/header.jsp" %>

<main class="main" style=" background-color: #ffff; padding: 20px 0;">
    <div class="grid wide">
        <div class="cart-container">
            <c:set var="cart" value="${sessionScope.cart}" />
            <div id="cart-content-wrapper">
                <c:if test="${not empty sessionScope.error_msg}">
                    <div class="cart-error-alert" style="
                        background-color: #fff2f2;
                        color: #d93025;
                        padding: 15px 20px;
                        border: 1px solid #f8d7da;
                        border-radius: 8px;
                        margin-bottom: 20px;
                        display: flex;
                        align-items: center;
                        font-size: 1.5rem;
                        box-shadow: 0 2px 4px rgba(0,0,0,0.05);">

                        <i class="fa-solid fa-circle-exclamation" style="margin-right: 12px; font-size: 2rem;"></i>
                        <span style="flex: 1;">${sessionScope.error_msg}</span>

                        <button type="button" onclick="this.parentElement.style.display='none'" style="
                background: none;
                border: none;
                font-size: 2.2rem;
                cursor: pointer;
                color: #d93025;
                line-height: 1;">&times;</button>
                    </div>
                    <c:remove var="error_msg" scope="session" />
                </c:if>

                <c:choose>

                    <c:when test="${empty cart.items}">
                        <div class="empty-cart-style" style="text-align: center; padding: 30px 20px; display: flex; flex-direction: column; align-items: center; justify-content: center;">
                            <img src="assets/img/no-cart_img.png" alt="Empty" style="width: 200px; margin-bottom: 20px; display: block;">
                            <p style="font-size: 18px; color: #666; margin: 0 0 25px 0; display: block;">Giỏ hàng của bạn đang trống.</p>
                            <a href="${pageContext.request.contextPath}/list-product" class="buy-btn"
                               style="background-color: #fca120;
                              color: #fff;
                              padding: 12px 30px;
                              text-decoration: none;
                              border-radius: 5px;
                              font-weight: bold;
                              display: inline-block;
                              transition: background 0.3s;
                              box-shadow: 0 4px 6px rgba(0,0,0,0.1);">
                                MUA SẮM NGAY
                            </a>
                        </div>
                    </c:when>

                    <c:otherwise>
                        <div class="cart-header flex">
                            <div class="colum product-col">Sản phẩm</div>
                            <div class="colum price-col">Đơn giá</div>
                            <div class="colum qty-col">Số lượng</div>
                            <div class="colum total-col">Số tiền</div>
                            <div class="colum action-col">Thao tác</div>
                        </div>

                        <div class="shop-block">
                            <c:forEach var="item" items="${cart.items}">
                                <div class="cart-item flex"
                                     id="product-row-${item.product.id}"
                                     data-subtotal="${item.totalPrice}"
                                     data-qty="${item.quantity}">
                                    <div class="colum product-col flex">
                                        <input type="checkbox"
                                               class="item-checkbox"
                                               value="${item.product.id}">
                                        <a href="${pageContext.request.contextPath}/product?id=${item.product.id}">
                                            <img src="${pageContext.request.contextPath}/assets/img/products/${item.product.image}">
                                        </a>
                                        <a href="${pageContext.request.contextPath}/product?id=${item.product.id}">
                                            <div class="item-info">
                                                <p>${item.product.name}</p>
                                            </div>
                                        </a>
                                    </div>

                                    <div class="colum price-col">
                                        <div class="price-wrapper ">
                                            <div class="old-price-box">
                                                <fmt:formatNumber value="${item.originalPrice}" type="number"/> đ
                                            </div>
                                            <div class="new-price-box">
                                                    <span class="new-price" id="price-${item.product.id}">
                                                        <fmt:formatNumber value="${item.discountPrice}" type="number"/>
                                                    </span> đ
                                            </div>
                                        </div>
                                    </div>

                                    <div class="colum qty-col item-qty">
                                        <button type="button" onclick="handleUpdate(${item.product.id}, 'dec')">-</button>
                                        <input class="text" type="text" id="qty-input-${item.product.id}" value="${item.quantity}" readonly>
                                        <button type="button" onclick="handleUpdate(${item.product.id}, 'inc')">+</button>
                                    </div>

                                    <div class="colum total-col">
                                            <span id="subtotal-${item.product.id}">
                                                <fmt:formatNumber value="${item.totalPrice}" type="number"/>
                                            </span>
                                    </div>

                                    <div class="colum action-col">
                                        <button type="button" class="item-delete" onclick="deleteItem(${item.product.id})">Xóa</button>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>

                        <div class="cart-footer flex">
                            <input type="checkbox" id="select-all" class="select-all-footer"> Chọn tất cả
                            <button type="button" class="footer-btn"onclick="deleteSelected()">Xóa</button>
                            <button type="button" class="footer-btn">Lưu vào mục yêu thích</button>

                            <div class="cart-summary">
                                Tổng cộng (<span id="cart-qty-total" class="total-items">${cart.totalQuantity}</span> sản phẩm):
                                <span id="cart-grand-total" class="total-price">
                                        <fmt:formatNumber value="${cart.totalPrice}" type="number"/> đ
                                    </span>
                            </div>

                            <button type="button" class="buy-btn" onclick="checkoutSelected()">Thanh toán</button>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <div class="featured-list">
            <section class="featured">
                <h2>Có thể bạn cũng thích</h2>
                <div class="list row small-gutter">
                    <div class="col l-3 m-4 c-6">
                        <div class="product-card">
                            <a><img src="assets/img/thuphatamthnah.png" alt=""></a>
                            <a>
                                <p>Bộ thu phát âm thanh không dây truyền tín hiệu mạnh, kết nối đa thiết bị, Bộ thu
                                    phát
                                    âm
                                    thanh NFC BT200</p>
                            </a>
                            <div class="price-discount">
                                <div class="price-top">
                                    <span class="old-price">500.000đ</span>
                                    <div class="discount-badge">Giảm 25%</div>
                                </div>
                                <div class="price-bottom">
                                    <span class="new-price">375.000đ</span>
                                </div>
                            </div>
                            <div class="bottom">
                                <div class="star"><i class="fa-solid fa-star"></i> 4.8</div>
                                <button class="fav-btn"><i class="fa-regular fa-heart"></i> Yêu thích</button>
                            </div>
                        </div>
                    </div>
                    <div class="col l-3 m-4 c-6">
                        <div class="product-card">
                            <a><img src="assets/img/fan.jpg" alt=""></a>
                            <a>
                                <p>Quạt đôi mini xoay 360 độ 12V-24V tiện ích trên ô tô </p>
                            </a>
                            <span class="price">118.000đ</span>
                            <div class="bottom">
                                <div class="star"><i class="fa-solid fa-star"></i> 5</div>
                                <button class="fav-btn"><i class="fa-regular fa-heart"></i> Yêu thích</button>
                            </div>
                        </div>
                    </div>
                    <div class="col l-3 m-4 c-6">
                        <div class="product-card">
                            <a><img src="assets/img/maylamtoc.png" alt=""></a>
                            <a>
                                <p>Máy làm tóc đa năng 3 trong 1 uốn, là, ép kiểu Hàn Quốc, Màu đen</p>
                            </a>
                            <span class="price">266.000đ</span>
                            <div class="bottom">
                                <div class="star"><i class="fa-solid fa-star"></i> 4.4</div>
                                <button class="fav-btn"><i class="fa-regular fa-heart"></i> Yêu thích</button>
                            </div>
                        </div>
                    </div>
                    <div class="col l-3 m-4 c-6">
                        <div class="product-card">
                            <a><img src="assets/img/ghe.jpg" alt=""></a>
                            <a>
                                <p>Gối tựa lưng cao su non giúp thư giãn dành cho dân văn phòng, Màu đen</p>
                            </a>
                            <div class="price-discount">
                                <div class="price-top">
                                    <span class="old-price">420.000đ</span>
                                    <div class="discount-badge">Giảm 15%</div>
                                </div>
                                <div class="price-bottom">
                                    <span class="new-price">375.000đ</span>
                                </div>
                            </div>
                            <div class="bottom">
                                <div class="star"><i class="fa-solid fa-star"></i> 5</div>
                                <button class="fav-btn"><i class="fa-regular fa-heart"></i> Yêu thích</button>
                            </div>
                        </div>
                    </div>
                    <div class="col l-3 m-4 c-6">
                        <div class="product-card">
                            <a><img src="assets/img/bochuyendoi.jpg" alt=""></a>
                            <a>
                                <p>Bộ chuyển đổi CarPlay không dây 2in1 cho xe hơi hiện đại</p>
                            </a>
                            <div class="price-discount">
                                <div class="price-top">
                                    <span class="old-price">385.000đ</span>
                                    <div class="discount-badge">Giảm 15%</div>
                                </div>
                                <div class="price-bottom">
                                    <span class="new-price">327.000đ</span>
                                </div>
                            </div>
                            <div class="bottom">
                                <div class="star"><i class="fa-solid fa-star"></i> 4.6</div>
                                <button class="fav-btn"><i class="fa-regular fa-heart"></i> Yêu thích</button>
                            </div>
                        </div>
                    </div>
                    <div class="col l-3 m-4 c-6">
                        <div class="product-card">
                            <a><img src="assets/img/denhoc.jpg" alt=""></a>
                            <a>
                                <p>Đèn học chống cận cao cấp 3 chế độ sáng, bật tắt cảm ứng tiện lợi, Loại 6000mah
                                    (gồm
                                    cả
                                    củ sạc)</p>
                            </a>
                            <span class="price">187.000đ</span>
                            <div class="bottom">
                                <div class="star"><i class="fa-solid fa-star"></i> 5</div>
                                <button class="fav-btn"><i class="fa-regular fa-heart"></i> Yêu thích</button>
                            </div>
                        </div>
                    </div>
                    <div class="col l-3 m-4 c-6">
                        <div class="product-card">
                            <a><img src="assets/img/tuirac.jpg" alt=""></a>
                            <a>
                                <p>Combo 500 túi lọc rác bồn rửa bát chống tắc nghẽn tiện lợi</p>
                            </a>
                            <span class="price">154.000đ</span>
                            <div class="bottom">
                                <div class="star"><i class="fa-solid fa-star"></i> 4.1</div>
                                <button class="fav-btn"><i class="fa-regular fa-heart"></i> Yêu thích</button>
                            </div>
                        </div>
                    </div>
                    <div class="col l-3 m-4 c-6">
                        <div class="product-card">
                            <a><img src="assets/img/micro.jpg" alt=""></a>
                            <a>
                                <p>Micro không dây kèm loa bluetooth YS-69 bass mạnh hỗ trợ ghi âm cao cấp</p>
                            </a>
                            <span class="price">352.000đ</span>
                            <div class="bottom">
                                <div class="star"><i class="fa-solid fa-star"></i> 3.6</div>
                                <button class="fav-btn"><i class="fa-regular fa-heart"></i> Yêu thích</button>
                            </div>
                        </div>
                    </div>
                    <div class="col l-3 m-4 c-6">
                        <div class="product-card">
                            <a><img src="assets/img/bochuyendoi.jpg" alt=""></a>
                            <a>
                                <p>Bộ chuyển đổi CarPlay không dây 2in1 cho xe hơi hiện đại</p>
                            </a>
                            <div class="price-discount">
                                <div class="price-top">
                                    <span class="old-price">385.000đ</span>
                                    <div class="discount-badge">Giảm 15%</div>
                                </div>
                                <div class="price-bottom">
                                    <span class="new-price">327.000đ</span>
                                </div>
                            </div>
                            <div class="bottom">
                                <div class="star"><i class="fa-solid fa-star"></i> 4.4</div>
                                <button class="fav-btn"><i class="fa-regular fa-heart"></i> Yêu thích</button>
                            </div>
                        </div>
                    </div>
                    <div class="col l-3 m-4 c-6">
                        <div class="product-card">
                            <a><img src="assets/img/chaixit.jpg" alt=""></a>
                            <a>
                                <p>Chai xịt rệp giường, mạt bụi hiệu quả an toàn</p>
                            </a>
                            <div class="price-discount">
                                <div class="price-top">
                                    <span class="old-price">185.000đ</span>
                                    <div class="discount-badge">Giảm 20%</div>
                                </div>
                                <div class="price-bottom">
                                    <span class="new-price">148.000đ</span>
                                </div>
                            </div>
                            <div class="bottom">
                                <div class="star"><i class="fa-solid fa-star"></i> 5</div>
                                <button class="fav-btn"><i class="fa-regular fa-heart"></i> Yêu thích</button>
                            </div>
                        </div>
                    </div>
                    <div class="col l-3 4 m-4 c-6">
                        <div class="product-card">
                            <a><img src="assets/img/quatsac.png" alt=""></a>
                            <a>
                                <p>Quạt sạc mini pin trâu 20000mah hiện đại dùng được lâu dài
                                </p>
                            </a>
                            <div class="price-discount">
                                <div class="price-top">
                                    <span class="old-price">653.000đ</span>
                                    <div class="discount-badge">Giảm 20%</div>
                                </div>
                                <div class="price-bottom">
                                    <span class="new-price">522.000đ</span>
                                </div>
                            </div>
                            <div class="bottom">
                                <div class="star"><i class="fa-solid fa-star"></i> 4.8</div>
                                <button class="fav-btn"><i class="fa-regular fa-heart"></i> Yêu
                                    thích</button>
                            </div>
                        </div>
                    </div>
                    <div class="col l-3 m-4 c-6">
                        <div class="product-card">
                            <a><img src="assets/img/binhxit.png" alt=""></a>
                            <a>
                                <p>Bình xịt diệt bọ rệp, mạt bụi thảo mộc thiên nhiên an toàn 330ml</p>
                            </a>
                            <span class="price">112.000đ</span>
                            <div class="bottom">
                                <div class="star"><i class="fa-solid fa-star"></i> 3.9</div>
                                <button class="fav-btn"><i class="fa-regular fa-heart"></i> Yêu
                                    thích</button>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
        </div>
    </div>
</main>
<!-- Footer -->
<jsp:include page="/common/footer.jsp" />

<script>
    // update tăng giảm
    function handleUpdate(pId, actionType) {
        const params = new URLSearchParams();
        params.append('productId', pId);
        params.append('action', actionType);
        params.append('ajax', '1');

        fetch('${pageContext.request.contextPath}/update-cart', {
            method: 'POST',
            body: params,
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
                'X-Requested-With': 'XMLHttpRequest'
            }
        })
            .then(r => {
                if(!r.ok) {
                    return r.json().then(err => {
                        throw err;
                    });
                }
                return r.json();
            })
            .then(data => {
                if (data.newQuantity > 0) {
                    document.getElementById('qty-input-' + pId).value = data.newQuantity;
                    document.getElementById('subtotal-' + pId).innerText = data.newSubtotal;

                    const row = document.getElementById('product-row-' + pId);
                    if (row) {
                        row.dataset.subtotal = data.rawSubtotal;
                        row.dataset.qty = data.newQuantity;
                    }

                } else {
                    const row = document.getElementById('product-row-' + pId);
                    if (row) row.remove();
                }

                // cập nhật icon giỏ ở header
                updateHeaderCartQty(data.cartQty);

                // tính lại tổng tiền
                recalcSelectedTotals();
            })
            .catch(err => {
                console.error('Lỗi Cart:', err);
                if (err.message) {
                    alert(err.message);
                }

                if (err.cartQty !== undefined) {
                    updateHeaderCartQty(err.cartQty);
                }

                location.reload();
            });
    }

    // Xóa
    function deleteItem(pId) {
        if (!confirm("Bạn có chắc chắn muốn xóa sản phẩm này?")) return;

        window.removeCartItemGlobal(pId, function(data) {

            const row = document.getElementById('product-row-' + pId);
            if (row) row.remove();

            // Tính toán lại các con số tổng tiền dưới bảng
            if (typeof recalcSelectedTotals === "function") {
                recalcSelectedTotals();
            }

            const remain = document.querySelectorAll('.cart-item').length;
            if (remain === 0) {
                handleEmptyCartUI();
            }
        });
    }

    function updateHeaderCartQty(qty) {
        const el = document.querySelector('#headerCartQty');
        if (el) el.innerText = qty;
    }

    // hàm cập nhật tổng tiền và tổng số lượng sau mỗi lần update và xóa
    function recalcSelectedTotals() {
        const checked = document.querySelectorAll('.item-checkbox:checked');
        let total = 0;
        let qty = 0;

        checked.forEach(cb => {
            const id = cb.value;
            const row = document.getElementById('product-row-' + id);
            if (!row) return;

            // fix bug nan
            let subtotalVal = parseFloat(row.dataset.subtotal);
            if (isNaN(subtotalVal)) subtotalVal = 0;

            total += subtotalVal;
            qty += Number(row.dataset.qty || 0);
        });

        const totalElem = document.getElementById('cart-grand-total');
        const qtyElem = document.getElementById('cart-qty-total');
        // kt có tồn tại rồi mới gán
        if (totalElem) {
            totalElem.innerText = total.toLocaleString('vi-VN') + ' đ';
        }

        if (qtyElem) {
            qtyElem.innerText = qty;
        }
    }

    // xử lý chọn 1, tất cả item, hiển thị tổng tiền
    document.addEventListener('change', function(e){
        if (e.target.classList.contains('item-checkbox')) {
            recalcSelectedTotals();
        }

        if (e.target.classList.contains('select-all-footer')) {
            const all = document.querySelectorAll('.item-checkbox');
            all.forEach(cb => cb.checked = e.target.checked);

            // sync trạng thái đc chọn cho ông chọn tất cả
            const footerAll = document.querySelector('.select-all-footer');
            if (footerAll) footerAll.checked = e.target.checked;

            recalcSelectedTotals();
        }
    });

    // gom nhóm các sp khách muốn mua
    function checkoutSelected() {
        const checked = document.querySelectorAll('.item-checkbox:checked');
        if (checked.length === 0) {
            alert("Bạn vui lòng chọn ít nhất một sản phẩm để thanh toán!");
            return;
        }
        // Gom ID thành chuỗi cách nhau bởi dấu phẩy
        const ids = Array.from(checked)
            .map(cb => cb.value)
            .join(',');

        window.location.href = '${pageContext.request.contextPath}/checkout?ids=' + ids;
    }

    // remain
    window.addEventListener('load', recalcSelectedTotals);

    //// xóa nhiều dòng đã chọn
    async function deleteSelected() {
        const checked = document.querySelectorAll('.item-checkbox:checked');
        if (checked.length === 0) {
            alert("Bạn chưa chọn sản phẩm nào để xóa!");
            return;
        }

        if (!confirm("Xóa các sản phẩm đã chọn khỏi giỏ hàng?")) return;

        const ids = Array.from(checked)
            .map(cb => cb.value);

        for (const pid of ids) {
            await new Promise(resolve => {
                window.removeCartItemGlobal(pid, () => resolve());
            });

            const row = document.getElementById('product-row-' + pid);
            if (row) row.remove();
        }

        // Sau khi xóa hết các món đã chọn:
        if (typeof recalcSelectedTotals === 'function') {
            recalcSelectedTotals();
        }

        // Kiểm tra nếu giỏ hàng trống hoàn toàn thì hiện giao diện trống
        const remain = document.querySelectorAll('[id^="product-row-"]').length;
        if (remain === 0) {
            if (typeof handleEmptyCartUI === 'function') {
                handleEmptyCartUI();
            } else {
                location.reload();
            }
        }
    }

    function handleEmptyCartUI() {
        const wrapper = document.getElementById('cart-content-wrapper');
        if (wrapper) {
            wrapper.innerHTML = `
        <div class="empty-cart-style" style="text-align: center; padding: 30px 20px; display: flex; flex-direction: column; align-items: center; justify-content: center;">
            <img src="assets/img/no-cart_img.png" alt="Empty" style="width: 200px; margin-bottom: 20px; display: block;">
            <p style="font-size: 18px; color: #666; margin: 0 0 25px 0; display: block;">Giỏ hàng của bạn đang trống.</p>
            <a href="${pageContext.request.contextPath}/list-product" class="buy-btn"
               style="background-color: #fca120;
                      color: #fff;
                      padding: 12px 30px;
                      text-decoration: none;
                      border-radius: 5px;
                      font-weight: bold;
                      display: inline-block;
                      transition: background 0.3s;
                      box-shadow: 0 4px 6px rgba(0,0,0,0.1);">
               MUA SẮM NGAY
            </a>
        </div>
    `;
        }
    }

</script>

<script src="assets/js/script.js"></script>

</body>

</html>