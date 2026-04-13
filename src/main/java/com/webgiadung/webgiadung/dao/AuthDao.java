package com.webgiadung.webgiadung.dao;

import com.webgiadung.webgiadung.model.User;

import java.util.List;
public class AuthDao extends BaseDao {
    // Tìm user trong bảng dựa vào email
    public User getUserByEmail(String email) {
        String e = (email == null) ? "" : email.trim().toLowerCase();
        return get().withHandle(h ->
                h.createQuery("SELECT * FROM users WHERE LOWER(email) = :email")
                        .bind("email", e)
                        .mapToBean(User.class)
                        .findOne()
                        .orElse(null)
        );
    }

    // Check email tồn tại
    public boolean checkEmailExists(String email) {
        String e = (email == null) ? "" : email.trim().toLowerCase();

        return get().withHandle(h ->
                h.createQuery("SELECT COUNT(*) FROM users WHERE LOWER(email) = :email")
                        .bind("email", e)
                        .mapTo(Integer.class)
                        .one() > 0
        );
    }

    // Check số điện thoại tồn tại
    public boolean checkPhoneExists(String phone) {
        String p = (phone == null) ? "" : phone.trim();

        return get().withHandle(h ->
                h.createQuery("SELECT COUNT(*) FROM users WHERE phone = :phone")
                        .bind("phone", p)
                        .mapTo(Integer.class)
                        .one() > 0
        );
    }

    // Đăng ký user
    public void register(User user) {
        String email = (user.getEmail() == null) ? null : user.getEmail().trim().toLowerCase();
        String phone = (user.getPhone() == null) ? null : user.getPhone().trim();
        user.setEmail(email);
        user.setPhone(phone);

        get().useHandle(h ->
                h.createUpdate(
                                "INSERT INTO users (name, email, password, phone, role, status, created_at, updated_at) " +
                                        "VALUES (:name, :email, :password, :phone, :role, :status, NOW(), NOW())"
                        )
                        .bind("name", user.getName()) // Bổ sung dòng này
                        .bind("email", user.getEmail())
                        .bind("password", user.getPassword())
                        .bind("phone", user.getPhone())
                        .bind("role", user.getRole())
                        .bind("status", user.getStatus())
                        .execute()
        );
    }

    // Tìm user, keyword rỗng -> lấy hết, keyword có thì tìm theo name, email, phone
    public List<User> findUsers(String keyword) {
        String kw = (keyword == null) ? "" : keyword.trim();

        return get().withHandle(h -> {
            if (kw.isEmpty()) {
                return h.createQuery(
                                "SELECT id, name, email, CAST(phone AS CHAR) AS phone, address, avatar, status, role, " +
                                        "DATE(created_at) AS createdAt, DATE(updated_at) AS updatedAt " +
                                        "FROM users ORDER BY id DESC"
                        )
                        .mapToBean(User.class)
                        .list();
            }

            return h.createQuery(
                            "SELECT id, name, email, CAST(phone AS CHAR) AS phone, address, avatar, status, role, " +
                                    "DATE(created_at) AS createdAt, DATE(updated_at) AS updatedAt " +
                                    "FROM users " +
                                    "WHERE name LIKE :kw OR email LIKE :kw OR CAST(phone AS CHAR) LIKE :kw " +
                                    "ORDER BY id DESC"
                    )
                    .bind("kw", "%" + kw + "%")
                    .mapToBean(User.class)
                    .list();
        });
    }

    public User findUserById(int id) {
        return get().withHandle(h ->
                h.createQuery(
                                "SELECT id, name, email, CAST(phone AS CHAR) AS phone, address, avatar, status, role, " +
                                        "DATE(created_at) AS createdAt, DATE(updated_at) AS updatedAt " +
                                        "FROM users WHERE id = :id"
                        )
                        .bind("id", id)
                        .mapToBean(User.class)
                        .findOne()
                        .orElse(null)
        );
    }

    public void adminUpdateUser(User u) {
        get().useHandle(h ->
                h.createUpdate(
                                "UPDATE users SET " +
                                        "name=:name, email=:email, " +
                                        "phone = CASE WHEN :phone IS NULL OR :phone = '' THEN phone ELSE :phone END, " +
                                        "address=:address, role=:role, status=:status, updated_at=NOW() " +
                                        "WHERE id=:id"
                        )
                        .bindBean(u)
                        .execute()
        );
    }

    public void adminUpdateUserWithPassword(User u) {
        get().useHandle(h ->
                h.createUpdate(
                                "UPDATE users SET " +
                                        "name=:name, email=:email, " +
                                        "phone = CASE WHEN :phone IS NULL OR :phone = '' THEN phone ELSE :phone END, " +
                                        "address=:address, role=:role, status=:status, password=:password, updated_at=NOW() " +
                                        "WHERE id=:id"
                        )
                        .bindBean(u)
                        .execute()
        );
    }

    // khóa user để tránh lỗi FK (đơn hàng)
    public void adminSoftDeleteUser(int id) {
        get().useHandle(h ->
                h.createUpdate("UPDATE users SET status = 0, updated_at = NOW() WHERE id=:id")
                        .bind("id", id)
                        .execute()
        );
    }

    // Kích hoạt tài khoản user
    public void activateUser(String email) {
        String e = (email == null) ? "" : email.trim().toLowerCase();
        get().useHandle(h ->
                h.createUpdate("UPDATE users SET status = 1, updated_at = NOW() WHERE LOWER(email) = :email")
                        .bind("email", e)
                        .execute()
        );
    }

    // Check email tồn tại nhưng loại trừ 1 id (dùng khi admin update)
    public boolean checkEmailExistsExceptId(String email, int id) {
        String e = (email == null) ? "" : email.trim().toLowerCase();
        return get().withHandle(h ->
                h.createQuery("SELECT id FROM users WHERE LOWER(email)=:email AND id <> :id")
                        .bind("email", e)
                        .bind("id", id)
                        .mapTo(Integer.class)
                        .findOne()
                        .isPresent()
        );
    }

    // Check phone tồn tại nhưng loại trừ 1 id (dùng khi admin update)
    public boolean checkPhoneExistsExceptId(String phone, int id) {
        String p = (phone == null) ? "" : phone.trim();
        return get().withHandle(h ->
                h.createQuery("SELECT id FROM users WHERE phone=:phone AND id <> :id")
                        .bind("phone", p)
                        .bind("id", id)
                        .mapTo(Integer.class)
                        .findOne()
                        .isPresent()
        );
    }

    public User findByIdFull(int id) {
        return get().withHandle(h ->
                h.createQuery("SELECT * FROM users WHERE id = :id")
                        .bind("id", id)
                        .mapToBean(User.class)
                        .findOne()
                        .orElse(null)
        );
    }

    // update name, phone, address của user
//    public boolean updateProfile(int id, String name, String phone, String address) {
//        int updated = get().withHandle(h ->
//                h.createUpdate("UPDATE users SET name = :name, phone = :phone, address = :address, updated_at = NOW() WHERE id = :id")
//                        .bind("id", id)
//                        .bind("name", name)
//                        .bind("phone", phone)
//                        .bind("address", address)
//                        .execute()
//        );
//        return updated > 0;
//    }

    // hàm xác minh user có oldPass đúng không trước khi đổi mk mới
    public boolean checkPassword(int id, String oldPass) {
        Integer cnt = get().withHandle(h ->
                h.createQuery("SELECT COUNT(*) FROM users WHERE id=:id AND password=:pass")
                        .bind("id", id)
                        .bind("pass", oldPass)
                        .mapTo(Integer.class)
                        .one()
        );
        return cnt != null && cnt > 0;
    }

    public boolean updatePassword(int id, String newPass) {
        int updated = get().withHandle(h ->
                h.createUpdate("UPDATE users SET password=:pass, updated_at=NOW() WHERE id=:id")
                        .bind("id", id)
                        .bind("pass", newPass)
                        .execute()
        );
        return updated > 0;
    }

    public boolean updateAddress(int id, String fullAddress) {
        int updated = get().withHandle(h ->
                h.createUpdate("UPDATE users SET address = :address, updated_at = NOW() WHERE id = :id")
                        .bind("id", id)
                        .bind("address", fullAddress)
                        .execute()
        );
        return updated > 0;
    }

    public boolean updateInfo(int id, String name, String phone) {
        int updated = get().withHandle(h ->
                h.createUpdate("UPDATE users SET name = :name, phone = :phone, updated_at = NOW() WHERE id = :id")
                        .bind("id", id)
                        .bind("name", name)
                        .bind("phone", phone)
                        .execute()
        );
        return updated > 0;
    }
}