package controller;

import database.DBConnection;
import model.Delivery;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;

@WebServlet("/updateDeliveryStatus")
public class UpdateDeliveryStatusServlet extends HttpServlet {
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

        if (riderId == null) {
            String riderIdStr = request.getParameter("riderId");
            if (riderIdStr != null) {
                try {
                    riderId = Integer.parseInt(riderIdStr);
                } catch (NumberFormatException ignored) {}
            }
        }

        if (deliveryIdStr == null || riderId == null) {
            out.print("{\"status\": \"fail\", \"message\": \"Missing deliveryId or rider session.\"}");
            out.flush();
            out.close();
            return;
        }

        Connection conn = null;
        try {
            int deliveryId = Integer.parseInt(deliveryIdStr);
            conn = DBConnection.getConnection();

            // Check delivery and rider match
            String query = "SELECT * FROM delivery WHERE Delivery_ID = ?";
            PreparedStatement ps = conn.prepareStatement(query);
            ps.setInt(1, deliveryId);
            ResultSet rs = ps.executeQuery();

            if (!rs.next()) {
                out.print("{\"status\": \"fail\", \"message\": \"Delivery not found.\"}");
            } else if (rs.getInt("Rider_ID") != riderId) {
                out.print("{\"status\": \"fail\", \"message\": \"Unauthorized: This delivery does not belong to the logged-in rider.\"}");
            } else {
                // Update delivery_status
                String updateDelivery = "UPDATE delivery SET Delivery_status = 'Delivered' WHERE Delivery_ID = ?";
                PreparedStatement updatePs = conn.prepareStatement(updateDelivery);
                updatePs.setInt(1, deliveryId);
                updatePs.executeUpdate();

                // Update corresponding cust_order to 'Completed'
                int orderId = rs.getInt("Order_ID");
                String updateOrder = "UPDATE cust_order SET status = 'Completed' WHERE Order_ID = ?";
                PreparedStatement updateOrderPs = conn.prepareStatement(updateOrder);
                updateOrderPs.setInt(1, orderId);
                updateOrderPs.executeUpdate();

                out.print("{\"status\": \"success\", \"message\": \"Delivery status updated to Delivered. Order status updated to Completed.\"}");
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
