package controller;

import database.AuthDAO;
import database.impl.AuthDAOImpl;
import model.Rider;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/api/loginrider")
public class LoginRiderServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private AuthDAO authDAO;

    @Override
    public void init() {
        authDAO = new AuthDAOImpl();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try (PrintWriter out = response.getWriter()) {
            Rider rider = authDAO.validateRider(email, password);

            if (rider != null) {
                out.print("{ \"success\": true, " +
                          "\"riderName\": \"" + escapeJson(rider.getRiderName()) + "\"," +
                          "\"riderId\": " + rider.getRiderId() + " }");
            } else {
                out.print("{ \"success\": false, \"message\": \"Invalid credentials\" }");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(500);
            try (PrintWriter out = response.getWriter()) {
                out.print("{ \"success\": false, \"message\": \"Server error\" }");
            }
        }
    }

    // Optional: escape JSON string
    private String escapeJson(String str) {
        return str.replace("\"", "\\\"").replace("\n", "").replace("\r", "");
    }
}
