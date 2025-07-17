package database;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {

    // Database Configuration
    private static final String URL = "jdbc:mysql://localhost:3306/";
    private static final String DBNAME = "ebazaar";
    private static final String USER = "root";
    private static final String PASSWORD = ""; // If you use "root", change this
    private static final String PARAMS = "?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";

    /**
     * Get a connection to the MySQL database.
     */
    public static Connection getConnection() {
        Connection conn = null;
        try {
            // Load MySQL JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Build full JDBC URL
            String fullURL = URL + DBNAME + PARAMS;
            System.out.println("🔍 Connecting to: " + fullURL + " with user: " + USER);

            // Try to connect
            conn = DriverManager.getConnection(fullURL, USER, PASSWORD);
            System.out.println("✅ DB connection successful.");
        } catch (Exception e) {
            System.out.println("❌ Failed to connect to database:");
            e.printStackTrace();
        }

        return conn;
    }

    /**
     * Close the connection safely.
     */
    public static void disconnect(Connection conn) {
        try {
            if (conn != null && !conn.isClosed()) {
                conn.close();
                System.out.println("🔌 Connection closed.");
            }
        } catch (Exception e) {
            System.out.println("⚠️ Error while closing connection:");
            e.printStackTrace();
        }
    }

    /**
     * Test method - run this to test the DB connection from Eclipse
     */
    public static void main(String[] args) {
        Connection conn = getConnection();

        if (conn != null) {
            System.out.println("✅ Connected to MySQL database.");
        } else {
            System.out.println("❌ Not Connected. Please check DB config.");
        }

        disconnect(conn);
    }
}
