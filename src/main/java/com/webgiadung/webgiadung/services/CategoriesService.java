package com.webgiadung.webgiadung.services;

import com.webgiadung.webgiadung.dao.CategoriesDao;
import com.webgiadung.webgiadung.model.Categories;

import java.util.List;

public class CategoriesService {
    CategoriesDao categoriesDao = new CategoriesDao();

    public Categories getCategory(int id) {
        return categoriesDao.getCategory(id);
    }

    public List<Categories> getAllCategories() {
        return categoriesDao.getAllCategories();
    }

    public List<Categories> getCategoriesParent() {
        return categoriesDao.getCategoriesParent();
    }

    public List<Categories> getCategoriesByParentId(int parentId) {
        return categoriesDao.getCategoriesByParentId(parentId);
    }

    public int insertCategory(String name, String description, Integer parentId) {
        Categories exist = categoriesDao.findByName(name);
        if (exist != null) {
            return -2;
        }

        // nếu mà không truyền parentId vào thì mặc định nó là cha
        int finalParentId = (parentId == null) ? 0 : parentId;

        return categoriesDao.insertCategory(name, description, finalParentId);
    }

    public List<Categories> getCategoriesWithChildren() {
        List<Categories> parents = categoriesDao.getCategoriesParent();
        for(Categories parent : parents) {
            List<Categories> children = categoriesDao.getCategoriesByParentId(parent.getId());
            parent.setChildren(children);
        }
        return parents;
    }
}