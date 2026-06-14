package com.webgiadung.webgiadung.model;

import java.io.Serializable;
import java.time.LocalDateTime;

public class TokenForgetPassword implements Serializable {
    private String token;
    private LocalDateTime expiryTime;
    private boolean isUsed;
    private int userId;

    public TokenForgetPassword() {
    }

    public TokenForgetPassword(String token, LocalDateTime expiryTime, boolean isUsed, int userId) {
        this.token = token;
        this.expiryTime = expiryTime;
        this.isUsed = isUsed;
        this.userId = userId;
    }

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }

    public LocalDateTime getExpiryTime() {
        return expiryTime;
    }

    public void setExpiryTime(LocalDateTime expiryTime) {
        this.expiryTime = expiryTime;
    }

    public boolean isUsed() {
        return isUsed;
    }

    public void setUsed(boolean used) {
        isUsed = used;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }
}
