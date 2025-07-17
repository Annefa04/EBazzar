package controller;

import database.DeliveryDAO;
import database.impl.DeliveryDAOImpl;
import database.DBConnection;
import model.Delivery;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.util.Enumeration;

@WebServlet("/acceptOrder")
public class AcceptOrderServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        PrintWriter out = response.getWriter();

        // Get deliveryId from request parameter
        String deliveryIdStr = request.getParameter("deliveryId");

        // Get session and riderId from session attribute
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

        // Fallback: get riderId from request param (for Postman testing)
        if (riderId == null) {
            String riderIdStr = request.getParameter("riderId");
            if (riderIdStr != null) {
                try {
                    riderId = Integer.parseInt(riderIdStr);
                } catch (NumberFormatException ignored) {}
            }
        }

        // Debug prints (can be removed in production)
        System.out.println("DEBUG: deliveryIdStr = " + deliveryIdStr);
        System.out.println("DEBUG: riderId = " + riderId);

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
            DeliveryDAO dao = new DeliveryDAOImpl(conn);

            // Assign rider and update delivery status
            dao.assignRider(deliveryId, riderId);
            dao.updateDeliveryStatus(deliveryId, "Transit");

            Delivery delivery = dao.getDeliveryById(deliveryId);

            if (delivery != null) {
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
