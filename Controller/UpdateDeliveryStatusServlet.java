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

        // Get riderId from session
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
            DeliveryDAO dao = new DeliveryDAOImpl(conn);

            Delivery delivery = dao.getDeliveryById(deliveryId);

            if (delivery == null) {
                out.print("{\"status\": \"fail\", \"message\": \"Delivery not found.\"}");
            } else if (!riderId.equals(delivery.getRiderId())) {
                out.print("{\"status\": \"fail\", \"message\": \"Unauthorized: This delivery does not belong to the logged-in rider.\"}");
            } else {
                dao.updateDeliveryStatus(deliveryId, "Delivered");
                out.print("{\"status\": \"success\", \"message\": \"Delivery status updated to Delivered.\"}");
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
