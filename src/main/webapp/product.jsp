<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tên sản phẩm</title>

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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/product.css?v=99">
    <!-- Link favicon -->
</head>

<body>
    <!-- header -->
    <%@ include file="/common/header.jsp" %>

    <main class="main">
        <c:set var="product" value="${product}" />
        <!-- product-details -->
        <div class="product-details">
            <div class="grid wide">
                <div class="navigation nav-product">
                    <a href="${pageContext.request.contextPath}/list-product" class="navigation__link">Trang chủ</a>
                    <c:forEach items="${parentCategories}" var="parent">
                        <i class="fa-solid fa-chevron-right"></i>
                        <a href="#!" class="navigation__link">${parent.name}</a>
                    </c:forEach>
                    <i class="fa-solid fa-chevron-right"></i>
                    <a href="${pageContext.request.contextPath}/search-product?categoryId=${category.id}" class="navigation__link">${category.name}</a>
                    <i class="fa-solid fa-chevron-right"></i>
                    <a href="#!" class="navigation__link--active">${product.name}</a>
                </div>

                <div class="product-details__inner">
                    <!-- Media Details -->
                    <div class="product-image-wrapper">
                     <figure class="media-details">
                        <img src="${pageContext.request.contextPath}/assets/img/products/${product.image}"
                             alt="${product.name}"
                             class="media-details__img"
                             id="main-product-image">
                     </figure>

                     <div class="media-thumbnails">

                        <c:if test="${not empty product.images}">
                            <c:forEach var="imgObj" items="${product.images}">
                                <img src="${pageContext.request.contextPath}/assets/img/products/${imgObj.path}"
                                     alt="Thumbnail"
                                     class="media-thumbnails__img"
                                     onclick="changeMainImage(this)">
                            </c:forEach>
                        </c:if>

                      </div>
                    </div>
                    <!-- Content Details -->
                    <div class="content-details">
                        <h1 class="content-details__heading">
                            ${product.name}
                        </h1>
                        <!-- Rating & Sold -->
                        <div class="content-details__review-wrap">
                            <div class="content-feedback">
                                <span class="content-feedback__level">${product.rating}</span>
                                <div class="rating">
                                    <c:forEach begin="1" end="5" var="i">
                                        <c:choose>
                                            <c:when test="${i <= product.ratingInt}">
                                                <i class="fa-solid fa-star rating__star rating__star--gold"></i>
                                            </c:when>
                                            <c:otherwise>
                                                <i class="fa-solid fa-star rating__star"></i>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:forEach>
                                </div>
                            </div>
                            <div class="content-details__separate"></div>
                            <div class="content-sold">
                                <span class="content-sold__text">Đã bán</span>
                                <span class="content-feedback__level">${product.soldQuantity}</span>
                            </div>
                            <div class="content-details__separate"></div>
                            <div class="content-sold">
                                <span class="content-sold__text">Số lượng kho</span>
                                <span class="content-feedback__level">${product.quantity}</span>
                            </div>
                        </div>
                        <c:if test="${product.discountPercent > 0}">
                            <div class="content-details__desc-wrap">
                                <span class="content-details__desc">Giá gốc</span>
                                <span class="content-details__desc">
                                <fmt:formatNumber value="${product.firstPrice}" type="number"/> đ
                                  </span>
                            </div>

                            <div class="content-details__desc-wrap">
                                <span class="content-details__desc">Giảm</span>
                                <span class="content-details__desc">${product.discountPercent} %</span>
                            </div>
                        </c:if>
                        <div class="content-details__desc-wrap">
                            <span class="content-details__desc">Giá</span>
                            <span class="content-details__price"><fmt:formatNumber value="${product.totalPrice}" type="number"/> đ</span>
                        </div>

                        <c:if test="${not empty product.descriptions}">
                            <c:forEach items="${product.descriptions}" var="desc">
                                <div class="content-details__desc-wrap">
                                    <span class="content-details__desc"><strong>${desc.attrName}</strong></span>

                                    <span class="content-details__info">${desc.value}</span>
                                </div>
                            </c:forEach>
                        </c:if>

                        <div class="content-details__desc-wrap content-details__option">
                            <span class="content-details__desc">Số lượng</span>
                            <div class="content-quantity">
                                <button class="content-quantity__btn content-quantity__btn--disable">-</button>
                                <span class="content-quantity__number">1</span>
                                <button class="content-quantity__btn">+</button>
                            </div>
                        </div>

                        <div class="content-details__act">
                            <button type="button" class="content-details__cart-btn btn"
                                    onclick="addToCart(${product.id})">
                                <i class="fa-solid fa-cart-plus content-details__cart-icon"></i>
                                Thêm vào giỏ hàng
                            </button>
                            <button type="button" class="content-details__buy btn btn--default-color"
                                    onclick="buyNow(${product.id})">Mua ngay</button>
                        </div>

                        <div class="content-details__trp">
                            <span class="content-details__trp-text">Vận chuyển</span>
                            <a href="#!" class="content-details__trp-link">
                                <i class="fa-regular fa-truck content-details__trp-icon"></i>
                                Thời gian và phí giao hàng
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="product-desc">
            <div class="grid wide">
                <div class="row small-gutter product-desc__inner">
                    <div class="col l-9 m-12 c-12">
                        <div class="product-desc__content">
                            <c:if test="${not empty product.details}">
                                <c:forEach items="${product.details}" var="detail">
                                    <h2 class="product-desc__name">${detail.title}</h2>

                                    <p class="product-desc__text">${detail.description}
                                    </p>

                                    <figure class="product-desc__thumb">
                                        <img class="product-desc__img"
                                             src="${pageContext.request.contextPath}/assets/img/details/${detail.image}"
                                             alt="${detail.title}"
                                        />
                                    </figure>
                                </c:forEach>
                            </c:if>
                        </div>
                    </div>

                    <div class="col l-3 m-0 c-0">
                        <div class="product-desc__view-more">
                            <section class="product-propose">
                                <h2 class="section-title product-propose__heading">Đề xuất cho bạn</h2>
                                <article class="product-propose__item">
                                    <a href="#!">
                                        <img class="product-propose__img" src="assets/img/propose-01.jpg"
                                            alt="Máy xay đa năng cầm tay">
                                        <h3 class="product-propose__name">Máy xay đa năng cầm tay 6 lưỡi cối thủy tinh
                                            chịu nhiệt</h3>
                                    </a>
                                    <span class="product-propose__price">260.000đ</span>
                                </article>
                                <article class="product-propose__item">
                                    <a href="#!">
                                        <img class="product-propose__img" src="assets/img/propose-02.jpg"
                                            alt="Máy xay đa năng cầm tay">
                                        <h3 class="product-propose__name">Ấm siêu tốc 2 lớp bền đẹp Thái Lan công nghệ
                                            Inverter</h3>
                                    </a>
                                    <span class="product-propose__price">161.000đ</span>
                                </article>
                                <article class="product-propose__item">
                                    <a href="#!">
                                        <img class="product-propose__img" src="assets/img/propose-03.jpg"
                                            alt="Máy xay đa năng cầm tay">
                                        <h3 class="product-propose__name">Đèn bắt muỗi năng lượng mặt trời Đèn diệt muỗi
                                            điện tử LED</h3>
                                    </a>
                                    <span class="product-propose__price">265.000đ</span>
                                </article>
                            </section>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="product-feedback">
            <div class="grid wide">
                <div class="row small-gutter">
                    <div class="col l-9 m-12 c-12">
                        <div class="product-comment" id="reviews">
                            <h2 class="section-title product-comment__heading">Chia sẻ đánh giá của bạn</h2>

                            <c:choose>
                                <c:when test="${empty sessionScope.user}">
                                    <p style="margin:12px 0;">
                                        Bạn cần <b>đăng nhập</b> để gửi đánh giá.
                                    </p>

                                    <c:url var="loginUrl" value="/login">
                                        <c:param name="redirect" value="/product?id=${product.id}#reviews"/>
                                    </c:url>

                                    <a class="btn btn--default-color btn-comt"
                                       href="${pageContext.request.contextPath}/login?redirect=/product?id=${product.id}%23reviews">
                                       Đăng nhập để đánh giá
                                    </a>
                                </c:when>

                                <c:otherwise>
                                    <form action="${pageContext.request.contextPath}/review" method="post" enctype="multipart/form-data">
                                        <input type="hidden" name="productId" value="${product.id}" />
                                        <input type="hidden" name="rating" id="ratingValue" value="5" />

                                        <div class="product-comment__vote">
                                            <span class="product-comment__title">Đánh giá của bạn: </span>
                                            <div class="rating" id="ratingStars" style="cursor:pointer;">
                                                <i class="fa-solid fa-star rating__star rating__star--gold" data-val="1"></i>
                                                <i class="fa-solid fa-star rating__star rating__star--gold" data-val="2"></i>
                                                <i class="fa-solid fa-star rating__star rating__star--gold" data-val="3"></i>
                                                <i class="fa-solid fa-star rating__star rating__star--gold" data-val="4"></i>
                                                <i class="fa-solid fa-star rating__star rating__star--gold" data-val="5"></i>
                                            </div>
                                        </div>

                                        <c:if test="${param.cmt_err eq 'empty'}">
                                            <p style="color: red; font-size: 1.4rem; margin-bottom: 8px;">
                                                ⚠️ Vui lòng nhập nội dung đánh giá trước khi gửi!
                                            </p>
                                        </c:if>

                                        <textarea class="product-comment__input" name="comment" id="new_comment" rows="4"
                                                  placeholder="Nhập câu hỏi / Bình luận / Nhận xét tại đây" required></textarea>

                                        <div class="product-comment__upload">
                                            <label for="reviewImage" class="product-comment__upload-label" style="cursor: pointer;">
                                                <i class="fa-solid fa-camera" style="margin-right: 4px;"></i> Đính kèm hình ảnh sản phẩm:
                                            </label>

                                            <input
                                                    type="file"
                                                    id="reviewImage"
                                                    name="reviewImage"
                                                    class="product-comment__upload-input"
                                                    accept="image/*"
                                                    style="margin-top: 8px;"
                                            >
                                            <small style="display:block; margin-top:6px; color: #28a745; font-weight: 500;">
                                                ✓ Hình ảnh sẽ hiển thị công khai sau khi bạn gửi đánh giá thành công.
                                            </small>
                                        </div>

                                        <button type="submit" class="product-comment__btn btn btn--default-color">Gửi đánh giá</button>
                                    </form>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <div class="product-review">
                            <h2 class="section-title product-review__heading">Bình luận</h2>

                            <c:if test="${empty reviews}">
                                <p style="margin:12px 0;">Chưa có đánh giá nào cho sản phẩm này.</p>
                            </c:if>

                            <c:forEach var="rv" items="${reviews}">
                                <section class="product-review__item">

                                    <figure class="product-review__avatar">
                                        <c:choose>
                                            <c:when test="${not empty rv.authorAvatar}">
                                                <img class="avatar" src="${pageContext.request.contextPath}/assets/img/avatars/${rv.authorAvatar}" alt="Avatar">
                                            </c:when>

                                            <c:otherwise>
                                                <img class="navbar-user__img avatar"
                                                     src="data:image/png;base64,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"
                                                     alt="Default Avatar">
                                            </c:otherwise>
                                        </c:choose>
                                    </figure>

                                    <article class="product-review__content-wrapper">
                                        <h3 class="product-review__author">${rv.authorName}</h3>

                                        <div class="rating">
                                            <c:forEach var="i" begin="1" end="5">
                                                <i class="fa-solid fa-star rating__star ${i <= rv.rating ? 'rating__star--gold' : ''}"></i>
                                            </c:forEach>
                                        </div>

                                        <p class="product-review__text">${rv.comment}</p>

                                        <c:if test="${not empty rv.image}">
                                            <div class="product-review__image-wrapper" style="margin-top: 10px;">
                                                <img src="${pageContext.request.contextPath}/uploads/${rv.image}"
                                                     alt="Ảnh đánh giá"
                                                     style="max-width: 150px; height: auto; border-radius: 4px; border: 1px solid #ddd; object-fit: cover; cursor: pointer;">
                                            </div>
                                        </c:if>

                                        <div class="product-review__info">
                                            <time class="product-review__date">${rv.createdAt}</time>
                                        </div>
                                    </article>
                                </section>
                            </c:forEach>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <!-- Footer -->
    <jsp:include page="/common/footer.jsp" />
</body>

<script>
    document.addEventListener("DOMContentLoaded", function() {
        const quantityContainers = document.querySelectorAll(".content-quantity");

        quantityContainers.forEach(container => {
            const minusBtn = container.querySelector(".content-quantity__btn:first-child");
            const plusBtn = container.querySelector(".content-quantity__btn:last-child");
            const numberSpan = container.querySelector(".content-quantity__number");

            let quantity = parseInt(numberSpan.textContent);

            // Hàm update nút disable
            const updateButtons = () => {
                minusBtn.classList.toggle("content-quantity__btn--disable", quantity <= 1);
            }

            // Click +
            plusBtn.addEventListener("click", () => {
                quantity++;
                numberSpan.textContent = quantity;
                updateButtons();
            });

            // Click -
            minusBtn.addEventListener("click", () => {
                if (quantity > 1) {
                    quantity--;
                    numberSpan.textContent = quantity;
                    updateButtons();
                }
            });

            updateButtons(); // khởi tạo trạng thái nút
        });
    });

    //
    function getCurrentQty() {
        const el = document.querySelector(".content-quantity__number");
        const q = el ? parseInt(el.textContent.trim()) : 1;
        return (isNaN(q) || q <= 0) ? 1 : q;
    }

    //
    function showToast(msg) {
      let t = document.getElementById('toast-add-cart');
      if (!t) {
          t = document.createElement('div');
          t.id = 'toast-add-cart';
          t.style.position = 'fixed';
          t.style.right = '20px';
          t.style.bottom = '20px';
          t.style.padding = '12px 16px';
          t.style.background = '#333';
          t.style.color = '#fff';
          t.style.borderRadius = '10px';
          t.style.zIndex = '99999';
          t.style.opacity = '0';
          t.style.transition = 'opacity .2s ease';
          document.body.appendChild(t);
      }
        t.textContent = msg;
        t.style.opacity = '1';
        clearTimeout(window.__toastTimer);
        window.__toastTimer = setTimeout(() => t.style.opacity = '0', 1200);
    }

    //
    function addToCart(productId) {
        const contextPath = '${pageContext.request.contextPath}';
        // lấy số lượng đã chọn
        const qty = getCurrentQty();

        fetch(contextPath + '/add-cart', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
                'X-Requested-With': 'XMLHttpRequest' //
            },
            body: new URLSearchParams({
                productId: productId,
                quantity: qty,
                ajax: '1' // flag
            })
        })
            .then(res => {
                if (res.status === 401) {
                    alert("Vui lòng đăng nhập để thêm vào giỏ hàng!");
                    // Lấy đường dẫn hiện tại, /product?id=2
                    const currentUrl = window.location.pathname.replace(contextPath, '') + window.location.search;
                    window.location.href = contextPath + '/login?redirect=' + encodeURIComponent(currentUrl);
                    return null;
                }
                return res.json();
            })
            .then(data => {
                if (!data) return;

                if (data.status === 'success') {
                    if (window.applyMiniCartUpdate) window.applyMiniCartUpdate(data);

                    showToast("Đã thêm vào giỏ hàng!");
                } else if(data.status === 'error') {
                    alert(data.message);
                }
            })
            .catch(err => {
                console.error("Lỗi addToCart:", err);
                alert("Không thể kết nối đến máy chủ!");
            });
    }

    // xử lý nút mua ngay
    function buyNow(productId) {
        const contextPath = '${pageContext.request.contextPath}';
        const qty = getCurrentQty();

        // đảm bảo sản phẩm đã được add vào cart
        fetch(contextPath + '/add-cart', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
                'X-Requested-With': 'XMLHttpRequest'
            },
            body: new URLSearchParams({
                productId: productId,
                quantity: qty,
                ajax: '1'
            })
        })
            .then(res => {
                if (res.status === 401) {
                    alert("Vui lòng đăng nhập để mua ngay!");
                    const checkoutAction = '/checkout?ids=' + productId + '&qty=' + qty;
                    window.location.href = contextPath + '/login?redirect=' + encodeURIComponent(checkoutAction);
                    return null;
                }
                return res.json();
            })
            .then(data => {
                if(!data) return;

                if (data.status === 'success') {
                    const el = document.querySelector('#headerCartQty');
                    if (el) el.innerText = data.cartQty;

                    // checkout chỉ 1 sản phẩm
                    window.location.href = contextPath + '/checkout?ids=' + productId + '&qty=' + qty;
                } else if (data.status === 'error') {
                    alert(data.message);
                }
            })
            .catch(err => console.error("Lỗi buyNow:", err));
    }
</script>

<script>
    (function () {
        const stars = document.querySelectorAll('#ratingStars .rating__star');
        const input = document.getElementById('ratingValue');

        // vẽ lại màu sao khi người dùng chọn lại
        function paint(val) {
            stars.forEach(s => {
                const v = Number(s.dataset.val);
                if (v <= val) s.classList.add('rating__star--gold');
                else s.classList.remove('rating__star--gold');
            });
        }

        stars.forEach(s => {
            s.addEventListener('click', () => {
            const val = Number(s.dataset.val);
            input.value = val;
            paint(val);
        });

        s.addEventListener('mouseenter', () => paint(Number(s.dataset.val)));
        });

      const wrap = document.getElementById('ratingStars');
      wrap.addEventListener('mouseleave', () => paint(Number(input.value) || 5));

      paint(Number(input.value) || 5);
    })();
</script>

<!-- Link JS -->
<script src="assets/js/script.js"></script>

</html>