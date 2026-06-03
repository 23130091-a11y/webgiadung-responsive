<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="a" uri="http://java.sun.com/jsp/jstl/core" %>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tìm kiếm sản phẩm</title>

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
    <link rel="stylesheet" href="assets/css/search.css?v=1">

    <!-- Link favicon -->
</head>

<body>
    <!-- header -->
    <%@ include file="/common/header.jsp" %>

    <main class="main" style="height: 5000px; background-color: #d9d9d9">
        <div class="search-filter">
            <div class="grid wide">
                <div class="row small-gutter">
                    <div class="col l-2 m-0 c-0">
                        <section class="search-filter__inner">
                            <form id="filter-form">
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
                                                                <a class="category-menu__link category-filter ${child.id == selectedCategoryId ? 'active' : ''}"
                                                                   data-id="${child.id}" href="#!">
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

                                <div class="search-filter__header">
                                    <i class="search-filter__icon fa-solid fa-filter"></i>
                                    <h2 class="search-filter__heading">Bộ lọc tìm kiếm</h2>
                                </div>

                                <article class="search-filter__category">
                                    <h3 class="search-filter__title">Theo thương hiệu</h3>
                                    <div class="search-filter__options">
                                        <c:forEach items="${allBrands}" var="brand">
                                            <div class="search-filter__item">
                                                <input hidden type="checkbox" name="brands" class="filter-checkbox" id="brand-${brand.id}" value="${brand.name}" />
                                                <label class="search-filter__checkbox" for="brand-${brand.id}">${brand.name}</label>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </article>

                                <article class="search-filter__category">
                                    <h3 class="search-filter__title">Khoảng giá</h3>
                                    <div class="search-filter__options">
                                        <div class="search-filter__item">
                                            <input hidden type="checkbox" id="price-all" value="all" />
                                            <label class="search-filter__checkbox" for="price-all">Tất cả</label>
                                        </div>

                                        <div class="search-filter__item">
                                            <input hidden type="checkbox" name="priceRanges" class="filter-checkbox" id="price-under100" value="0-100000" />
                                            <label class="search-filter__checkbox" for="price-under100">Dưới 100k</label>
                                        </div>

                                        <div class="search-filter__item">
                                            <input hidden type="checkbox" name="priceRanges" class="filter-checkbox" id="price-100-200" value="100000-200000" />
                                            <label class="search-filter__checkbox" for="price-100-200">100k - 200k</label>
                                        </div>

                                        <div class="search-filter__item">
                                            <input hidden type="checkbox" name="priceRanges" class="filter-checkbox" id="price-200-500" value="200000-500000" />
                                            <label class="search-filter__checkbox" for="price-200-500">200k - 500k</label>
                                        </div>

                                        <div class="search-filter__item">
                                            <input hidden type="checkbox" name="priceRanges" class="filter-checkbox" id="price-500-1000" value="500000-1000000" />
                                            <label class="search-filter__checkbox" for="price-500-1000">500k - 1 triệu</label>
                                        </div>

                                        <div class="search-filter__item">
                                            <input hidden type="checkbox" name="priceRanges" class="filter-checkbox" id="price-over1000" value="1000000-999999999" />
                                            <label class="search-filter__checkbox" for="price-over1000">Trên 1 triệu</label>
                                        </div>
                                    </div>
                                </article>

                                <article class="search-filter__category">
                                    <h3 class="search-filter__title">Đánh giá</h3>

                                    <div class="search-filter-reviews">
                                        <input type="radio" name="rating" value="5" id="star5" class="search-filter-reviews__input filter-rating-radio"
                                        ${selectedRating == '5' ? 'checked' : ''} />
                                        <label for="star5" class="search-filter-reviews__content">
                                            <div class="rating">
                                                <i class="fa-solid fa-star rating__star rating__star--gold"></i>
                                                <i class="fa-solid fa-star rating__star rating__star--gold"></i>
                                                <i class="fa-solid fa-star rating__star rating__star--gold"></i>
                                                <i class="fa-solid fa-star rating__star rating__star--gold"></i>
                                                <i class="fa-solid fa-star rating__star rating__star--gold"></i>
                                                <span class="rating__label" style="visibility: hidden;">Trở lên</span>
                                            </div>
                                        </label>
                                    </div>

                                    <div class="search-filter-reviews">
                                        <input type="radio" name="rating" value="4" id="star4" class="search-filter-reviews__input filter-rating-radio"
                                        ${selectedRating == '4' ? 'checked' : ''} />
                                        <label for="star4" class="search-filter-reviews__content">
                                            <div class="rating">
                                                <i class="fa-solid fa-star rating__star rating__star--gold"></i>
                                                <i class="fa-solid fa-star rating__star rating__star--gold"></i>
                                                <i class="fa-solid fa-star rating__star rating__star--gold"></i>
                                                <i class="fa-solid fa-star rating__star rating__star--gold"></i>
                                                <i class="fa-solid fa-star rating__star"></i>
                                                <span class="rating__label">Trở lên</span>
                                            </div>
                                        </label>
                                    </div>

                                    <div class="search-filter-reviews">
                                        <input type="radio" name="rating" value="3" id="star3" class="search-filter-reviews__input filter-rating-radio"
                                        ${selectedRating == '3' ? 'checked' : ''} />
                                        <label for="star3" class="search-filter-reviews__content">
                                            <div class="rating">
                                                <i class="fa-solid fa-star rating__star rating__star--gold"></i>
                                                <i class="fa-solid fa-star rating__star rating__star--gold"></i>
                                                <i class="fa-solid fa-star rating__star rating__star--gold"></i>
                                                <i class="fa-solid fa-star rating__star"></i>
                                                <i class="fa-solid fa-star rating__star"></i>
                                                <span class="rating__label">Trở lên</span>
                                            </div>
                                        </label>
                                    </div>

                                    <div class="search-filter-reviews">
                                        <input type="radio" name="rating" value="2" id="star2" class="search-filter-reviews__input filter-rating-radio"
                                        ${selectedRating == '2' ? 'checked' : ''} />
                                        <label for="star2" class="search-filter-reviews__content">
                                            <div class="rating">
                                                <i class="fa-solid fa-star rating__star rating__star--gold"></i>
                                                <i class="fa-solid fa-star rating__star rating__star--gold"></i>
                                                <i class="fa-solid fa-star rating__star"></i>
                                                <i class="fa-solid fa-star rating__star"></i>
                                                <i class="fa-solid fa-star rating__star"></i>
                                                <span class="rating__label">Trở lên</span>
                                            </div>
                                        </label>
                                    </div>

                                    <div class="search-filter-reviews">
                                        <input type="radio" name="rating" value="1" id="star1" class="search-filter-reviews__input filter-rating-radio"
                                        ${selectedRating == '1' ? 'checked' : ''} />
                                        <label for="star1" class="search-filter-reviews__content">
                                            <div class="rating">
                                                <i class="fa-solid fa-star rating__star rating__star--gold"></i>
                                                <i class="fa-solid fa-star rating__star"></i>
                                                <i class="fa-solid fa-star rating__star"></i>
                                                <i class="fa-solid fa-star rating__star"></i>
                                                <i class="fa-solid fa-star rating__star"></i>
                                                <span class="rating__label">Trở lên</span>
                                            </div>
                                        </label>
                                    </div>
                                </article>
                            </form>
                        </section>
                    </div>

                    <div class="col l-10 m-12 c-12">
                        <section class="product-search-list">
                            <div class="search-header">
                                <p>
                                    <i class="fa-solid fa-magnifying-glass"></i>
                                    <c:choose>
                                        <c:when test="${isNoResult}">
                                            Rất tiếc, không tìm thấy sản phẩm nào phù hợp
                                        </c:when>

                                        <c:otherwise>
                                            <c:if test="${not empty keyword}">
                                                Kết quả cho: <span class="word-search">"${keyword}"</span>
                                            </c:if>

                                            <c:if test="${not empty keyword && not empty category}">
                                                <span> thuộc </span>
                                            </c:if>

                                            <c:if test="${not empty category}">
                                                Danh mục: <span class="word-search">${category.name}</span>
                                            </c:if>
                                        </c:otherwise>
                                    </c:choose>
                                </p>
                            </div>

                            <div class="row-list row small-gutter" id="content-products">
                                <c:choose>
                                    <c:when test="${empty products}">
                                        <div class="no-result-container" style="text-align: center; padding: 40px 20px;">
                                            <div class="recommendation-section">
                                                <h2 class="recommendation__title" style="text-align: left; margin-bottom: 20px; color: var(--primary-color); border-bottom: 2px solid;">
                                                    CÓ THỂ BẠN SẼ THÍCH
                                                </h2>

                                                <div class="row-list row small-gutter">
                                                    <c:forEach items="${recommendations}" var="p">
                                                        <div class="col l-2-4 m-4 c-6">
                                                            <div class="product-card">
                                                                <a href="product?id=${p.id}">
                                                                    <img src="${pageContext.request.contextPath}/assets/img/products/${p.image}" alt="${p.name}">
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
                                                                    <button class="fav-btn ${p.favorite ? 'active' : ''}">
                                                                        <i class="${p.favorite ? 'fa-solid' : 'fa-regular'} fa-heart"></i> Yêu thích
                                                                    </button>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </c:forEach>
                                                </div>
                                            </div>
                                        </div>
                                    </c:when>

                                    <c:otherwise>
                                        <c:forEach items="${products}" var="p">
                                            <div class="col l-2-4 m-4 c-6">
                                                <div class="product-card">
                                                    <a href="product?id=${p.id}">
                                                        <img src="${pageContext.request.contextPath}/assets/img/products/${p.image}" alt="${p.name}">
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
                                                        <button class="fav-btn ${p.favorite ? 'active' : ''}">
                                                            <i class="${p.favorite ? 'fa-solid' : 'fa-regular'} fa-heart"></i> Yêu thích
                                                        </button>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>

                            </div>
                        </section>
                    </div>
                </div>
            </div>
        </div>
    </main>
</body>

<!-- Link JS -->
<script src="assets/js/script.js"></script>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<script>
    $(document).ready(function() {
        let currentCategoryId = new URLSearchParams(window.location.search).get('categoryId') || "";

        $(document).on('click', '.category-filter', function (e){
            e.preventDefault();
            currentCategoryId = $(this).data('id');

            $('.category-filter').removeClass('active');
            $(this).addClass('active');

            searchFilter();
        });

        $(document).on('change', '.filter-checkbox', function() {
            searchFilter();
        });

        $(document).on('change', '.filter-rating-radio', function() {
            searchFilter();
        });

        // hàm lọc
        function searchFilter() {
            let brands = [];
            $('input[name="brands"]:checked').each(function() {
                brands.push($(this).val());
            });

            let priceRanges = [];
            $('input[name="priceRanges"]:checked').each(function() {
                priceRanges.push($(this).val());
            });

            let rating = $('input[name="rating"]:checked').val() || "";

            const urlParams = new URLSearchParams(window.location.search);
            let keyword = urlParams.get('keyword') || "";

            $.ajax({
                url: "search-product",
                type: "GET",
                data: {
                    keyword: keyword,
                    categoryId: currentCategoryId,
                    'brands[]': brands,
                    'priceRanges[]': priceRanges,
                    'rating': rating
                },
                beforeSend: function() {
                    $("#content-products").stop(true, true).css("opacity", "0.5");
                },
                success: function(data) {
                    let $htmlResponse = $(data);

                    let newList = $htmlResponse.find("#content-products").html();

                    let newHeader = $htmlResponse.find(".search-header").html();

                    $("#content-products").fadeOut(100, function() {
                        $(this).html(newList).fadeIn(100).css("opacity", "1");
                    });

                    if (newHeader) {
                        $(".search-header").html(newHeader);
                    }

                    let params = {
                        keyword: keyword,
                        categoryId: currentCategoryId,
                        brands: brands,
                        priceRanges: priceRanges
                    };

                    if(rating) {
                        params.rating = rating;
                    }

                    let newUrl = "search-product?" + $.param(params);
                    window.history.pushState({}, "", newUrl);
                },
                error: function(xhr) {
                    $("#content-products").css("opacity", "1");
                    console.error("Lỗi AJAX: " + xhr.status + " " + xhr.statusText);
                }
            });
        }
    });
</script>
<script>
    $(document).ready(function() {
        let currentCategoryId = new URLSearchParams(window.location.search).get('categoryId') || "";

        $(document).on('click', '.category-filter', function (e){
            e.preventDefault();
            currentCategoryId = $(this).data('id');

            $('.category-filter').removeClass('active');
            $(this).addClass('active');

            searchFilter();
        });

        $(document).on('change', '.filter-checkbox', function() {
            searchFilter();
        });

        $(document).on('change', '.filter-rating-radio', function() {
            searchFilter();
        });

        $(document).on('click', '.fav-btn', function (e) {
            e.preventDefault();

            const currentButton = $(this);
            const productId = currentButton.closest('.product-card').find('a').attr('href').split('id=')[1];
            const heartIcon = currentButton.find('i');
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
                            currentButton.addClass('active');
                            heartIcon.removeClass('fa-regular').addClass('fa-solid');
                        } else if (data.action === 'removed') {
                            currentButton.removeClass('active');
                            heartIcon.removeClass('fa-solid').addClass('fa-regular');
                        }
                    } else {
                        alert(data.message || "Có lỗi xảy ra, vui lòng thử lại!");
                    }
                })
                .catch(error => {
                    console.error("[JS ERROR] Fetch Ajax error:", error);
                });
        });

        function searchFilter() {
            let brands = [];
            $('input[name="brands"]:checked').each(function() {
                brands.push($(this).val());
            });

            let priceRanges = [];
            $('input[name="priceRanges"]:checked').each(function() {
                priceRanges.push($(this).val());
            });

            let rating = $('input[name="rating"]:checked').val() || "";

            const urlParams = new URLSearchParams(window.location.search);
            let keyword = urlParams.get('keyword') || "";

            $.ajax({
                url: "search-product",
                type: "GET",
                data: {
                    keyword: keyword,
                    categoryId: currentCategoryId,
                    'brands[]': brands,
                    'priceRanges[]': priceRanges,
                    'rating': rating
                },
                beforeSend: function() {
                    $("#content-products").stop(true, true).css("opacity", "0.5");
                },
                success: function(data) {
                    let $htmlResponse = $(data);
                    let newList = $htmlResponse.find("#content-products").html();
                    let newHeader = $htmlResponse.find(".search-header").html();

                    $("#content-products").fadeOut(100, function() {
                        $(this).html(newList).fadeIn(100).css("opacity", "1");
                    });

                    if (newHeader) {
                        $(".search-header").html(newHeader);
                    }

                    let params = {
                        keyword: keyword,
                        categoryId: currentCategoryId,
                        brands: brands,
                        priceRanges: priceRanges
                    };

                    if(rating) {
                        params.rating = rating;
                    }

                    let newUrl = "search-product?" + $.param(params);
                    window.history.pushState({}, "", newUrl);
                },
                error: function(xhr) {
                    $("#content-products").css("opacity", "1");
                    console.error("Lỗi AJAX: " + xhr.status + " " + xhr.statusText);
                }
            });
        }
    });
</script>
</html>