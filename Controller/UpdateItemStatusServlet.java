package controller;

import database.OrderItemVendorDAO;
import database.impl.OrderItemVendorDAOImpl;
import database.DBConnection;
import model.OrderItem;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet("/updateItemStatus")
public class UpdateItemStatusServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        PrintWriter out = response.getWriter();
        String orderItemIdStr = request.getParameter("orderItemId");
        String newStatus = request.getParameter("status");

        HttpSession session = request.getSession(false);
        Integer vendId = null;
        if (session != null) {
            Object vendorObj = session.getAttribute("vendId");
            if (vendorObj instanceof Integer) {
                vendId = (Integer) vendorObj;
            } else if (vendorObj != null) {
                try {
                    vendId = Integer.parseInt(vendorObj.toString());
                } catch (NumberFormatException ignored) {}
            }
        }

        if (orderItemIdStr == null || newStatus == null || newStatus.trim().isEmpty()) {
            out.print("{\"status\": \"fail\", \"message\": \"Missing orderItemId or status.\"}");
            out.flush();
            out.close();
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            int orderItemId = Integer.parseInt(orderItemIdStr);
            OrderItemVendorDAO dao = new OrderItemVendorDAOImpl(conn);

            OrderItem item = dao.getOrderItemVendorById(orderItemId);

            if (item == null) {
                out.print("{\"status\": \"fail\", \"message\": \"Order item not found.\"}");
            } else if (vendId != null && !vendId.equals(item.getVendorId())) {
                out.print("{\"status\": \"fail\", \"message\": \"Unauthorized: Item does not belong to logged-in vendor.\"}");
            } else {
                boolean success = dao.updateOrderItemVendorStatus(orderItemId, newStatus);
                if (success) {
                    int orderId = item.getOrderId();

                    // Update cust_order.Order_status for "Preparing" or "Rejected"
                    if ("Preparing".equalsIgnoreCase(newStatus) || "Rejected".equalsIgnoreCase(newStatus)) {
                        String updateOrderSQL = "UPDATE cust_order SET status = ? WHERE Order_ID = ?";
                        try (PreparedStatement stmt = conn.prepareStatement(updateOrderSQL)) {
                            stmt.setString(1, newStatus);
                            stmt.setInt(2, orderId);
                            stmt.executeUpdate();
                        } catch (SQLException e) {
                            e.printStackTrace();
                        }
                    }

                    // Update delivery.Delivery_status to "Pending" if Ready for Pickup
                    if ("Ready for Pickup".equalsIgnoreCase(newStatus)) {
                        String updateDeliverySQL = "UPDATE delivery SET Delivery_status = 'Pending' WHERE Order_ID = ?";
                        try (PreparedStatement stmt = conn.prepareStatement(updateDeliverySQL)) {
                            stmt.setInt(1, orderId);
                            stmt.executeUpdate();
                        } catch (SQLException e) {
                            e.printStackTrace();
                        }
                    }

                    out.print("{\"status\": \"success\", \"message\": \"Item status updated to " + newStatus + ".\"}");
                } else {
                    out.print("{\"status\": \"fail\", \"message\": \"Failed to update item status.\"}");
                }
            }

        } catch (NumberFormatException e) {
            out.print("{\"status\": \"fail\", \"message\": \"Invalid orderItemId format.\"}");
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"status\": \"fail\", \"message\": \"Server error occurred.\"}");
        } finally {
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
