package com.webgiadung.webgiadung.controller.address;

import com.webgiadung.webgiadung.dao.UserAddressDao;
import com.webgiadung.webgiadung.model.User;
import com.webgiadung.webgiadung.model.UserAddress;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/address/select")
public class AddressSelectServlet extends HttpServlet {

    private static String esc(String s){
        if (s == null) return "";
        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n","\\n")
                .replace("\r","\\r");
    }

    private static String toJsonOne(UserAddress a){
        if(a==null) return "null";
        return "{"
                + "\"id\":" + a.getId() + ","
                + "\"fullName\":\"" + esc(a.getFullName()) + "\","
                + "\"phone\":\"" + esc(a.getPhone()) + "\","
                + "\"address\":\"" + esc(a.getAddress()) + "\","
                + "\"isDefault\":" + a.getIsDefault()
                + "}";
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json");

        User u = (User) req.getSession().getAttribute("user");
        if (u == null) {
            resp.getWriter().write("{\"ok\":false,\"msg\":\"not_login\"}");
            return;
        }

        String idStr = req.getParameter("addressId");
        int id;
        try {
            id = Integer.parseInt(idStr);
        }
        catch (Exception e){
            resp.getWriter().write("{\"ok\":false,\"msg\":\"invalid\"}");
            return;
        }

        UserAddressDao dao = new UserAddressDao();

        UserAddress selected = dao.findById(u.getId(), id).orElse(null);
        if (selected == null) {
            resp.getWriter().write("{\"ok\":false,\"msg\":\"not_found\"}");
            return;
        }

        req.getSession().setAttribute("SELECTED_ADDR_ID", id);

        resp.getWriter().write("{\"ok\":true,\"selected\":"+toJsonOne(selected)+"}");
    }
}
