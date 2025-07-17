package controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import database.CartDAO;
import database.impl.CartDAOImpl;
import model.CartItem;
import model.Product;

@WebServlet("/api/cart")
public class CartItemServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private CartDAO cartDAO;

    @Override
    public void init() {
        cartDAO = new CartDAOImpl();
    }

    private JSONObject readJsonBody(HttpServletRequest request) throws IOException, JSONException {
        BufferedReader reader = request.getReader();
        StringBuilder jsonBuilder = new StringBuilder();
        String line;
        while ((line = reader.readLine()) != null) {
            jsonBuilder.append(line);
        }
        return new JSONObject(jsonBuilder.toString());
    }

    private void setCORS(HttpServletResponse response) {
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS");
        response.setHeader("Access-Control-Allow-Headers", "Content-Type");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
    }

    @Override
    protected void doOptions(HttpServletRequest req, HttpServletResponse resp) {
        setCORS(resp); // for CORS preflight
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        setCORS(response);

        try {
            JSONObject obj = readJsonBody(request);

            if (!obj.has("custId") || !obj.has("productId") || !obj.has("quantity")) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().print("{\"error\": \"Missing one or more fields: custId, productId, quantity\"}");
                return;
            }

            int custId = obj.getInt("custId");
            int productId = obj.getInt("productId");
            int quantity = obj.getInt("quantity");

            cartDAO.addToCart(custId, productId, quantity);

            try (PrintWriter out = response.getWriter()) {
                out.print("{\"message\": \"Item added to cart successfully\"}");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().print("{\"error\": \"Invalid request data\"}");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        setCORS(response);

        String custIdStr = request.getParameter("custId");
        if (custIdStr == null || custIdStr.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().print("{\"error\": \"Missing custId parameter\"}");
            return;
        }

        try (PrintWriter out = response.getWriter()) {
            int custId = Integer.parseInt(custIdStr);
            List<CartItem> cartItems = cartDAO.getCartItems(custId);

            JSONArray arr = new JSONArray();
            for (CartItem item : cartItems) {
                JSONObject obj = new JSONObject();
                Product p = item.getProduct();

                obj.put("productId", p.getId());
                obj.put("vendorId", p.getVendorId());
                obj.put("productName", p.getName());
                obj.put("description", p.getDescription());
                obj.put("price", p.getPrice());
                obj.put("quantity", item.getQuantity());
                obj.put("subtotal", item.getSubtotal());

                arr.put(obj);
            }

            out.print(arr.toString());

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().print("{\"error\": \"Invalid custId format\"}");
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().print("{\"error\": \"Server error while retrieving cart items\"}");
        }
    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response) throws IOException {
        setCORS(response);

        try {
            JSONObject obj = readJsonBody(request);

            if (!obj.has("custId") || !obj.has("productId")) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().print("{\"error\": \"Missing custId or productId\"}");
                return;
            }

            int custId = obj.getInt("custId");
            int productId = obj.getInt("productId");

            cartDAO.removeFromCart(custId, productId);

            try (PrintWriter out = response.getWriter()) {
                out.print("{\"message\": \"Item removed from cart successfully\"}");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().print("{\"error\": \"Invalid request data for deletion\"}");
        }
    }

    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response) throws IOException {
        setCORS(response);

        try {
            JSONObject obj = readJsonBody(request);

            if (!obj.has("custId") || !obj.has("productId") || !obj.has("quantity")) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().print("{\"error\": \"Missing custId, productId, or quantity\"}");
                return;
            }

            int custId = obj.getInt("custId");
            int productId = obj.getInt("productId");
            int quantity = obj.getInt("quantity");

            cartDAO.updateCartItemQuantity(custId, productId, quantity);

            try (PrintWriter out = response.getWriter()) {
                out.print("{\"message\": \"Cart item quantity updated successfully\"}");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().print("{\"error\": \"Invalid request data for update\"}");
        }
    }

}
