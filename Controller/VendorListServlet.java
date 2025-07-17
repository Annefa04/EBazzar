package controller;

import database.VendorDAO;
import database.impl.VendorDAOImpl;
import model.Vendor;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.io.*;
import java.util.List;

@WebServlet("/api/vendors")
public class VendorListServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private VendorDAO vendorDAO;

    @Override
    public void init() {
        vendorDAO = new VendorDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try (PrintWriter out = response.getWriter()) {
            List<Vendor> vendors = vendorDAO.getAllVendors();

            out.print("[");
            for (int i = 0; i < vendors.size(); i++) {
                Vendor v = vendors.get(i);
                out.print("{\"id\":" + v.getVendId()
                        + ",\"name\":\"" + v.getVendName().replace("\"", "\\\"")
                        + "\"}");
                if (i < vendors.size() - 1) out.print(",");
            }
            out.print("]");

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(500);
        }
    }
}
