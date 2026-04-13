<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hướng Dẫn Vệ Sinh Máy Giặt - WebGiaDung</title>

    <link rel="stylesheet" href="assets/css/reset.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link
        href="https://fonts.googleapis.com/css2?family=Open+Sans:ital,wght@0,300..800;1,300..800;1,300..800;1,300..800&family=Poppins:ital,wght@0,300;0,400;0,500;0,600;0,700;1,300;1,400;1,500;1,600;1,700&display=swap"
        rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css"
        integrity="sha512-DTOQO9RWCH3ppGqcWaEA1BIZOC6xxalwEsw9c2QQeAIftl+Vegovlnee1c9QX4TctnWMn13TZye+giMm8e2LwA=="
        crossorigin="anonymous" referrerpolicy="no-referrer" />
    <link rel="stylesheet" href="assets/css/grid.css">
    <link rel="stylesheet" href="assets/css/base.css">
    <link rel="stylesheet" href="assets/css/style.css">
    <link rel="stylesheet" href="assets/css/blog.css">
</head>

<body>
    <header id="header" class="header">
        <div class="grid wide">
            <div class="header-top">
                <nav class="navbar">
                    <ul class="navbar__list">
                        <li class="navbar__item navbar__item--separate navbar__item--fade-qr">
                            Vào cửa hàng trên ứng dụng
                            <div class="navbar-qr">
                                <img src="assets/img/qr_code.jpg" alt="QR Code" class="navbar-qr__img">
                                <div class="navbar-qr__wrap">
                                    <a class="navbar-qr__link" href="#!">
                                        <img src="assets/img/googleplay.png" alt="Google Play"
                                             class="navbar-qr__media">
                                    </a>
                                    <a class="navbar-qr__link" href="#!">
                                        <img src="assets/img/appstore.png" alt="App store" class="navbar-qr__media">
                                    </a>
                                </div>
                            </div>
                        </li>
                        <li class="navbar__item">
                            <span class="navbar__item--no-pointer">Kết nối</span>
                            <a href="#!" class="navbar__item-icon-link">
                                <i class="navbar__item-symbol fa-brands fa-facebook"></i>
                            </a>
                            <a href="#!" class="navbar__item-icon-link">
                                <i class="navbar__item-symbol fa-brands fa-square-instagram"></i>
                            </a>
                        </li>
                    </ul>

                    <ul class="navbar__list">
                        <li class="navbar__item navbar__item--fade-notify">
                            <i class="navbar__item-symbol fa-regular fa-bell"></i>
                            <a href="#!" class="navbar__link">
                                Thông báo
                                <div class="navbar-notify navbar-notify--no-login">
                                    <img src="assets/img/no-login_img.png" alt="" class="navbar-notify__img">
                                    <span class="navbar-notify__message">Đăng nhập để xem thông báo</span>
                                </div>
                            </a>
                        </li>
                        <li class="navbar__item">
                            <i class="navbar__item-symbol fa-regular fa-circle-question"></i>
                            <a href="#!" class="navbar__link">Trợ giúp</a>
                        </li>
                        <c:if test="${empty sessionScope.USER_LOGIN}">
                            <li class="navbar__item navbar__item--strong-weight navbar__item--separate">
                                <a href="register.jsp" class="navbar__link">Đăng ký</a>
                            </li>

                            <li class="navbar__item navbar__item--strong-weight">
                                <a href="login.jsp" class="navbar__link">Đăng nhập</a>
                            </li>
                        </c:if>

                        <!-- Đã đăng nhập -->
                        <c:if test="${not empty sessionScope.USER_LOGIN}">
                            <li class="navbar__item navbar-user">
                                <img class="navbar-user__img"
                                     src="data:image/png;base64,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"
                                     alt="Avatar">

                                <span class="navbar-user__name">
                                        ${sessionScope.USER_LOGIN.name}
                                </span>

                                <ul class="navbar-user__menu">
                                    <li class="navbar-user__item">
                                        <a href="account.jsp#info" class="navbar-user__link">Tài khoản của tôi</a>
                                    </li>
                                    <li class="navbar-user__item">
                                        <a href="account.jsp#favorite-product" class="navbar-user__link">Yêu thích</a>
                                    </li>
                                    <li class="navbar-user__item">
                                        <a href="account.jsp#orders-all" class="navbar-user__link">Thông tin đơn hàng</a>
                                    </li>
                                    <li class="navbar-user__item navbar-user__item--separate">
                                        <a href="login.jsp" class="navbar-user__link">Đăng xuất</a>
                                    </li>
                                </ul>
                            </li>
                        </c:if>
                    </ul>
                </nav>
            </div>
        </div>
    </header>
    <main class="main" style="background-color: #d9d9d9">
        <div class="grid wide">
            <div class="row">
                <div class="col l-12 m-12 c-12">
                    <article class="blog-article">
                        <h1 class="blog-article__title">Hướng dẫn vệ sinh máy giặt đúng cách</h1>
                        <p class="blog-article__time">
                            <i class="fa-regular fa-clock"></i> 14/11/2025 • 10:30
                        </p>
                        <p class="blog-article__intro">
                            Máy giặt sử dụng lâu ngày không được vệ sinh đúng cách sẽ khiến máy giặt trở nên bẩn, bám
                            cặn, điều này vô tình làm cho quần áo khi giặt sẽ không còn sạch và có mùi khó chịu. Nếu máy
                            giặt nhà bạn có những dấu hiệu trên thì đã đến lúc để làm sạch máy giặt.
                        </p>

                        <img src="assets/img/maygiat1.jpg" alt="Thực hiện vệ sinh lồng máy giặt"
                             class="blog-article__img">

                        <h2 class="blog-article__subtitle">Bước 1: Làm sạch máy giặt</h2>
                        <p class="blog-article__content">
                            Để làm sạch trong lồng giặt kim loại, bạn cần dùng bột giặt được nghiền hoàn toàn.
                            <br>
                            Cách dùng:
                        </p>
                        <ul class="blog-article__list">
                            <li>Đổ bột giặt vào lồng giặt, sau đó chọn chu trình giặt với nước nóng để bột giặt tan hoàn
                                toàn trong lồng giặt.</li>
                            <li>Bấm nút khởi động và ngâm lồng giặt trong khoảng 15 – 20 phút.</li>
                            <li>Đổ hỗn hợp giặt vào và bấm nút khởi động máy lại như bình thường.</li>
                            <li>Sau khi quá trình giặt kết thúc, bạn dùng khăn mềm sạch lau khô lồng giặt.</li>
                        </ul>

                        <img src="assets/img/maygiat2.jpg" alt="Lau sạch bên trong lồng giặt"
                             class="blog-article__img">

                        <h2 class="blog-article__subtitle">Bước 2: Vệ sinh miếng lọc cặn trong lồng giặt</h2>
                        <p class="blog-article__content">
                            Miếng lọc cặn bẩn trong lồng giặt có vai trò giữ lại các cặn bẩn, xơ vải. Vệ sinh miếng lọc
                            thường xuyên để đảm bảo máy giặt hoạt động tốt và quần áo được giặt sạch.
                            <br>
                            Cách vệ sinh:
                        </p>
                        <ul class="blog-article__list">
                            <li>Tháo miếng lọc cặn (thường ở đáy lồng giặt) ra khỏi máy giặt.</li>
                            <li>Rửa sạch miếng lọc dưới vòi nước chảy.</li>
                            <li>Dùng bàn chải nhỏ hoặc tăm bông để làm sạch các khe hẹp trên miếng lọc.</li>
                            <li>Lau khô miếng lọc và lắp lại vào máy giặt.</li>
                        </ul>

                        <img src="assets/img/maygiat3.jpg" alt="Vệ sinh ngăn chứa bột giặt, nước xả"
                             class="blog-article__img">

                        <h2 class="blog-article__subtitle">Bước 3: Vệ sinh ngăn chứa bột giặt, nước xả</h2>
                        <p class="blog-article__content">
                            Ngăn chứa bột giặt, nước xả là nơi dễ bị bám bẩn và nấm mốc do tiếp xúc trực tiếp với hóa
                            chất và nước.
                            <br>
                            Cách vệ sinh:
                        </p>
                        <ul class="blog-article__list">
                            <li>Tháo ngăn chứa bột giặt, nước xả ra khỏi máy giặt.</li>
                            <li>Rửa sạch ngăn chứa dưới vòi nước chảy, dùng bàn chải nhỏ để làm sạch các góc khuất.</li>
                            <li>Có thể ngâm ngăn chứa trong dung dịch nước ấm pha giấm trắng hoặc baking soda khoảng 30
                                phút để loại bỏ cặn bẩn cứng đầu và mùi hôi.</li>
                            <li>Lau khô và lắp lại vào máy giặt.</li>
                        </ul>

                        <img src="assets/img/maygiat4.jpg" alt="Vệ sinh máy giặt cửa trước và gioăng cao su"
                             class="blog-article__img">

                        <h2 class="blog-article__subtitle">Lưu ý khi vệ sinh máy giặt cửa trước (Vệ sinh gioăng cao su)
                        </h2>
                        <p class="blog-article__content">
                            Đối với máy giặt cửa trước, khu vực gioăng cao su là nơi dễ đọng nước và tích tụ cặn bẩn,
                            nấm mốc.
                        </p>
                        <ul class="blog-article__list">
                            <li>Vệ sinh lồng: Cho một lượng nhỏ bột giặt hoặc dung dịch vệ sinh lồng giặt chuyên
                                dụng vào ngăn chứa. Chọn chu trình giặt nước nóng (nếu có) hoặc chu trình vệ sinh lồng
                                giặt (Tub Clean) và cho máy chạy không tải.</li>
                            <li>Sử dụng giấm/Baking Soda: Nếu máy không có chế độ nước nóng, bạn có thể đổ trực tiếp
                                2 chén giấm trắng hoặc 1/4 chén baking soda** vào lồng giặt và chạy chu trình giặt
                                thường với nước ấm. Dừng máy khoảng 1 giờ sau khi nước đã đầy để ngâm lồng giặt, sau
                                đó cho máy chạy tiếp.</li>
                            <li>Gioăng cao su: Dùng khăn mềm lau sạch **gioăng cao su cửa máy giặt và các khu vực
                                xung quanh. Hãy lật kỹ các nếp gấp của gioăng để loại bỏ hết cặn bẩn và nước đọng.</li>
                        </ul>

                        <div class="blog-article__source">
                            **Nguồn tham khảo: Được tổng hợp từ nhiều nguồn uy tín về mẹo vặt gia đình và vệ sinh
                            thiết bị gia dụng.
                        </div>

                        <section class="related-posts">
                            <h3 class="related-posts__heading">BÀI NÊN XEM THÊM</h3>
                            <div class="row small-gutter">
                                <div class="col c-4 m-4 l-4">
                                    <article class="blog-item">
                                        <a href="#!" class="blog-item__link">
                                            <img src="assets/img/blog-img-02.jpg" alt="Thực phẩm hút chân không"
                                                 class="blog-item__img">
                                        </a>
                                        <div class="blog-item__content">
                                            <h3>
                                                <a class="blog-item__title" href="#!">Lợi ích của việc bảo quản thực
                                                    phẩm...</a>
                                            </h3>
                                            <p class="blog-item__desc">
                                                Bảo quản thực phẩm lâu hơn: Đây là lợi ích đầu tiên mà của máy hút chân
                                                không mà chúng ta cần phải...
                                            </p>
                                            <div class="blog-item__meta">
                                                <span class="blog-item__time">
                                                    <i class="fa-regular fa-clock"></i>
                                                    14/11/2025 • 10:30
                                                </span>
                                            </div>
                                        </div>
                                    </article>
                                </div>
                                <div class="col c-4 m-4 l-4">
                                    <article class="blog-item">
                                        <a href="#!" class="blog-item__link">
                                            <img src="assets/img/blog-img-03.jpg" alt="Đèn bắt muỗi"
                                                 class="blog-item__img">
                                        </a>
                                        <div class="blog-item__content">
                                            <h3>
                                                <a class="blog-item__title" href="#!">Cách sử dụng đèn bắt muỗi...</a>
                                            </h3>
                                            <p class="blog-item__desc">
                                                Đèn bắt muỗi được các gia đình và nhiều người tin tưởng sử dụng. Sản
                                                phẩm không chỉ giúp tiêu diệt muỗi...
                                            </p>
                                            <div class="blog-item__meta">
                                                <span class="blog-item__time">
                                                    <i class="fa-regular fa-clock"></i>
                                                    14/11/2025 • 10:30
                                                </span>
                                            </div>
                                        </div>
                                    </article>
                                </div>
                                <div class="col c-4 m-4 l-4">
                                    <article class="blog-item">
                                        <a href="#!" class="blog-item__link">
                                            <img src="assets/img/blog-img-04.jpg" alt="Máy xay sinh tố"
                                                 class="blog-item__img">
                                        </a>
                                        <div class="blog-item__content">
                                            <h3>
                                                <a class="blog-item__title" href="#!">Vệ sinh và bảo quản máy xay...</a>
                                            </h3>
                                            <p class="blog-item__desc">
                                                Sau khi sử dụng, cần xoay đúng chiều để tháo cối ra. Vì có một số loại
                                                máy xay sinh tố phải xoay...
                                            </p>
                                            <div class="blog-item__meta">
                                                <span class="blog-item__time">
                                                    <i class="fa-regular fa-clock"></i>
                                                    14/11/2025 • 10:30
                                                </span>
                                            </div>
                                        </div>
                                    </article>
                                </div>
                            </div>
                        </section>

                    </article>
                </div>
            </div>
        </div>
    </main>

    <!-- Footer -->
    <jsp:include page="/common/footer.jsp" />
    <script src="assets/js/script.js"></script>

</body>

</html>