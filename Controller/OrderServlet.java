package controller;

import model.CartItem;
import model.Order;
import model.OrderItem;
import model.Delivery;

import database.impl.CartDAOImpl;
import database.impl.OrderDAOImpl;
import database.impl.OrderItemDAOImpl;
import database.impl.DeliveryDAOImpl;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;
import java.util.*;
import org.json.JSONObject;

@WebServlet("/api/order")
public class OrderServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final CartDAOImpl cartDAO = new CartDAOImpl();
    private final OrderDAOImpl orderDAO = new OrderDAOImpl();
    private final OrderItemDAOImpl orderItemDAO = new OrderItemDAOImpl();
    private final DeliveryDAOImpl deliveryDAO = new DeliveryDAOImpl();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            // Read JSON request body
            BufferedReader reader = request.getReader();
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) sb.append(line);
            JSONObject reqBody = new JSONObject(sb.toString());

            // Validate customer ID
            if (!reqBody.has("custId")) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().print("{\"error\":\"Missing custId\"}");
                return;
            }

            int custId = reqBody.getInt("custId");

            // Get delivery ID
            HttpSession session = request.getSession(false);
            int deliveryId = -1;
            if (session != null && session.getAttribute("deliveryId") != null) {
                deliveryId = (int) session.getAttribute("deliveryId");
            } else if (reqBody.has("deliveryId")) {
                deliveryId = reqBody.getInt("deliveryId");
            }

            // Get delivery fee (default = 0.0)
            double deliveryFee = 0.0;
            if (deliveryId != -1) {
                Delivery delivery = deliveryDAO.getDeliveryById(deliveryId);
                if (delivery != null) {
                    deliveryFee = delivery.getDeliveryFee();
                }
            }

            // Fetch cart items for the customer
            List<CartItem> cartItems = cartDAO.getCartItems(custId);
            if (cartItems == null || cartItems.isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().print("{\"error\":\"Cart is empty\"}");
                return;
            }

            // Step 1: Create initial order
            Order order = new Order();
            order.setCustId(custId);
            order.setOrderDate(new java.sql.Date(System.currentTimeMillis()));
            order.setStatus("Pending");
            order.setTotalAmount(0.0); // will update later

            int orderId = orderDAO.createOrder(order);
            if (orderId == -1) {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().print("{\"error\":\"Failed to create order\"}");
                return;
            }

            // Step 2: Insert order items
            double subtotal = 0.0;
            for (CartItem item : cartItems) {
                OrderItem orderItem = new OrderItem();
                orderItem.setOrderId(orderId);
                orderItem.setProductId(item.getProduct().getId());
                orderItem.setVendorId(item.getProduct().getVendorId());
                orderItem.setQuantity(item.getQuantity());
                orderItem.setSubtotal(item.getSubtotal());
                orderItem.setItemStatus("Pending");

                orderItemDAO.createOrderItem(orderItem);
                subtotal += item.getSubtotal();
            }

            // Step 3: Update grand total
            double grandTotal = subtotal + deliveryFee;
            orderDAO.updateTotalAmount(orderId, grandTotal);

            // Step 4: Clear cart
            cartDAO.clearCartByCustomer(custId);

            // Step 5: Link delivery record
            if (deliveryId != -1) {
                deliveryDAO.updateDeliveryOrderId(deliveryId, orderId);
                if (session != null) {
                    session.removeAttribute("deliveryId");
                }
            }

            // Step 6: Return JSON response
            JSONObject resBody = new JSONObject();
            resBody.put("orderId", orderId);
            resBody.put("subtotal", String.format("%.2f", subtotal));
            resBody.put("deliveryFee", String.format("%.2f", deliveryFee));
            resBody.put("grandTotal", String.format("%.2f", grandTotal));

            response.setStatus(HttpServletResponse.SC_OK);
            response.getWriter().write(resBody.toString());

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().print("{\"error\":\"Server error: " + e.getMessage() + "\"}");
        }
    }
}
