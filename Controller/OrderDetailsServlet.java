package controller;

import database.impl.OrderDetailsDAOImpl;
import model.OrderDetails;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/api/customer/orders")
public class OrderDetailsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private OrderDetailsDAOImpl dao;

    @Override
    public void init() {
        dao = new OrderDetailsDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String custIdStr = request.getParameter("custId");
        System.out.println("[DEBUG] custIdStr = " + custIdStr);

        try (PrintWriter out = response.getWriter()) {

            if (custIdStr == null || custIdStr.trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"error\": \"Missing custId parameter\"}");
                System.out.println("[ERROR] custId parameter is missing or empty");
                return;
            }

            int custId;
            try {
                custId = Integer.parseInt(custIdStr);
                System.out.println("[DEBUG] Parsed custId = " + custId);
            } catch (NumberFormatException e) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"error\": \"Invalid custId format\"}");
                System.out.println("[ERROR] custId is not a valid integer");
                return;
            }

            List<OrderDetails> orders = dao.getOrderDetailsByCustomerId(custId);
            System.out.println("[DEBUG] Retrieved " + orders.size() + " orders for custId " + custId);

            out.print("[");
            for (int i = 0; i < orders.size(); i++) {
                OrderDetails o = orders.get(i);

                String safeCustName = o.getCustName().replace("\"", "\\\"");
                String safeProdName = o.getProductName().replace("\"", "\\\"");
                String safeVendName = o.getVendorName().replace("\"", "\\\"");
                String safeItemStatus = o.getItemStatus().replace("\"", "\\\"");
                String safeDeliveryStatus = o.getDeliveryStatus() != null
                        ? o.getDeliveryStatus().replace("\"", "\\\"")
                        : "";

                out.print("{\"custId\":" + o.getCustId() +
                        ",\"custName\":\"" + safeCustName +
                        "\",\"orderId\":" + o.getOrderId() +
                        ",\"orderDate\":\"" + o.getOrderDate() +
                        "\",\"deliveryStatus\":\"" + safeDeliveryStatus +
                        "\",\"totalAmount\":" + o.getTotalAmount() +
                        ",\"productName\":\"" + safeProdName +
                        "\",\"vendorName\":\"" + safeVendName +
                        "\",\"quantity\":" + o.getQuantity() +
                        ",\"itemStatus\":\"" + safeItemStatus + "\"}");

                if (i < orders.size() - 1) {
                    out.print(",");
                }
            }
            out.print("]");

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().print("{\"error\": \"Server error while retrieving orders\"}");
            System.out.println("[ERROR] Exception: " + e.getMessage());
        }
    }
}
