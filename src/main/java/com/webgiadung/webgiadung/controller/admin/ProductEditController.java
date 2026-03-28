package com.webgiadung.webgiadung.controller.admin;

import com.webgiadung.webgiadung.model.Product;
import com.webgiadung.webgiadung.model.ProductDescriptions;
import com.webgiadung.webgiadung.model.ProductDetails;
import com.webgiadung.webgiadung.services.KeywordService;
import com.webgiadung.webgiadung.services.ProductService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.List;

@WebServlet(urlPatterns = {"/admin/product-edit"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 50
)
public class ProductEditController extends HttpServlet {

    private final ProductService productService = new ProductService();
    private final KeywordService keywordService = new KeywordService();
    private static final String UPLOAD_DIR = "uploads";


    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        try {

            Product p = new Product();
            p.setId(Integer.parseInt(req.getParameter("id")));
            p.setName(req.getParameter("name"));
            p.setFirstPrice(Double.parseDouble(req.getParameter("price_first")));
            p.setQuantity(Integer.parseInt(req.getParameter("quantity")));

            p.setCategoriesId(Integer.parseInt(req.getParameter("categories_id")));
            p.setBrandsId(Integer.parseInt(req.getParameter("brands_id")));
            String postVal = req.getParameter("post");
            p.setIsVisible(postVal != null ? Integer.parseInt(postVal) : 0);

            Part mainImagePart = req.getPart("image");
            String oldImage = req.getParameter("old_image");

            String mainImageName = handleFileUpload(mainImagePart, req.getServletContext().getRealPath(""));
            if (mainImageName != null) {
                p.setImage(mainImageName);
            } else {
                p.setImage(oldImage);
            }

            List<ProductDescriptions> descList = new ArrayList<>();
            String[] descIds = req.getParameterValues("desc_id");
            String[] descTitles = req.getParameterValues("desc_title");
            String[] descContents = req.getParameterValues("desc_content");

            if (descIds != null) {
                for (int i = 0; i < descIds.length; i++) {
                    ProductDescriptions desc = new ProductDescriptions();

                    desc.setId(parseId(descIds[i]));
                    desc.setAttrName(descTitles[i]);
                    desc.setValue(descContents[i]);
                    desc.setProductId(p.getId());
                    descList.add(desc);
                }
            }
            p.setDescriptions(descList);

            List<ProductDetails> detailList = new ArrayList<>();
            String[] detailIds = req.getParameterValues("detail_id");
            String[] detailTitles = req.getParameterValues("detail_title");
            String[] detailDescs = req.getParameterValues("detail_desc");
            String[] detailOldImages = req.getParameterValues("detail_old_image");

            if (detailIds != null) {
                for (int i = 0; i < detailIds.length; i++) {
                    ProductDetails detail = new ProductDetails();
                    int dId = parseId(detailIds[i]);
                    detail.setId(dId);
                    detail.setTitle(detailTitles[i]);
                    detail.setDescription(detailDescs[i]);
                    detail.setProductId(p.getId());

                    Part detailPart = req.getPart("detail_image_" + i);
                    String detailImgName = handleFileUpload(detailPart, req.getServletContext().getRealPath(""));

                    if (detailImgName != null) {
                        detail.setImage(detailImgName);
                    } else {

                        if (detailOldImages != null && i < detailOldImages.length) {
                            detail.setImage(detailOldImages[i]);
                        }
                    }
                    detailList.add(detail);
                }
            }
            p.setDetails(detailList);

            boolean isUpdated = productService.updateProduct(p);

            if (isUpdated) {
                String keywordIdStr = req.getParameter("categories_id");

                if (keywordIdStr != null && !keywordIdStr.isEmpty()) {
                    try {
                        int keywordId = Integer.parseInt(keywordIdStr);
                        keywordService.updateProductKeyword(p.getId(), keywordId);
                    } catch (NumberFormatException e) {
                        System.err.println("Lỗi định dạng Keyword ID: " + e.getMessage());
                    }
                }

                resp.sendRedirect(req.getContextPath() + "/admin/product-list?msg=success");
            } else {
                req.setAttribute("error", "Cập nhật thất bại.");
                req.setAttribute("product", p);
                req.getRequestDispatcher("/views/admin/product-edit.jsp").forward(req, resp);
            }

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            req.getRequestDispatcher("/views/admin/product-edit.jsp").forward(req, resp);
        }
    }

    private String handleFileUpload(Part part, String appPath) throws IOException {
        if (part == null || part.getSize() == 0 || part.getSubmittedFileName().isEmpty()) {
            return null;
        }

        String fileName = Path.of(part.getSubmittedFileName()).getFileName().toString();

        String uniqueFileName = System.currentTimeMillis() + "_" + fileName;


        String savePath = appPath + File.separator + UPLOAD_DIR;
        File fileSaveDir = new File(savePath);
        if (!fileSaveDir.exists()) {
            fileSaveDir.mkdir();
        }

        part.write(savePath + File.separator + uniqueFileName);

        return UPLOAD_DIR + "/" + uniqueFileName;
    }

    private int parseId(String idStr) {
        try {
            return Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            return 0;
        }
    }
}