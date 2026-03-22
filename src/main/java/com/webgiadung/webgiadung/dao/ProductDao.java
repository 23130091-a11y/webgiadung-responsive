package com.webgiadung.webgiadung.dao;

import com.webgiadung.webgiadung.model.*;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

public class ProductDao extends BaseDao {

    // Lấy danh sách sản phẩm (50 sp)
    public List<Product> getListProduct() {
        return get().withHandle(h ->
                h.createQuery(BASE_SELECT + " LIMIT 50")
                        .mapToBean(Product.class)
                        .list()
        );
    }

    // Lấy chi tiết 1 sản phẩm kèm các bảng phụ
    public Product getProduct(int id) {
        return get().withHandle(h -> {
            Product product = h.createQuery("""
                    SELECT
                        id,
                        name,
                        image,
                        price_first AS firstPrice,
                        discounts_id AS discountsId,
                        categories_id AS categoriesId,
                        brands_id AS brandsId,
                        keywords_id AS keywordsId,
                        post,
                        quantity,
                        quantity_saled AS quantitySaled,
                        created_at AS createdAt,
                        updated_at AS updatedAt
                    FROM products
                    WHERE id = :id
                """)
                    .bind("id", id)
                    .mapToBean(Product.class)
                    .findOne()
                    .orElse(null);

            if (product != null) {
                // Load images phụ
                List<ProductImage> images = h.createQuery("""
                        SELECT *
                        FROM product_images
                        WHERE product_id = :id
                    """)
                        .bind("id", id)
                        .mapToBean(ProductImage.class)
                        .list();
                product.setImages(images);

                // Load đánh giá (reviews)
                List<ProductReview> reviews = h.createQuery("""
                        SELECT *
                        FROM product_reviews
                        WHERE product_id = :id
                    """)
                        .bind("id", id)
                        .mapToBean(ProductReview.class)
                        .list();
                product.setReviews(reviews);

                // Bổ sung load Description cho trang chi tiết
                List<ProductDescriptions> descriptions = h.createQuery("""
                        SELECT id, title, description, products_id AS productId
                        FROM products_description
                        WHERE products_id = :id
                    """)
                        .bind("id", id)
                        .mapToBean(ProductDescriptions.class)
                        .list();
                product.setDescriptions(descriptions); // Đảm bảo tên setter đúng với class Product
            }

            return product;
        });
    }

    public int insert(Product p) {
        return get().withHandle(h -> {
            return h.createUpdate(
                            "INSERT INTO products (name, image, price_first, " +
                                    "brands_id, keywords_id, categories_id, post, quantity, created_at, updated_at) " +
                                    "VALUES (:name, :image, :totalPrice,:totalPrice, " +
                                    ":brandsId, :keywordsId, :categoriesId, :post, :quantity, NOW(), NOW())"
                    )
                    .bindBean(p)
                    .executeAndReturnGeneratedKeys("id")
                    .mapTo(Integer.class)
                    .one();
        });
    }

    public List<Product> searchByName(String keyword) {
        return get().withHandle(h ->
                h.createQuery("""
            SELECT
                    p.id, p.name, p.image,
                    p.price_first AS firstPrice,
                    p.discounts_id AS discountsId,
                    p.categories_id AS categoriesId,
                    p.brands_id AS brandsId,
                    p.is_visible AS isVisible,
                    p.status,
                    p.quantity,
                    p.sold_quantity AS soldQuantity,
                    p.created_at AS createdAt,
                    p.updated_at AS updatedAt,
                    IFNULL(d.discount_value, 0) AS discountPercent,
                    d.discount_type AS discountType,
                    IFNULL(pr.ratingAvg, 0.0) AS ratingAvg
                FROM products p
                LEFT JOIN discounts d ON p.discounts_id = d.id
                LEFT JOIN (
                    SELECT product_id, ROUND(AVG(rating), 1) AS ratingAvg 
                    FROM product_reviews 
                    GROUP BY product_id
                ) pr ON p.id = pr.product_id
                WHERE p.name LIKE :keyword AND p.is_visible = 1
                GROUP BY p.id
                ORDER BY p.id DESC
            """)
                        .bind("keyword", "%" + keyword + "%")
                        .mapToBean(Product.class)
                        .list()
        );
    }

    private static final String BASE_SELECT = """
        SELECT
            p.id, p.name, p.image,
            p.price_first AS firstPrice,
            p.discounts_id AS discountsId,
            p.categories_id AS categoriesId,
            p.brands_id AS brandsId,
            p.is_visible AS isVisible,
            p.status,
            p.quantity,
            p.sold_quantity AS soldQuantity,
            p.created_at AS createdAt,
            p.updated_at AS updatedAt,
            IFNULL(d.discount_value, 0) AS discountPercent,
            d.discount_type AS discountType,
            IFNULL(pr.ratingAvg, 0.0) AS ratingAvg
        FROM products p
            LEFT JOIN discounts d ON p.is_visible = 1 AND p.discounts_id = d.id
        LEFT JOIN (
            SELECT product_id, ROUND(AVG(rating), 1) AS ratingAvg 
            FROM product_reviews 
            GROUP BY product_id
        ) pr ON p.id = pr.product_id
        WHERE p.is_visible = 1
        GROUP BY p.id
    """;

    private static final String PROMOTION_SELECT = """
        SELECT
            p.id, p.name, p.image,
            p.price_first AS firstPrice,
            p.discounts_id AS discountsId,
            p.categories_id AS categoriesId,
            p.brands_id AS brandsId,
            p.is_visible AS isVisible,
            p.status,
            p.quantity,
            p.sold_quantity AS soldQuantity,
            p.created_at AS createdAt,
            p.updated_at AS updatedAt,
            d.discount_value AS discountPercent,
            d.discount_type AS discountType,
            IFNULL(pr.ratingAvg, 0.0) AS ratingAvg
        FROM products p
        INNER JOIN discounts d ON p.discounts_id = d.id
        LEFT JOIN (
            SELECT product_id, ROUND(AVG(rating), 1) AS ratingAvg 
            FROM product_reviews 
            GROUP BY product_id
        ) pr ON p.id = pr.product_id
        WHERE p.is_visible = 1 
          AND NOW() BETWEEN d.start_date AND d.end_date
        GROUP BY p.id
    """;

    private static final String SUGGESTED_SELECT = BASE_SELECT + """
        HAVING ratingAvg >= 4.0 AND p.sold_quantity > 0
        ORDER BY ratingAvg DESC, RAND()
        LIMIT 8
    """;

    private static final String LIMITED_DISCOUNT_SELECT = BASE_SELECT + """
        AND p.quantity > 0 
        AND p.quantity <= 10
        AND p.discounts_id IS NOT NULL
        AND NOW() BETWEEN d.start_date AND d.end_date
        ORDER BY p.quantity ASC, p.sold_quantity DESC
        LIMIT 8
    """;

    // lấy những sản phẩm có lượt bán và rating cao
    public List<Product> getFeaturedProducts() {
        return get().withHandle(h ->
                h.createQuery(BASE_SELECT + """
            ORDER BY p.sold_quantity DESC, ratingAvg DESC
                           LIMIT 8
        """)
                        .mapToBean(Product.class)
                        .list()
        );
    }

    // lấy 8 sp đang có khuyến mãi
    public List<Product> getPromotionProducts() {
        return get().withHandle(h -> {
            List<Product> list = h.createQuery(PROMOTION_SELECT + " ORDER BY p.created_at DESC LIMIT 8")
                    .mapToBean(Product.class).list();

            if (list.isEmpty()) {
                return getNewProducts(); // Fallback về sản phẩm mới
            }
            return list;
        });
    }

    public List<Product> getSuggestedProducts() {
        return get().withHandle(h -> {
            // lấy sp rating cao, đã bán được hàng
            List<Product> list = h.createQuery(SUGGESTED_SELECT)
                    .mapToBean(Product.class)
                    .list();
            // Nếu không đủ 8 sản phẩm, lấy thêm sản phẩm mới nhất để bù vào
            if (list.size() < 8) {
                List<Integer> idsToExclude = list.stream().map(Product::getId).collect(Collectors.toList());

                if (idsToExclude.isEmpty()) idsToExclude.add(-1);

                String fallbackSql = BASE_SELECT + " AND p.id NOT IN (<ids>) ORDER BY p.created_at DESC LIMIT :limit";
                List<Product> fallback = h.createQuery(fallbackSql)
                        .bindList("ids", idsToExclude) // JDBI sẽ tự thay <ids> bằng danh sách id
                        .bind("limit", 8 - list.size())
                        .mapToBean(Product.class)
                        .list();

                list.addAll(fallback);
            }
            return list;
        });
    }

    // lấy sản phẩm có số lượng tồn kho nhỏ hơn 10 & đang giảm giá
    public List<Product> getLimitedProducts() {
        return get().withHandle(h -> {
            List<Product> list = h.createQuery(LIMITED_DISCOUNT_SELECT).mapToBean(Product.class).list();
            if (list.size() < 4) {
                return getFeaturedProducts(); // Fallback về hàng nổi bật
            }
            return list;
        });
    }

    // lấy sản phẩm mới
    public List<Product> getNewProducts() {
        return get().withHandle(h ->
                h.createQuery(BASE_SELECT + """
            AND p.status = 1
            ORDER BY p.created_at DESC
            LIMIT 8
        """)
                        .mapToBean(Product.class)
                        .list()
        );
    }

    // Lấy sản phẩm dựa trên danh sách ID từ Cookie
    public List<Product> getProductsFromIds(List<Integer> ids) {
        if (ids == null || ids.isEmpty()) return new ArrayList<>();

        // tạo chuỗi idListOrder để giữ thứ tự cho FIELD, cái id mới thêm và các id trong ds
        String idListOrder = ids.stream()
                .map(String::valueOf)
                .collect(Collectors.joining(","));

        return get().withHandle(h ->
                h.createQuery(BASE_SELECT + " AND p.id IN (<ids>) ORDER BY FIELD(p.id, " + idListOrder + ")")
                        .bindList("ids", ids)
                        .mapToBean(Product.class)
                        .list()
        );
    }

    public Product getProductFullInfo(int id) {
        return get().withHandle(handle -> {
            Product product = handle.createQuery("""
            SELECT 
                p.id, p.name, p.image, 
                p.price_first AS firstPrice, 
                p.discounts_id AS discountsId, 
                p.categories_id AS categoriesId, 
                p.brands_id AS brandsId, 
                p.keywords_id AS keywordsId, 
                p.post, p.quantity, 
                p.quantity_saled AS quantitySaled, 
                p.created_at AS createdAt, 
                p.updated_at AS updatedAt,
                
                b.name AS brandName,
                k.name AS keywordName

            FROM products p
            LEFT JOIN brands b ON p.brands_id = b.id
            LEFT JOIN keywords k ON p.keywords_id = k.id
            
            WHERE p.id = :id
        """)
                    .bind("id", id)
                    .mapToBean(Product.class)
                    .findOne()
                    .orElse(null);
            // Các phần logic lấy list con bên dưới giữ nguyên
            if (product != null) {

                List<ProductDescriptions> descriptions = handle.createQuery("""
                SELECT 
                    id, title, description, 
                    products_id AS productId, 
                    created_at AS createdAt, 
                    updated_at AS updatedAt
                FROM products_description 
                WHERE products_id = :pid
            """)
                        .bind("pid", id)
                        .mapToBean(ProductDescriptions.class)
                        .list();

                List<ProductDetails> details = handle.createQuery("""
                SELECT 
                    id, image, title, description, 
                    products_id AS productId, 
                    created_at AS createdAt, 
                    updated_at AS updatedAt
                FROM products_detail 
                WHERE products_id = :pid
            """)
                        .bind("pid", id)
                        .mapToBean(ProductDetails.class)
                        .list();

                product.setDescriptions(descriptions);
                product.setDetails(details);
            }

            return product;
        });
    }

    public boolean updateProduct(Product product) {
        return get().inTransaction(handle -> {
            // 1. CẬP NHẬT BẢNG CHÍNH (products)
            // Lưu ý: Không cập nhật cột 'discount' theo yêu cầu
            int rowsUpdated = handle.createUpdate("""
            UPDATE products SET 
                name = :name,
                image = :image,
                price_first = :firstPrice,
                categories_id = :categoriesId,
                brands_id = :brandsId,
                keywords_id = :keywordsId,
                post = :post,
                quantity = :quantity,
                quantity_saled = :quantitySaled,
                updated_at = NOW()             
            WHERE id = :id
        """)
                    .bindBean(product)
                    .execute();

            if (rowsUpdated == 0) return false;

            if (product.getDescriptions() != null) {
                // Bước A: Lấy danh sách ID hiện có trong DB
                List<Integer> existingIds = handle.createQuery("SELECT id FROM products_description WHERE products_id = :pid")
                        .bind("pid", product.getId())
                        .mapTo(Integer.class)
                        .list();

                List<Integer> incomingIds = product.getDescriptions().stream()
                        .map(ProductDescriptions::getId)
                        .filter(id -> id > 0)
                        .collect(Collectors.toList());


                List<Integer> idsToDelete = existingIds.stream()
                        .filter(id -> !incomingIds.contains(id))
                        .collect(Collectors.toList());

                if (!idsToDelete.isEmpty()) {
                    handle.createUpdate("DELETE FROM products_description WHERE id IN (<ids>)")
                            .bindList("ids", idsToDelete)
                            .execute();
                }

                for (ProductDescriptions desc : product.getDescriptions()) {
                    if (desc.getId() > 0 && existingIds.contains(desc.getId())) {
                        // Cập nhật dòng cũ
                        handle.createUpdate("""
                        UPDATE products_description 
                        SET title = :title, description = :desc, updated_at = NOW() 
                        WHERE id = :id
                    """)
                                .bind("title", desc.getAttrName())
                                .bind("desc", desc.getValue())
                                .bind("id", desc.getId())
                                .execute();
                    } else {
                        // Insert dòng mới (ID = 0 hoặc rỗng)
                        handle.createUpdate("""
                        INSERT INTO products_description (title, description, products_id, created_at, updated_at)
                        VALUES (:title, :desc, :pid, NOW(), NOW())
                    """)
                                .bind("title", desc.getAttrName())
                                .bind("desc", desc.getValue())
                                .bind("pid", product.getId())
                                .execute();
                    }
                }
            }

            if (product.getDetails() != null) {
                List<Integer> existingDetailIds = handle.createQuery("SELECT id FROM products_detail WHERE products_id = :pid")
                        .bind("pid", product.getId())
                        .mapTo(Integer.class)
                        .list();

                List<Integer> incomingDetailIds = product.getDetails().stream()
                        .map(ProductDetails::getId)
                        .filter(id -> id > 0)
                        .collect(Collectors.toList());

                List<Integer> detailIdsToDelete = existingDetailIds.stream()
                        .filter(id -> !incomingDetailIds.contains(id))
                        .collect(Collectors.toList());

                if (!detailIdsToDelete.isEmpty()) {
                    handle.createUpdate("DELETE FROM products_detail WHERE id IN (<ids>)")
                            .bindList("ids", detailIdsToDelete)
                            .execute();
                }

                for (ProductDetails detail : product.getDetails()) {
                    if (detail.getId() > 0 && existingDetailIds.contains(detail.getId())) {
                        // Update
                        handle.createUpdate("""
                        UPDATE products_detail 
                        SET image = :img, title = :title, description = :desc, updated_at = NOW() 
                        WHERE id = :id
                    """)
                                .bind("img", detail.getImage())
                                .bind("title", detail.getTitle())
                                .bind("desc", detail.getDescription())
                                .bind("id", detail.getId())
                                .execute();
                    } else {
                        // Insert
                        handle.createUpdate("""
                        INSERT INTO products_detail (image, title, description, products_id, created_at, updated_at)
                        VALUES (:img, :title, :desc, :pid, NOW(), NOW())
                    """)
                                .bind("img", detail.getImage())
                                .bind("title", detail.getTitle())
                                .bind("desc", detail.getDescription())
                                .bind("pid", product.getId())
                                .execute();
                    }
                }
            }

            return true;
        });
    }

    public boolean deleteProduct(int id) {
        return get().inTransaction(handle -> {

            handle.createUpdate("DELETE FROM product_descriptions WHERE products_id = :pid")
                    .bind("pid", id)
                    .execute();

            handle.createUpdate("DELETE FROM product_details WHERE products_id = :pid")
                    .bind("pid", id)
                    .execute();

            int rowsDeleted = handle.createUpdate("DELETE FROM products WHERE id = :id")
                    .bind("id", id)
                    .execute();

            // Trả về true nếu xóa thành công ít nhất 1 dòng
            return rowsDeleted > 0;
        });
    }

    // lấy các sp thuộc category có id
    public List<Product> getProductsByCategoryId(int categoryId) {
        return get().withHandle(h ->
                h.createQuery(BASE_SELECT + " AND p.categories_id = :categoryId ORDER BY p.created_at DESC")
                        .bind("categoryId", categoryId)
                        .mapToBean(Product.class)
                        .list()
        );
    }

    // áp dụng chương trình giảm giá cho các sản phẩm trong 1 danh mục
    public int applyDiscountToCategory(int categoryId, int newDiscountId) {
        return get().withHandle(handle -> {
            int rows = handle.createUpdate("""
            UPDATE products
            SET discounts_id = :discountId,
                updated_at = NOW()
            WHERE categories_id = :categoryId
            AND status = 1
            AND is_visible = 1
        """)
                    .bind("categoryId", categoryId)
                    .bind("discountId", newDiscountId)
                    .execute();
            return rows;
        });
    }

    public List<Product> searchWithFilters(String keyword, String[] brands, String[] priceRanges, String categoryId) {
        return get().withHandle(h -> {
            StringBuilder sql = new StringBuilder("""
        SELECT 
            p.id, p.name, p.image, p.post, p.quantity,
            p.price_first AS firstPrice, 
            p.discounts_id AS discountsId, 
           (COALESCE(d.discount, 0) * 1.0) AS discountPercent,
            p.categories_id AS categoriesId, 
            p.brands_id AS brandsId, 
            p.keywords_id AS keywordsId, 
            p.quantity_saled AS quantitySaled, 
            p.created_at AS createdAt, 
            p.updated_at AS updatedAt
        FROM products p
        LEFT JOIN discounts d ON p.discounts_id = d.id
        WHERE 1=1 
    """);

            if (categoryId != null && !categoryId.trim().isEmpty()) {
                sql.append(" AND p.categories_id = :categoryId ");
            }

            if (keyword != null && !keyword.trim().isEmpty()) {
                sql.append(" AND LOWER(p.name) LIKE LOWER(:keyword) ");
            }

            if (brands != null && brands.length > 0) {
                sql.append(" AND p.brands_id IN (SELECT id FROM brands WHERE name IN (<brandNames>)) ");
            }

            if (priceRanges != null && priceRanges.length > 0) {
                sql.append(" AND ( ");
                for (int i = 0; i < priceRanges.length; i++) {
                    sql.append(" (p.price_total BETWEEN :min").append(i).append(" AND :max").append(i).append(") ");
                    if (i < priceRanges.length - 1) {
                        sql.append(" OR ");
                    }
                }
                sql.append(" ) ");
            }

            var query = h.createQuery(sql.toString());

            if (categoryId != null && !categoryId.trim().isEmpty()) {
                query.bind("categoryId", categoryId);
            }
            if (keyword != null && !keyword.trim().isEmpty()) {
                query.bind("keyword", "%" + keyword.trim() + "%");
            }
            if (brands != null && brands.length > 0) {
                query.bindList("brandNames", java.util.Arrays.asList(brands));
            }
            if (priceRanges != null && priceRanges.length > 0) {
                for (int i = 0; i < priceRanges.length; i++) {
                    String[] parts = priceRanges[i].split("-");
                    if (parts.length == 2) {
                        try {
                            query.bind("min" + i, Double.parseDouble(parts[0]));
                            query.bind("max" + i, Double.parseDouble(parts[1]));
                        } catch (NumberFormatException e) {
                            query.bind("min" + i, -1.0);
                            query.bind("max" + i, -1.0);
                        }
                    }
                }
            }
            return query.mapToBean(Product.class).list();
        });
    }

    // tìm sản phẩm thuộc các chương trình giảm giá discountName
    public List<Product> searchByDiscountName(String discountName) {
        return get().withHandle(h ->
                h.createQuery(BASE_SELECT.replace("LEFT JOIN discounts d", "INNER JOIN discounts d") + """
                AND d.name LIKE :discountName
                ORDER BY d.discount_value DESC
            """)
                        .bind("discountName", "%" + discountName + "%")
                        .mapToBean(Product.class)
                        .list()
        );
    }

    // khi xóa mã giảm giá thì gỡ nó ra khỏi các sản phẩm luôn (null)
    public int removeDiscount(int discountId) {
        return get().withHandle(handle -> {
            return handle.createUpdate("""
            UPDATE products 
            SET 
                discounts_id = NULL,
                updated_at = NOW()
            WHERE discounts_id = :discountId
        """)
                    .bind("discountId", discountId)
                    .execute();
        });
    }
}



