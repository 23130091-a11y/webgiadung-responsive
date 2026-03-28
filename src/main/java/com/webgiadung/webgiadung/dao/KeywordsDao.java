package com.webgiadung.webgiadung.dao;

import com.webgiadung.webgiadung.model.Keywords;
import java.util.List;

public class KeywordsDao extends BaseDao {

    // Lấy toàn bộ danh sách
    public List<Keywords> getAll() {
        return get().withHandle(h ->
                h.createQuery("SELECT * FROM keywords ORDER BY name ASC")
                        .mapToBean(Keywords.class)
                        .list()
        );
    }

    // hàm insert trả về int
    public int insert(Keywords keyword) {
        return get().withHandle(h ->
                h.createUpdate("INSERT INTO keywords (name, description, created_at, updated_at) " +
                                "VALUES (:name, :description, NOW(), NOW())")
                        .bind("name", keyword.getName())
                        .bind("description", keyword.getDescription())
                        .executeAndReturnGeneratedKeys("id") // Lấy ID tự động tạo
                        .mapTo(Integer.class)
                        .one()
        );
    }
    //insert vào bảng Productkeyword
    public void insertProductKeyword(int productId, int keywordId) {
        get().withHandle(h ->
                h.createUpdate("INSERT INTO product_keywords (product_id, keyword_id) VALUES (:productId, :keywordId)")
                        .bind("productId", productId)
                        .bind("keywordId", keywordId)
                        .execute()
        );
    }
    public void updateProductKeyword(int productId, int newKeywordId) {
        get().withHandle(h ->
                h.createUpdate("UPDATE product_keywords SET keyword_id = :newKeywordId WHERE product_id = :productId")
                        .bind("productId", productId)
                        .bind("newKeywordId", newKeywordId)
                        .execute()
        );
    }
    // Kiểm tra từ khóa có tồn tại ko
    public boolean checkExists(String name) {
        return get().withHandle(h ->
                h.createQuery("SELECT COUNT(id) FROM keywords WHERE name = :name")
                        .bind("name", name)
                        .mapTo(Integer.class)
                        .one() > 0
        );
    }

    public Keywords getById(int id) {
        return get().withHandle(h ->
                h.createQuery("SELECT * FROM keywords WHERE id = :id")
                        .bind("id", id)
                        .mapToBean(Keywords.class)
                        .findOne() // Trả về Optional<Keywords>
                        .orElse(null) // Nếu không thấy thì trả về null
        );
    }

    // Cập nhật Keyword
    public boolean update(Keywords keyword) {
        return get().withHandle(h ->
                h.createUpdate("UPDATE keywords SET name = :name, description = :description, updated_at = NOW() WHERE id = :id")
                        .bind("id", keyword.getId())
                        .bind("name", keyword.getName())
                        .bind("description", keyword.getDescription())
                        .execute() > 0
        );
    }

    // Xóa Keyword
    public boolean delete(int id) {
        return get().withHandle(h ->
                h.createUpdate("DELETE FROM keywords WHERE id = :id")
                        .bind("id", id)
                        .execute() > 0
        );
    }

    // Lấy danh sách từ khóa của một sản phẩm cụ thể
    public List<Keywords> getByProductId(int productId) {
        return get().withHandle(h ->
                h.createQuery("""
                    SELECT k.* FROM keywords k
                    JOIN product_keywords pk ON k.id = pk.keyword_id
                    WHERE pk.product_id = :productId
                    """)
                        .bind("productId", productId)
                        .mapToBean(Keywords.class)
                        .list()
        );
    }

    // Thêm liên kết giữa sản phẩm và từ khóa
    public void addKeywordToProduct(int productId, int keywordId) {
        get().useHandle(h ->
                h.createUpdate("INSERT IGNORE INTO product_keywords (product_id, keyword_id) VALUES (:pid, :kid)")
                        .bind("pid", productId)
                        .bind("kid", keywordId)
                        .execute()
        );
    }

    // Xóa tất cả liên kết từ khóa của một sản phẩm (Dùng khi cập nhật lại sản phẩm)
    public void removeAllKeywordsFromProduct(int productId) {
        get().useHandle(h ->
                h.createUpdate("DELETE FROM product_keywords WHERE product_id = :pid")
                        .bind("pid", productId)
                        .execute()
        );
    }
}