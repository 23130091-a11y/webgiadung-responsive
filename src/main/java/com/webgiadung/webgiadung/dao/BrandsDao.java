package com.webgiadung.webgiadung.dao;

import com.webgiadung.webgiadung.model.Brands;

import java.util.List;

public class BrandsDao extends BaseDao {

    // Lấy toàn bộ danh sách thương hiệu để hiển thị lựa chọn
    public List<Brands> getAll() {
        return get().withHandle(h ->
                h.createQuery("SELECT id, name, country, logo, " +
                                "created_at AS createdAt, updated_at AS updatedAt " +
                                "FROM brands ORDER BY name ASC")
                        .mapToBean(Brands.class)
                        .list()
        );
    }

    // Thêm mới một thương hiệu -> trả về id, cập nhật ajax
    public int insert(Brands brand) {
        try {
            return get().withHandle(h ->
                    h.createUpdate("INSERT INTO brands (name, country, logo, created_at, updated_at) " +
                                    "VALUES (:name, :country, :logo, NOW(), NOW())")
                            .bind("name", brand.getName())
                            .bind("country", brand.getCountry())
                            .bind("logo", brand.getLogo())
                            .executeAndReturnGeneratedKeys("id")
                            .mapTo(Integer.class)
                            .one()
            );
        } catch (Exception e) {
            e.printStackTrace();
            return -1;
        }
    }

    // Tìm thương hiệu theo ID
    public Brands findById(int id) {
        return get().withHandle(h ->
                h.createQuery("SELECT * FROM brands WHERE id = :id")
                        .bind("id", id)
                        .mapToBean(Brands.class)
                        .findOne()
                        .orElse(null)
        );
    }

    // Kiểm tra thương hiệu đã tồn tại chưa
    public boolean checkExists(String name) {
        return get().withHandle(h ->
                h.createQuery("SELECT COUNT(id) FROM brands WHERE name = :name")
                        .bind("name", name)
                        .mapTo(Integer.class)
                        .one() > 0
        );
    }

    // cập nhật name, country của thương hiệu có id
    public boolean update(Brands brand) {
        return get().withHandle(h ->
                // Đã xóa "logo = :logo" trong câu SQL
                h.createUpdate("UPDATE brands SET name = :name, country = :country, updated_at = NOW() WHERE id = :id")
                        .bind("id", brand.getId())
                        .bind("name", brand.getName())
                        .bind("country", brand.getCountry())
                        .execute() > 0
        );
    }

    // xóa thương hiệu có id, trả về số dòng bị xóa
    public boolean delete(int id) {
        return get().withHandle(h ->
                h.createUpdate("DELETE FROM brands WHERE id = :id")
                        .bind("id", id)
                        .execute() > 0
        );
    }
}