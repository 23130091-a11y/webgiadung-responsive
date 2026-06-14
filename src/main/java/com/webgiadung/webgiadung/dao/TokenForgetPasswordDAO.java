package com.webgiadung.webgiadung.dao;

import com.webgiadung.webgiadung.model.TokenForgetPassword;

public class TokenForgetPasswordDAO extends BaseDao {
    public int insert(TokenForgetPassword token) {
        return get().withHandle(h -> {
            return h.createUpdate(
                            "INSERT INTO token_forget_password " +
                                    "(token, expiry_time, is_used, user_id) " +
                                    "VALUES (:token, :expiryTime, :used, :userId)"
                    )
                    .bindBean(token)
                    .executeAndReturnGeneratedKeys("id")
                    .mapTo(Integer.class)
                    .one();
        });
    }

    public TokenForgetPassword getTokenPassword(String token) {
        return get().withHandle(h ->
                h.createQuery(
                                "SELECT * " +
                                        "FROM token_forget_password " +
                                        "WHERE token = :token"
                        )
                        .bind("token", token)
                        .mapToBean(TokenForgetPassword.class)
                        .findOne()
                        .orElse(null)
        );
    }

    public boolean updateStatus(String token) {
        int updated = get().withHandle(h ->
                h.createUpdate("""
                    UPDATE token_forget_password
                    SET is_used = TRUE
                    WHERE token = :token
                    """)
                        .bind("token", token)
                        .execute()
        );
        return updated > 0;
    }
}
