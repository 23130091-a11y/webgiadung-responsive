package com.webgiadung.webgiadung.controller.admin;

import com.webgiadung.webgiadung.services.KeywordService;
import com.webgiadung.webgiadung.services.ProductImageService;
import com.webgiadung.webgiadung.utils.FileUtils;
import com.webgiadung.webgiadung.model.Product;
import com.webgiadung.webgiadung.model.ProductDescriptions;
import com.webgiadung.webgiadung.model.ProductDetails;
import com.webgiadung.webgiadung.services.ProductService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet("/api/add-product")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 10,
        maxFileSize = 1024 * 1024 * 20,
        maxRequestSize = 1024 * 1024 * 100
)
public class AddProductController extends HttpServlet {
    private ProductService productService = new ProductService();
    private KeywordService keywordService = new KeywordService();
    private ProductImageService productImageService = new ProductImageService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        try {

            String brandIdRaw = req.getParameter("brandID");
            String tagIdRaw = req.getParameter("tagID");
            String cateIdRaw = req.getParameter("cateID");
            String postStatusRaw = req.getParameter("postStatus");

            if (brandIdRaw == null || tagIdRaw == null || cateIdRaw == null || req.getParameter("productPrice") == null) {
                resp.getWriter().write("{\"status\":\"error\", \"message\":\"Thiếu dữ liệu bắt buộc (Nhãn hiệu, Tag, Danh mục hoặc Giá)\"}");
                return;
            }

            Product p = new Product();
            p.setName(req.getParameter("productName"));
            p.setFirstPrice(Double.parseDouble(req.getParameter("productPrice")));

            p.setBrandsId(Integer.parseInt(brandIdRaw));
            p.setCategoriesId(Integer.parseInt(cateIdRaw));

            p.setQuantity(Integer.parseInt(req.getParameter("productStock")));
            p.setIsVisible("1".equals(postStatusRaw) ? 1 : 0);

            String realPath = getServletContext().getRealPath("/");

            // lấy danh sách tất cả các ảnh sản phẩm
            List<Part> allProductImages = req.getParts().stream()
                    .filter(part -> "productImages[]".equals(part.getName()) && part.getSize() > 0)
                    .collect(Collectors.toList());

            if (!allProductImages.isEmpty()) {
                Part firstPart = allProductImages.get(0);
                // lấy ảnh đầu tiên là ảnh đại diện của sản phẩm
                String mainImageName = FileUtils.saveFile(firstPart, realPath, "products");
                p.setImage(mainImageName);
            }

           // lưu product và lấy productID
            int productId = productService.addProduct(p);

            if (productId > 0) {
                // các ảnh còn lại lưu vào bảng productImage
                if (allProductImages.size() > 1) {
                    for (int i = 1; i < allProductImages.size(); i++) {
                        Part extraPart = allProductImages.get(i);
                        String extraImageName = FileUtils.saveFile(extraPart, realPath, "products");

                        if (extraImageName != null) {
                            com.webgiadung.webgiadung.model.ProductImage img = new com.webgiadung.webgiadung.model.ProductImage();
                            img.setProductId(productId);
                            img.setPath(extraImageName);
                            productImageService.addProductImage(img);
                        }
                    }
                }

            }

            if (productId > 0) {
              // lưu description
                String[] dTitles = req.getParameterValues("descTitles[]");
                String[] dContents = req.getParameterValues("descContents[]");

                if (dTitles != null && dContents != null) {
                    for (int i = 0; i < dTitles.length; i++) {
                        if (dTitles[i] != null && !dTitles[i].trim().isEmpty()) {
                            ProductDescriptions pd = new ProductDescriptions();
                            pd.setProductId(productId);
                            pd.setAttrName(dTitles[i]);
                            pd.setValue(dContents[i]);
                            productService.addDescription(pd);
                        }
                    }
                }

                // -lưu detail
                String[] detTitles = req.getParameterValues("detTitles[]");
                String[] detContents = req.getParameterValues("detContents[]");
                List<Part> detImages = req.getParts().stream()
                        .filter(part -> "detImages[]".equals(part.getName()) && part.getSize() > 0)
                        .collect(Collectors.toList());

                if (detTitles != null) {
                    for (int i = 0; i < detTitles.length; i++) {
                        ProductDetails detail = new ProductDetails();
                        detail.setProductId(productId);
                        detail.setTitle(detTitles[i]);
                        detail.setDescription(detContents[i]);

                        if (i < detImages.size()) {
                            detail.setImage(FileUtils.saveFile(detImages.get(i), realPath, "details"));
                        }
                        productService.addProductDetail(detail);
                    }
                }
                // lưu keyword
                if (tagIdRaw != null && !tagIdRaw.isEmpty() && !"add-new".equals(tagIdRaw)) {
                    try {
                        int kwId = Integer.parseInt(tagIdRaw);
                        boolean isAdd = keywordService.addKeywordToProduct(productId, kwId);

                        if (!isAdd) {
                            System.err.println("Lỗi thêm keyword" + productId);
                        }
                    } catch (NumberFormatException e) {
                        System.err.println("Lỗi định dạng iD không phải số hợp lệ: " + tagIdRaw);
                    }
                }

                resp.getWriter().write("{\"status\":\"success\"}");
            } else {
                resp.getWriter().write("{\"status\":\"fail\", \"message\":\"Lỗi Database: Không tạo được ID sản phẩm\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            String cleanMessage = e.getMessage() != null
                    ? e.getMessage().replace("\"", "'").replace("\n", " ").replace("\r", "")
                    : "Unknown Server Error";
            resp.getWriter().write("{\"status\":\"error\", \"message\":\"" + cleanMessage + "\"}");
        }
    }
}