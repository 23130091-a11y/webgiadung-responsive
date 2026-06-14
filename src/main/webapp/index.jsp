<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!DOCTYPE html>
<html lang="en">
<c:out value="${blog.content}" escapeXml="false"/>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>WebGiaDung</title>

  <!-- Link favicon -->
  <link rel="apple-touch-icon" sizes="57x57" href="assets/favicon/apple-icon-57x57.png">
  <link rel="apple-touch-icon" sizes="60x60" href="assets/favicon/apple-icon-60x60.png">
  <link rel="apple-touch-icon" sizes="72x72" href="assets/favicon/apple-icon-72x72.png">
  <link rel="apple-touch-icon" sizes="76x76" href="assets/favicon/apple-icon-76x76.png">
  <link rel="apple-touch-icon" sizes="114x114" href="assets/favicon/apple-icon-114x114.png">
  <link rel="apple-touch-icon" sizes="120x120" href="assets/favicon/apple-icon-120x120.png">
  <link rel="apple-touch-icon" sizes="144x144" href="assets/favicon/apple-icon-144x144.png">
  <link rel="apple-touch-icon" sizes="152x152" href="assets/favicon/apple-icon-152x152.png">
  <link rel="apple-touch-icon" sizes="180x180" href="assets/favicon/apple-icon-180x180.png">
  <link rel="icon" type="image/png" sizes="192x192"  href="assets/favicon/android-icon-192x192.png">
  <link rel="icon" type="image/png" sizes="32x32" href="assets/favicon/favicon-32x32.png">
  <link rel="icon" type="image/png" sizes="96x96" href="assets/favicon/favicon-96x96.png">
  <link rel="icon" type="image/png" sizes="16x16" href="assets/favicon/favicon-16x16.png">
  <link rel="manifest" href="assets/favicon/manifest.json">
  <meta name="msapplication-TileColor" content="#ffffff">
  <meta name="msapplication-TileImage" content="./assets/favicon/ms-icon-144x144.png">
  <meta name="theme-color" content="#ffffff">

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
</head>

<body>
<!-- header -->
<%@ include file="/common/header.jsp" %>

<main class="main" style="background-color: #d9d9d9">
  <div class="cta">
    <div class="grid wide">
      <div class="row small-gutter">
        <div class="col l-2 m-0 c-0">
          <nav class="category">
            <h2 class="category__heading">Danh mục</h2>
            <ul class="category__list">
              <c:forEach items="${parentCategories}" var="parent">
                <li class="category__item category__item--active">
                  <a href="#!" class="category__link">
                      ${parent.name}
                  </a>
                  <c:if test="${not empty parent.children}">
                    <ul class="category-menu">
                      <c:forEach items="${parent.children}" var="child">
                        <li class="category-menu__item">
                          <a class="category-menu__link"
                             href="${pageContext.request.contextPath}/search-product?categoryId=${child.id}">
                              ${child.name}
                          </a>
                        </li>
                      </c:forEach>
                    </ul>
                  </c:if>
                </li>
              </c:forEach>
            </ul>
          </nav>
        </div>
        <div class="col l-10 m-12 c-12">
          <div class="navigation">
            <a href="#!" class="navigation__link navigation__link--active">Trang chủ</a>
            <i class="fa-solid fa-chevron-right navigation__icon"></i>
          </div>
          <figure class="hero">
            <div id="slider">
              <c:forEach var="slide" items="${slides}">
                <a class="slide"
                   href="view-slide?id=${slide.id}"
                   style="background-image: url('${slide.banner}')">
                </a>
              </c:forEach>
            </div>
          </figure>
        </div>
      </div>
    </div>
  </div>

  <div class="main_product">
    <div class="grid wide">
      <!-- Sản phẩm vừa xem -->
      <c:if test="${not empty historyProducts}">
        <section class="featured history-section">
          <div class="container">
            <h2 class="section-title">Sản phẩm bạn đã xem</h2>
            <div class="product-list-wrapper">
              <button class="scroll-btn left"><i class="fa-solid fa-chevron-left"></i></button>
              <button class="scroll-btn right"><i class="fa-solid fa-chevron-right"></i></button>

              <div class="product-list">
                <c:forEach items="${historyProducts}" var="p">
                  <div class="product-card">
                    <a href="product?id=${p.id}">
                      <c:choose>
                        <c:when test="${fn:startsWith(p.image, 'assets/img/')}">
                          <img src="${pageContext.request.contextPath}/${p.image}" alt="${p.name}">
                        </c:when>
                        <c:otherwise>
                          <img src="${pageContext.request.contextPath}/assets/img/products/${p.image}" alt="${p.name}">
                        </c:otherwise>
                      </c:choose>
                    </a>

                    <a href="product?id=${p.id}">
                      <p>${p.name}</p>
                    </a>

                    <div class="price-discount">
                      <c:if test="${p.isDiscounted}">
                        <div class="price-top">
                          <span class="old-price">
                            <fmt:formatNumber value="${p.firstPrice}" pattern="#,###"/>đ
                          </span>

                          <div class="discount-badge">
                              <%-- Kiểm tra loại giảm giá để hiển thị text phù hợp --%>
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
                        <button class="fav-btn ${p.favorite ? 'active' : ''}" data-product-id="${p.id}">
                            <i class="${p.favorite ? 'fa-solid' : 'fa-regular'} fa-heart"></i> Yêu thích
                        </button>
                    </div>
                  </div>
                </c:forEach>
              </div>
            </div>
          </div>
        </section>
      </c:if>

      <!-- Sản phẩm nổi bật -->
      <section class="featured">
        <h2>Sản phẩm nổi bật</h2>
        <button class="scroll-btn left"><i class="fa-solid fa-chevron-left"></i></button>
        <button class="scroll-btn right"><i class="fa-solid fa-chevron-right"></i></button>
        <div class="product-list">
          <c:forEach items="${featuredProducts}" var="p">
            <div class="product-card">
              <a href="product?id=${p.id}">
                <c:choose>
                  <c:when test="${fn:startsWith(p.image, 'assets/img/')}">
                    <img src="${pageContext.request.contextPath}/${p.image}" alt="${p.name}">
                  </c:when>
                  <c:otherwise>
                    <img src="${pageContext.request.contextPath}/assets/img/products/${p.image}" alt="${p.name}">
                  </c:otherwise>
                </c:choose>
              </a>

              <a href="product?id=${p.id}">
                <p>${p.name}</p>
              </a>

              <div class="price-discount">
                <c:if test="${p.isDiscounted}">
                  <div class="price-top">
                    <span class="old-price">
                        <fmt:formatNumber value="${p.firstPrice}" pattern="#,###"/>đ
                      </span>

                    <div class="discount-badge">
                        <%-- Kiểm tra loại giảm giá để hiển thị text phù hợp --%>
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
                  <button class="fav-btn ${p.favorite ? 'active' : ''}" data-product-id="${p.id}">
                      <i class="${p.favorite ? 'fa-solid' : 'fa-regular'} fa-heart"></i> Yêu thích
                  </button>
              </div>
            </div>
          </c:forEach>
        </div>
      </section>

      <!-- Khuyến mãi Đặc biệt-->
      <section class="featured">
        <h2>Khuyến mãi đặc biệt</h2>
        <button class="scroll-btn left"><i class="fa-solid fa-chevron-left"></i></button>
        <button class="scroll-btn right"><i class="fa-solid fa-chevron-right"></i></button>
        <div class="product-list">
          <c:forEach items="${promotionProducts}" var="p">
            <div class="product-card">
              <a href="product?id=${p.id}">
                <c:choose>
                  <c:when test="${fn:startsWith(p.image, 'assets/img/')}">
                    <img src="${pageContext.request.contextPath}/${p.image}" alt="${p.name}">
                  </c:when>
                  <c:otherwise>
                    <img src="${pageContext.request.contextPath}/assets/img/products/${p.image}" alt="${p.name}">
                  </c:otherwise>
                </c:choose>
              </a>

              <a href="product?id=${p.id}">
                <p>${p.name}</p>
              </a>

              <div class="price-discount">
                <c:if test="${p.isDiscounted}">
                  <div class="price-top">
                    <span class="old-price">
                        <fmt:formatNumber value="${p.firstPrice}" pattern="#,###"/>đ
                      </span>

                    <div class="discount-badge">
                        <%-- Kiểm tra loại giảm giá để hiển thị text phù hợp --%>
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
                <div class="star"><i class="fa-solid fa-star"></i>${p.ratingAvg}</div>
                  <button class="fav-btn ${p.favorite ? 'active' : ''}" data-product-id="${p.id}">
                      <i class="${p.favorite ? 'fa-solid' : 'fa-regular'} fa-heart"></i> Yêu thích
                  </button>
              </div>
            </div>
          </c:forEach>
        </div>
      </section>

      <!-- Gợi ý cho bạn -->
      <%-- Chỉ hiển thị Section nếu danh sách không rỗng --%>
      <c:if test="${not empty suggestedProducts}">
        <section class="featured">
          <h2>Gợi ý cho bạn</h2>
          <button class="scroll-btn left"><i class="fa-solid fa-chevron-left"></i></button>
          <button class="scroll-btn right"><i class="fa-solid fa-chevron-right"></i></button>
          <div class="product-list">
            <c:forEach items="${suggestedProducts}" var="p">
              <div class="product-card">
                <a href="product?id=${p.id}">
                  <c:choose>
                    <c:when test="${fn:startsWith(p.image, 'assets/img/')}">
                      <img src="${pageContext.request.contextPath}/${p.image}" alt="${p.name}">
                    </c:when>
                    <c:otherwise>
                      <img src="${pageContext.request.contextPath}/assets/img/products/${p.image}" alt="${p.name}">
                    </c:otherwise>
                  </c:choose>
                </a>

                <a href="product?id=${p.id}">
                  <p>${p.name}</p>
                </a>

                <div class="price-discount">
                  <c:if test="${p.isDiscounted}">
                    <div class="price-top">
                    <span class="old-price">
                        <fmt:formatNumber value="${p.firstPrice}" pattern="#,###"/>đ
                      </span>

                      <div class="discount-badge">
                          <%-- Kiểm tra loại giảm giá để hiển thị text phù hợp --%>
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
                    <button class="fav-btn ${p.favorite ? 'active' : ''}" data-product-id="${p.id}">
                        <i class="${p.favorite ? 'fa-solid' : 'fa-regular'} fa-heart"></i> Yêu thích
                    </button>
                </div>
              </div>
            </c:forEach>
          </div>
        </section>
      </c:if>

      <!-- Sản phẩm giới hạn -->
      <section class="featured">
        <h2>Sản phẩm giới hạn</h2>
        <button class="scroll-btn left"><i class="fa-solid fa-chevron-left"></i></button>
        <button class="scroll-btn right"><i class="fa-solid fa-chevron-right"></i></button>
        <div class="product-list">
          <c:forEach items="${limitedProducts}" var="p">
            <div class="product-card">
              <a href="product?id=${p.id}">
                <c:choose>
                  <c:when test="${fn:startsWith(p.image, 'assets/img/')}">
                    <img src="${pageContext.request.contextPath}/${p.image}" alt="${p.name}">
                  </c:when>
                  <c:otherwise>
                    <img src="${pageContext.request.contextPath}/assets/img/products/${p.image}" alt="${p.name}">
                  </c:otherwise>
                </c:choose>
              </a>

              <a href="product?id=${p.id}">
                <p>${p.name}</p>
              </a>

              <div class="price-discount">
                <c:if test="${p.isDiscounted}">
                  <div class="price-top">
                    <span class="old-price">
                        <fmt:formatNumber value="${p.firstPrice}" pattern="#,###"/>đ
                      </span>

                    <div class="discount-badge">
                        <%-- Kiểm tra loại giảm giá để hiển thị text phù hợp --%>
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
                  <button class="fav-btn ${p.favorite ? 'active' : ''}" data-product-id="${p.id}">
                      <i class="${p.favorite ? 'fa-solid' : 'fa-regular'} fa-heart"></i> Yêu thích
                  </button>
              </div>
            </div>
          </c:forEach>
        </div>
      </section>

    </div>
  </div>

<%--  <section class="blog">--%>
<%--    <div class="grid wide">--%>
<%--      <div class="blog__inner">--%>
<%--        <div class="blog__header">--%>
<%--          <h2 class="blog__heading">Blog tin tức</h2>--%>
<%--          <a href="#!" class="blog__view-all">Xem tất cả</a>--%>
<%--        </div>--%>
<%--        <div class="blog__list row small-gutter ">--%>
<%--          <c:choose>--%>
<%--            <c:when test="${not empty latestBlogs}">--%>
<%--              <c:forEach items="${latestBlogs}" var="b">--%>
<%--                <div class="col c-3 m-3 l-3">--%>
<%--                  <article class="blog-item">--%>
<%--                    <a href="blog-detail?id=${b.id}" class="blog-item__link">--%>
<%--                      <img src="${b.thumbnail}" alt="${b.title}" class="blog-item__img">--%>
<%--                    </a>--%>
<%--                    <div class="blog-item__content">--%>
<%--                      <h3>--%>
<%--                        <a class="blog-item__title" href="blog-detail?id=${b.id}">--%>
<%--                            ${b.title}--%>
<%--                        </a>--%>
<%--                      </h3>--%>
<%--                      <p class="blog-item__desc">--%>
<%--                          ${b.summary}--%>
<%--                      </p>--%>
<%--                      <div class="blog-item__meta">--%>
<%--                        <span class="blog-item__time">--%>
<%--                          <i class="fa-regular fa-clock"></i>--%>
<%--                          ${b.createdAt}--%>
<%--                        </span>--%>
<%--                      </div>--%>
<%--                    </div>--%>
<%--                  </article>--%>
<%--                </div>--%>
<%--              </c:forEach>--%>
<%--            </c:when>--%>

<%--            <c:otherwise>--%>
<%--              <!-- nếu DB chưa có blog thì giữ hard-code 4 bài cũ ở đây -->--%>
<%--            </c:otherwise>--%>
<%--          </c:choose>--%>
<%--        </div>--%>
<%--      </div>--%>
<%--    </div>--%>
<%--  </section>--%>
</main>
<!-- Footer -->
<jsp:include page="/common/footer.jsp" />
</body>

<!-- Link JS -->
<script src="assets/js/script.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const favBtns = document.querySelectorAll('.fav-btn');

        console.log("[JS CHECK] Found total favorite buttons: " + favBtns.length);

        if (favBtns.length > 0) {
            favBtns.forEach(favBtn => {
                favBtn.addEventListener('click', function (e) {
                    e.preventDefault();

                    const productId = this.getAttribute('data-product-id');
                    const heartIcon = this.querySelector('i');
                    const currentButton = this;
                    const contextPath = '${pageContext.request.contextPath}';

                    console.log("[JS CLICK] Clicked! Product ID = " + productId);

                    const params = new URLSearchParams();
                    params.append('productId', productId);

                    fetch(contextPath + '/api/favorite/toggle', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded',
                        },
                        body: params.toString()
                    })
                        .then(response => {
                            console.log("[JS RESPONSE] Server response HTTP status: " + response.status);
                            if (response.status === 401) {
                                alert("Vui lòng đăng nhập để lưu sản phẩm yêu thích!");
                                window.location.href = contextPath + "/login";
                                throw new Error("Unauthorized");
                            }
                            if (!response.ok) {
                                throw new Error("System connection error");
                            }
                            return response.json();
                        })
                        .then(data => {
                            console.log("[JS DATA] Result from server:", data);
                            if (data.status === 'success') {
                                if (data.action === 'added') {
                                    currentButton.classList.add('active');
                                    heartIcon.className = 'fa-solid fa-heart';
                                } else if (data.action === 'removed') {
                                    currentButton.classList.remove('active');
                                    heartIcon.className = 'fa-regular fa-heart';
                                }
                            } else {
                                alert(data.message || "Có lỗi xảy ra, vui lòng thử lại!");
                            }
                        })
                        .catch(error => {
                            console.error("[JS ERROR] Fetch Ajax error:", error);
                        });
                });
            });
        }
    });
</script>
</html>