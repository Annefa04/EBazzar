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
import java.util.List;

@WebServlet("/api/viewdelivery")
public class ViewDeliveryServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        PrintWriter out = response.getWriter();
        Connection conn = null;

        try {
            conn = DBConnection.getConnection();
            DeliveryDAO dao = new DeliveryDAOImpl(conn);
            List<Delivery> deliveries = dao.getAllDeliveries();

            StringBuilder json = new StringBuilder();
            json.append("[");

            for (int i = 0; i < deliveries.size(); i++) {
                Delivery d = deliveries.get(i);

                json.append("{")
                    .append("\"deliveryId\":").append(d.getDeliveryId()).append(",")
                    .append("\"orderId\":").append(d.getOrderId()).append(",")
                    .append("\"riderId\":").append(d.getRiderId() == null ? "null" : d.getRiderId()).append(",")
                    .append("\"deliveryStatus\":\"").append(escape(d.getDeliveryStatus())).append("\",")
                    .append("\"distanceKm\":").append(d.getDistanceKm()).append(",")
                    .append("\"deliveryType\":\"").append(escape(d.getDeliveryType())).append("\",")
                    .append("\"deliveryFee\":").append(d.getDeliveryFee()).append(",")
                    .append("\"address\":\"").append(escape(d.getAddress())).append("\",")
                    .append("\"paymentMethod\":\"").append(escape(d.getPaymentMethod())).append("\"")
                    .append("}");

                if (i < deliveries.size() - 1) {
                    json.append(",");
                }
            }

            json.append("]");
            out.print(json.toString());
            out.flush();

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\": \"Server error occurred: " + escape(e.getMessage()) + "\"}");
        } finally {
            if (conn != null) {
                DBConnection.disconnect(conn);
            }
            out.close();
        }
    }

    // Helper method to escape double quotes and other special characters in JSON
    private String escape(String str) {
        if (str == null) return "";
        return str.replace("\\", "\\\\")
                  .replace("\"", "\\\"")
                  .replace("\n", "")
                  .replace("\r", "");
    }
}
