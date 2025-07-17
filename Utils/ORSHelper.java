package util;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;

import org.json.JSONArray;
import org.json.JSONObject;

public class ORSHelper {
    private static final String API_KEY = "5b3ce3597851110001cf62480fe70891f2884104a85f3e8e3e767bbf";

    // 1. Geocode address to coordinates
    public static double[] geocodeAddress(String address) {
        try {
        	String urlStr = "https://api.openrouteservice.org/geocode/search"
        	        + "?api_key=" + API_KEY
        	        + "&text=" + URLEncoder.encode(address, "UTF-8")
        	        + "&boundary.country=MY"
        	        + "&focus.point.lat=2.2706"
        	        + "&focus.point.lon=102.2926"; // Mydin MITC


            URL url = new URL(urlStr);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");

            BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = in.readLine()) != null) sb.append(line);
            in.close();

            JSONObject json = new JSONObject(sb.toString());
            JSONArray features = json.getJSONArray("features");
            if (features.length() == 0) {
                System.out.println("Geocoding failed for address: " + address);
                return null;
            }

            JSONArray coords = features.getJSONObject(0)
                    .getJSONObject("geometry")
                    .getJSONArray("coordinates");
            double lon = coords.getDouble(0);
            double lat = coords.getDouble(1);

            System.out.println("Geocoded Address: " + address);
            System.out.println("Latitude: " + lat + ", Longitude: " + lon);

            return new double[]{lat, lon};
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }


    // 2. Get driving distance (km)
    public static double getDistanceInKm(double startLat, double startLng, double endLat, double endLng) {
        try {
            String body = new JSONObject()
                    .put("coordinates", new JSONArray()
                            .put(new JSONArray().put(startLng).put(startLat))
                            .put(new JSONArray().put(endLng).put(endLat)))
                    .toString();

            URL url = new URL("https://api.openrouteservice.org/v2/directions/driving-car");
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Authorization", API_KEY);
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setDoOutput(true);

            OutputStream os = conn.getOutputStream();
            os.write(body.getBytes());
            os.flush();
            os.close();

            BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = in.readLine()) != null) sb.append(line);
            in.close();

            JSONObject json = new JSONObject(sb.toString());
            double distanceMeters = json
                    .getJSONArray("routes")
                    .getJSONObject(0)
                    .getJSONObject("summary")
                    .getDouble("distance");

            return distanceMeters / 1000.0; // convert to kilometers
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

 // 3. Calculate delivery fee based on type
 // Original fallback method
    public static double calculateFee(double distanceKm) {
        return calculateFee(distanceKm, "Standard");
    }

    
    public static double calculateFee(double distanceKm, String deliveryType) {
        double ratePerKm;

        if ("Express".equalsIgnoreCase(deliveryType)) {
            ratePerKm = 0.45; // higher rate for Express
        } else {
            ratePerKm = 0.35; // default for Standard
        }

        return Math.round(distanceKm * ratePerKm * 100.0) / 100.0;
    }

}
