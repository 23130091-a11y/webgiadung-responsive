package com.webgiadung.webgiadung.services;

import com.webgiadung.webgiadung.dao.KeywordsDao;
import com.webgiadung.webgiadung.model.Keywords;
import java.util.List;

public class KeywordService {
    private KeywordsDao keywordsDao = new KeywordsDao();

    public List<Keywords> getAllKeywords() {
        return keywordsDao.getAll();
    }

    public int createKeyword(String name, String description) {
        if (name == null || name.trim().isEmpty()) {
            return -1;
        }
        if (keywordsDao.checkExists(name.trim())) {
            return 0;
        }
        Keywords kw = new Keywords();
        kw.setName(name.trim());
        kw.setDescription(description);

        try {
            return keywordsDao.insert(kw);
        } catch (Exception e) {
            e.printStackTrace();
            return -1;
        }
    }
    public boolean addKeywordToProduct(int productId, int keywordId) {
        try {
            keywordsDao.insertProductKeyword(productId, keywordId);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    public int updateKeyword(int id, String name, String description) {
        if (name == null || name.trim().isEmpty()) {
            return -1;
        }
        Keywords currentKw = keywordsDao.getById(id);
        if (currentKw == null) {
            return -1; // không tìm thấy id keyword này trả về -1
        }

        String newName = name.trim();
        // vẫn chấp nhận tên mới trùng nhưng desc khác
        if (!currentKw.getName().equalsIgnoreCase(newName)) {
            if (keywordsDao.checkExists(newName)) {
                return 0; // Tên mới đã tồn tại -> Báo lỗi trùng
            }
        }

        currentKw.setName(newName);
        currentKw.setDescription(description);

        try {
            boolean success = keywordsDao.update(currentKw);
            return success ? 1 : -1;
        } catch (Exception e) {
            e.printStackTrace();
            return -1;
        }
    }

    public boolean deleteKeyword(int id) {
        try {
            return keywordsDao.delete(id);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    public void updateProductKeyword(int productId, int newKeywordId) {
        keywordsDao.updateProductKeyword(productId, newKeywordId);
    }
}