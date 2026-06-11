package com.webgiadung.webgiadung.utils;

import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;

public class FileUtils {

    public static String saveFile(Part part, String realPath, String subFolder) throws IOException {

        if (part == null || part.getSubmittedFileName().isEmpty()) return null;

        String originalName = Paths.get(part.getSubmittedFileName()).getFileName().toString();
        String safeName = originalName.replaceAll("[\\s+]", "-").replaceAll("[^a-zA-Z0-9._-]", "");

        String fileName = System.currentTimeMillis() + "_" + safeName;
        if ("slides".equals(subFolder) || "reviews".equals(subFolder) || "details".equals(subFolder) || "products".equals(subFolder)) {

            String baseDir = "D:\\DoAnLapTrinh\\DoAn\\DoAnWeb\\src\\main\\webapp\\";
            String uploadDir = baseDir + "assets\\img\\" + subFolder;

            File dir = new File(uploadDir);
            if (!dir.exists()) dir.mkdirs();

            part.write(uploadDir + File.separator + fileName);
            try {
                String tomcatUploadDir = realPath + "assets" + File.separator + "img" + File.separator + subFolder;
                File tomcatDir = new File(tomcatUploadDir);
                if (!tomcatDir.exists()) tomcatDir.mkdirs();

                java.nio.file.Path tomcatTargetPath = Paths.get(tomcatUploadDir, fileName);

                java.nio.file.Path srcPath = Paths.get(uploadDir, fileName);
                Files.copy(srcPath, tomcatTargetPath, StandardCopyOption.REPLACE_EXISTING);

                System.out.println("--- Đã đồng bộ ảnh thành công sang thư mục Server! ---");
            } catch (Exception e) {
                System.out.println("Lỗi đồng bộ sang Tomcat: " + e.getMessage());
            }

            return fileName;

        } else {
            String uploadDir = realPath + "assets/img/" + subFolder;

            File dir = new File(uploadDir);
            if (!dir.exists()) dir.mkdirs();

            part.write(uploadDir + File.separator + fileName);

            return fileName;
        }
    }
}
