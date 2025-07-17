package controller;

import database.DeliveryRiderDAO;
import database.impl.DeliveryRiderDAOImpl;
import database.DBConnection;
import model.Delivery;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/acceptOrder")
public class AcceptOrderServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        PrintWriter out = response.getWriter();

        String deliveryIdStr = request.getParameter("deliveryId");

        HttpSession session = request.getSession(false);
        Integer riderId = null;
        if (session != null) {
            Object riderObj = session.getAttribute("riderId");
            if (riderObj instanceof Integer) {
                riderId = (Integer) riderObj;
            } else if (riderObj != null) {
                try {
                    riderId = Integer.parseInt(riderObj.toString());
                } catch (NumberFormatException ignored) {}
            }
        }

        // Optional: Allow test via Postman
        if (riderId == null) {
            String riderIdStr = request.getParameter("riderId");
            if (riderIdStr != null) {
                try {
                    riderId = Integer.parseInt(riderIdStr);
                } catch (NumberFormatException ignored) {}
            }
        }

        if (deliveryIdStr == null || deliveryIdStr.trim().isEmpty() || riderId == null) {
            out.print("{\"status\": \"fail\", \"message\": \"Missing deliveryId or rider session.\"}");
            out.flush();
            out.close();
            return;
        }

        Connection conn = null;

        try {
            int deliveryId = Integer.parseInt(deliveryIdStr);

            conn = DBConnection.getConnection();
            DeliveryRiderDAO dao = new DeliveryRiderDAOImpl(conn);

            // Assign rider and update delivery status
            dao.assignRider(deliveryId, riderId);
            dao.updateDeliveryStatus(deliveryId, "Transit");

            // Get delivery to fetch Order_ID
            Delivery delivery = dao.getDeliveryById(deliveryId);

            if (delivery != null) {
                // ✅ Update cust_order.Order_status = "Delivering"
                String updateOrderSQL = "UPDATE cust_order SET status = 'Delivering' WHERE Order_ID = ?";
                try (PreparedStatement stmt = conn.prepareStatement(updateOrderSQL)) {
                    stmt.setInt(1, delivery.getOrderId());
                    stmt.executeUpdate();
                }

                String address = delivery.getAddress().replace("\"", "\\\"");
                out.print("{\"status\": \"success\", \"address\": \"" + address + "\", \"orderId\": " + delivery.getOrderId() + "}");
            } else {
                out.print("{\"status\": \"fail\", \"message\": \"Delivery not found.\"}");
            }

        } catch (NumberFormatException e) {
            out.print("{\"status\": \"fail\", \"message\": \"Invalid deliveryId format.\"}");
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"status\": \"fail\", \"message\": \"Server error occurred.\"}");
        } finally {
            if (conn != null) {
                DBConnection.disconnect(conn);
            }
            out.flush();
            out.close();
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "GET method not supported.");
    }
}
