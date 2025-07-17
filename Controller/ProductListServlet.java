package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import database.ProductDAO;
import database.impl.ProductDAOImpl;
import model.Product;

@WebServlet("/api/products")
public class ProductListServlet extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private ProductDAO productDAO;

    @Override
    public void init() {
        productDAO = new ProductDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String vendorIdStr = request.getParameter("vendorId");
        System.out.println("[DEBUG] vendorIdStr = " + vendorIdStr);

        try (PrintWriter out = response.getWriter()) {

            if (vendorIdStr == null || vendorIdStr.trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"error\": \"Missing vendorId parameter\"}");
                System.out.println("[ERROR] vendorId parameter is missing or empty");
                return;
            }

            int vendorId;
            try {
                vendorId = Integer.parseInt(vendorIdStr);
                System.out.println("[DEBUG] Parsed vendorId = " + vendorId);
            } catch (NumberFormatException e) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"error\": \"Invalid vendorId format\"}");
                System.out.println("[ERROR] vendorId is not a valid integer");
                return;
            }

            List<Product> products = productDAO.getProductsByVendorId(vendorId);
            System.out.println("[DEBUG] Retrieved " + products.size() + " products for vendorId " + vendorId);

            out.print("[");
            for (int i = 0; i < products.size(); i++) {
                Product p = products.get(i);

                String safeName = p.getName().replace("\"", "\\\"");
                String safeDesc = p.getDescription().replace("\"", "\\\"");
                double price = p.getPrice();

                out.print("{\"id\":" + p.getId() +
                        ",\"name\":\"" + safeName +
                        "\",\"description\":\"" + safeDesc +
                        "\",\"price\":" + price + "}");

                if (i < products.size() - 1) {
                    out.print(",");
                }
            }
            out.print("]");

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().print("{\"error\": \"Server error while retrieving products\"}");
            System.out.println("[ERROR] Exception: " + e.getMessage());
        }
    }
}
