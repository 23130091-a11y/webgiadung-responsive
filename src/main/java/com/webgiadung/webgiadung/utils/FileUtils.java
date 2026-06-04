package com.webgiadung.webgiadung.utils;

import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;

public class FileUtils {

    public static String saveFile(Part part, String realPath, String subFolder) throws IOException {

        if (part == null || part.getSubmittedFileName().isEmpty()) return null;

        String originalName = Paths.get(part.getSubmittedFileName()).getFileName().toString();
        String safeName = originalName.replaceAll("[\\s+]", "-").replaceAll("[^a-zA-Z0-9._-]", "");

        String fileName = System.currentTimeMillis() + "_" + safeName;
        if ("slides".equals(subFolder) || "reviews".equals(subFolder) || "details".equals(subFolder) || "products".equals(subFolder)) {

            String baseDir = "C:\\webgiadung_data\\uploads\\";
            String uploadDir = baseDir + "assets\\img\\" + subFolder;

            File dir = new File(uploadDir);
            if (!dir.exists()) dir.mkdirs();

            part.write(uploadDir + File.separator + fileName);

            return "assets/img/" + subFolder + "/" + fileName;

        } else {
            String uploadDir = realPath + "assets/img/" + subFolder;

            File dir = new File(uploadDir);
            if (!dir.exists()) dir.mkdirs();

            part.write(uploadDir + File.separator + fileName);

            return fileName;
        }
    }
}
