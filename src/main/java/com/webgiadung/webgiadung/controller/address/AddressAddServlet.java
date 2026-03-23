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
import java.util.List;

@WebServlet("/address/add")
public class AddressAddServlet extends HttpServlet {

    private static String esc(String s){
        if (s == null) return "";
        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n","\\n")
                .replace("\r","\\r");
    }

    private static String toJsonList(List<UserAddress> list){
        StringBuilder sb = new StringBuilder();
        sb.append("[");
        for (int i=0;i<list.size();i++){
            UserAddress a = list.get(i);
            if(i>0) sb.append(",");
            sb.append("{")
                    .append("\"id\":").append(a.getId()).append(",")
                    .append("\"fullName\":\"").append(esc(a.getFullName())).append("\",")
                    .append("\"phone\":\"").append(esc(a.getPhone())).append("\",")
                    .append("\"address\":\"").append(esc(a.getAddress())).append("\",")
                    .append("\"isDefault\":").append(a.getIsDefault())
                    .append("}");
        }
        sb.append("]");
        return sb.toString();
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

        String fullName = req.getParameter("fullName");
        String phone = req.getParameter("phone");
        String address = req.getParameter("address");
        int isDefault = Integer.parseInt(req.getParameter("isDefault"));

        if (fullName == null || fullName.isBlank() ||
                phone == null || phone.isBlank() ||
                address == null || address.isBlank()) {
            resp.getWriter().write("{\"ok\":false,\"msg\":\"invalid\"}");
            return;
        }

        UserAddressDao dao = new UserAddressDao();

        // Tạo đối tượng UserAddress và set các giá trị
        UserAddress newAddr = new UserAddress();
        newAddr.setUserId(u.getId());
        newAddr.setFullName(fullName.trim());
        newAddr.setPhone(phone.trim());
        newAddr.setAddress(address.trim());
        newAddr.setIsDefault(isDefault);

        // Gọi hàm insert với đối tượng vừa tạo
        int newId = dao.insert(newAddr);

        // sau khi insert -> lấy list mới để cập nhật UI
        List<UserAddress> addresses = dao.listByUser(u.getId());

        // tìm địa chỉ vừa tạo
        UserAddress selected = addresses.stream()
                .filter(a -> a.getId() == newId)
                .findFirst()
                .orElse(null);

        req.getSession().setAttribute("SELECTED_ADDR_ID", newId);

        String json = "{"
                + "\"ok\":true,"
                + "\"addresses\":" + toJsonList(addresses) + ","
                + "\"selected\":" + toJsonOne(selected)
                + "}";

        resp.getWriter().write(json);
    }
}
