package com.webgiadung.webgiadung.controller.admin;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonObject;
import com.google.gson.JsonArray;
import com.google.gson.JsonPrimitive;
import com.google.gson.JsonSerializer;
import com.webgiadung.webgiadung.model.Discounts;
import com.webgiadung.webgiadung.services.DiscountService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

@WebServlet("/api/admin/discounts-list")
public class DiscountController extends HttpServlet {
    private final DiscountService discountService = new DiscountService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            List<Discounts> list = discountService.getAllDiscounts();


            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
            Gson gson = new GsonBuilder()
                    .registerTypeAdapter(LocalDateTime.class, (JsonSerializer<LocalDateTime>) (src, typeOfSrc, context) ->
                            src != null ? new JsonPrimitive(src.format(formatter)) : null)
                    .create();


            JsonArray jsonArray = new JsonArray();
            for (Discounts discount : list) {

                JsonObject jsonObject = gson.toJsonTree(discount).getAsJsonObject();


                String displayValue = "0đ";

                String type = discount.getDiscountType();
                double value = discount.getDiscountValue();

                if ("percentage".equalsIgnoreCase(type) || "%".equals(type)) {

                    displayValue = (int) value + "%";
                } else {

                    displayValue = String.format("%,.0f", value) + "đ";
                }

                jsonObject.addProperty("displayValue", displayValue);
                jsonArray.add(jsonObject);
            }

            response.getWriter().write(gson.toJson(jsonArray));

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(500);
            response.getWriter().write("{\"error\": \"" + e.getMessage() + "\"}");
        }
    }
}