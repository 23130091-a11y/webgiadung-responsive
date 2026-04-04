package com.webgiadung.webgiadung.dao;

import com.webgiadung.webgiadung.model.UserAddress;

import java.util.List;
import java.util.Optional;

public class UserAddressDao extends BaseDao {

    public List<UserAddress> findByUser(int userId) {
        return listByUser(userId);
    }

    public List<UserAddress> listByUser(int userId) {
        return get().withHandle(h ->
                h.createQuery("""
                        SELECT id, user_id AS userId, full_name AS fullName, phone, address, is_default AS isDefault
                        FROM user_addresses
                        WHERE user_id = :uid
                        ORDER BY is_default DESC, id DESC
                        """)
                        .bind("uid", userId)
                        .mapToBean(UserAddress.class)
                        .list()
        );
    }

    public Optional<UserAddress> findDefault(int userId) {
        return get().withHandle(h ->
                h.createQuery("""
                        SELECT id, user_id AS userId, full_name AS fullName, phone, address, is_default AS isDefault
                        FROM user_addresses
                        WHERE user_id = :uid AND is_default = 1
                        LIMIT 1
                        """)
                        .bind("uid", userId)
                        .map((rs, ctx) -> {
                            UserAddress a = new UserAddress();
                            a.setId(rs.getInt("id"));
                            a.setUserId(rs.getInt("userId"));
                            a.setFullName(rs.getString("fullName"));
                            a.setPhone(rs.getString("phone"));
                            a.setAddress(rs.getString("address"));
                            a.setIsDefault(rs.getInt("isDefault"));
                            return a;
                        })
                        .findOne()
        );
    }

    public Optional<UserAddress> findById(int userId, int id) {
        return get().withHandle(h ->
                h.createQuery("""
                        SELECT id, user_id AS userId, full_name AS fullName, phone, address, is_default AS isDefault
                        FROM user_addresses
                        WHERE user_id = :uid AND id = :id
                        LIMIT 1
                        """)
                        .bind("uid", userId)
                        .bind("id", id)
                        .mapToBean(UserAddress.class) // Tự động map nếu tên field khớp
                        .findOne()
        );
    }

    public int insert(UserAddress addr) {
        return get().withHandle(handle ->
                handle.inTransaction(h -> {
                    // Bước 1: Nếu đặt làm mặc định, xóa các mặc định cũ của user này
                    if (addr.getIsDefault() == 1) {
                        h.createUpdate("UPDATE user_addresses SET is_default = 0 WHERE user_id = :uid")
                                .bind("uid", addr.getUserId())
                                .execute();
                    }

                    // Bước 2: Thực hiện Insert địa chỉ mới
                    // Lưu ý: Đảm bảo các placeholder :userId, :fullName... khớp với property của addr
                    return h.createUpdate("""
                    INSERT INTO user_addresses(user_id, full_name, phone, address, is_default)
                    VALUES(:userId, :fullName, :phone, :address, :isDefault)
                    """)
                            .bindBean(addr)
                            .executeAndReturnGeneratedKeys("id")
                            .mapTo(int.class)
                            .one();
                })
        );
    }

    // hàm này chưa làm gì
    public void setDefault(int userId, int addressId) {
        get().useHandle(handle ->
                handle.useTransaction(h -> { // h ở đây là đại diện cho transaction
                    h.createUpdate("UPDATE user_addresses SET is_default = 0 WHERE user_id = :uid")
                            .bind("uid", userId)
                            .execute();

                    h.createUpdate("UPDATE user_addresses SET is_default = 1 WHERE user_id = :uid AND id = :id")
                            .bind("uid", userId)
                            .bind("id", addressId)
                            .execute();
                })
        );
    }

    public int delete(int userId, int id) {
        return get().withHandle(h ->
                h.createUpdate("""
                    DELETE FROM user_addresses
                    WHERE user_id = :uid AND id = :id
                    """)
                        .bind("uid", userId)
                        .bind("id", id)
                        .execute()
        );
    }

    // thêm hàm update
    public int update(UserAddress addr) {
        return get().withHandle(handle ->
                handle.inTransaction(h -> {
                    // Bước 1: Xử lý logic mặc định
                    if (addr.getIsDefault() == 1) {
                        h.createUpdate("UPDATE user_addresses SET is_default = 0 WHERE user_id = :uid")
                                .bind("uid", addr.getUserId())
                                .execute();
                    }

                    // Bước 2: Cập nhật dữ liệu
                    return h.createUpdate("""
                    UPDATE user_addresses 
                    SET full_name = :fullName, phone = :phone, address = :address, is_default = :isDefault
                    WHERE id = :id AND user_id = :userId
                """)
                            .bindBean(addr)
                            .execute();
                })
        );
    }
}
