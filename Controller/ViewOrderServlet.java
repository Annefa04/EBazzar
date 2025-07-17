package controller;

import database.OrderItemDAO;
import database.impl.OrderItemDAOImpl;
import database.DBConnection;
import model.OrderItem;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.util.List;

@WebServlet("/vendor/viewOrderVendor")
public class ViewOrderServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession(false);
        Integer vendId = null;

        if (session != null) {
            Object vendObj = session.getAttribute("vendId");
            if (vendObj instanceof Integer) {
                vendId = (Integer) vendObj;
            } else if (vendObj != null) {
                try {
                    vendId = Integer.parseInt(vendObj.toString());
                } catch (NumberFormatException ignored) {}
            }
        }

        if (vendId == null) {
            String vendIdStr = request.getParameter("vendId");
            if (vendIdStr != null) {
                try {
                    vendId = Integer.parseInt(vendIdStr);
                } catch (NumberFormatException ignored) {}
            }
        }

        if (vendId == null) {
            out.print("{\"status\": \"fail\", \"message\": \"Missing vendId from session or request.\"}");
            out.flush();
            out.close();
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            OrderItemDAO dao = new OrderItemDAOImpl(conn);
            List<OrderItem> orderItems = dao.getOrderItemsByVendorId(vendId);

            StringBuilder json = new StringBuilder();
            json.append("{\"status\":\"success\",\"orderItems\":[");

            for (int i = 0; i < orderItems.size(); i++) {
                OrderItem item = orderItems.get(i);
                json.append("{")
                    .append("\"orderItemId\":").append(item.getOrderItemId()).append(",")
                    .append("\"orderId\":").append(item.getOrderId()).append(",")
                    .append("\"productId\":").append(item.getProductId()).append(",")
                    .append("\"vendId\":").append(item.getVendId()).append(",")
                    .append("\"quantity\":").append(item.getQuantity()).append(",")
                    .append("\"subtotal\":").append(item.getSubtotal()).append(",")
                    .append("\"itemStatus\":\"").append(item.getItemStatus()).append("\"")
                    .append("}");

                if (i < orderItems.size() - 1) {
                    json.append(",");
                }
            }

            json.append("]}");
            out.print(json.toString());

        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"status\":\"fail\",\"message\":\"Server error occurred.\"}");
        } finally {
            out.flush();
            out.close();
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "POST method not supported.");
    }
}
