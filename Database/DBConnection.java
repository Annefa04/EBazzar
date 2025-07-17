package database;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    // Configuration
    private static final String URL = "jdbc:mysql://localhost:3306/";
    private static final String DB_NAME = "ebazaar";
    private static final String USER = "root";
    private static final String PASSWORD = ""; // Change this if needed
    private static final String PARAMS = "?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver"); // Load once when class loads
            System.out.println("🔄 JDBC Driver loaded.");
        } catch (ClassNotFoundException e) {
            System.out.println("❌ MySQL JDBC Driver not found.");
            e.printStackTrace();
        }
    }

    /**
     * Get a database connection.
     */
    public static Connection getConnection() {
        Connection conn = null;
        String fullURL = URL + DB_NAME + PARAMS;
        try {
            conn = DriverManager.getConnection(fullURL, USER, PASSWORD);
            System.out.println("✅ Connected to DB: " + fullURL);
        } catch (SQLException e) {
            System.out.println("❌ Failed to connect to DB:");
            e.printStackTrace();
        }
        return conn;
    }

    /**
     * Disconnect from the database safely.
     */
    public static void disconnect(Connection conn) {
        try {
            if (conn != null && !conn.isClosed()) {
                conn.close();
                System.out.println("🔌 Connection closed.");
            }
        } catch (SQLException e) {
            System.out.println("⚠️ Error closing DB connection:");
            e.printStackTrace();
        }
    }

    /**
     * Test the DB connection.
     */
    public static void main(String[] args) {
        Connection conn = getConnection();
        if (conn != null) {
            System.out.println("✅ Test connection successful.");
        } else {
            System.out.println("❌ Test connection failed.");
        }
        disconnect(conn);
    }
}
