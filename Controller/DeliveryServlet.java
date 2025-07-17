package controller;

import model.Delivery;
import database.DeliveryDAO;
import database.impl.CartDAOImpl;
import database.impl.DeliveryDAOImpl;
import util.ORSHelper;
import org.json.JSONObject;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.BufferedReader;
import java.io.IOException;

@WebServlet("/api/delivery")
public class DeliveryServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final DeliveryDAO deliveryDAO = new DeliveryDAOImpl();
    private final CartDAOImpl cartDAO = new CartDAOImpl();

    // Mydin coordinates (hardcoded as pickup location)
    private static final double PICKUP_LAT = 2.2599;
    private static final double PICKUP_LNG = 102.2945;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        try (BufferedReader reader = req.getReader()) {
            // Step 1: Read JSON request body
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) sb.append(line);
            JSONObject requestBody = new JSONObject(sb.toString());

            // Step 2: Extract input fields
            String address = requestBody.getString("address");
            String deliveryType = requestBody.getString("deliveryType");
            String paymentMethod = requestBody.getString("paymentMethod");
            int custId = requestBody.getInt("custId");

            // Step 3: Geocode delivery address
            double[] coords = ORSHelper.geocodeAddress(address);
            if (coords == null) {
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                resp.getWriter().print("{\"error\":\"Invalid address or geocoding failed\"}");
                return;
            }

            double lat = coords[0];
            double lon = coords[1];

            // Step 4: Calculate distance in kilometers
            double distanceKm = ORSHelper.getDistanceInKm(PICKUP_LAT, PICKUP_LNG, lat, lon);
            if (distanceKm < 0) {
                resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                resp.getWriter().print("{\"error\":\"Failed to calculate distance\"}");
                return;
            }

            // Step 5: Calculate delivery fee based on type and distance
            double deliveryFee = ORSHelper.calculateFee(distanceKm, deliveryType);

            // ✅ Step 6: Get subtotal from database based on custId
            double subtotal = cartDAO.calculateSubtotal(custId);
            double grandTotal = subtotal + deliveryFee;

            // Step 7: Create Delivery object
            Delivery delivery = new Delivery();
            delivery.setAddress(address);
            delivery.setDeliveryType(deliveryType);
            delivery.setPaymentMethod(paymentMethod);
            delivery.setDeliveryStatus("Pending");
            delivery.setDistanceKm(distanceKm);
            delivery.setDeliveryFee(deliveryFee);
            delivery.setOrderId(null); // Order will be linked later

            // Step 8: Insert delivery into database
            int deliveryId = deliveryDAO.addDelivery(delivery);

            // Step 9: Send response back to frontend
            JSONObject res = new JSONObject();
            res.put("deliveryId", deliveryId);
            res.put("distanceKm", String.format("%.2f", distanceKm));
            res.put("deliveryFee", String.format("%.2f", deliveryFee));
            res.put("subtotal", String.format("%.2f", subtotal));           // ✅ Subtotal included
            res.put("grandTotal", String.format("%.2f", grandTotal));       // ✅ Grand total too
            res.put("message", "Delivery added successfully and fee calculated.");

            resp.getWriter().print(res.toString());

        } catch (Exception e) {
            e.printStackTrace();
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().print("{\"error\":\"Internal server error\"}");
        }
    }
}
