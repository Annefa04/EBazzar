# eBaazar System
### Introduction
The eBazaar System is designed as a web-based online marketplace requiring backward integration of modernization and digitalization of the business of conventional community-based bazaars. It is being created manually with the focus on ease of use by customer in various user roles. The system allows integrating user registration and login, user interface displaying vendor management and vendor products, posting items to a cart, selecting delivery method and method of payment, order confirmation and review of an order history. Besides, the vendors will get their own interface in which they will be able to see the incoming orders by the customers as well as they will be able to update the status of each order as per the preparation steps. The system also allow the riders to see the list of available orders and change the status of the delivery including recording it as in transit, pending or delivered. The multi-role design makes the digital experience comprehensive and well arranged to all sides involved. Generally, eBazaar System facilitates flexibility, openness and accessibility, encouraging the digital interactions of customers, vendors and riders which will make the traditional bazaars enter a new era.

### Third-Party Integration

# System Architecture

# Backend Application
### Technology Stack
Language: Java
Framework: Java Servlets (using MVC pattern)
Database: MySQL (via JDBC + DAO pattern)
IDE: Eclipse IDE for Enterprise Java
Server: Apache Tomcat

### API Documentation
API Endpoint
- http://localhost:8080/eBazaar/loginrider
- http://localhost:8080/eBazaar/loginvendor
- http://localhost:8080/eBazaar/viewdelivery
- http://localhost:8080/eBazaar/ViewOrderVendor
- http://localhost:8080/eBazaar/updateDeliveryStatus
- http://localhost:8080/eBazaar/acceptOrder




# Frontend Application
### 1) Customer Frontend
   The customer-facing frontend is a web application designed to provide a smooth shopping experience for customers who visit the eBazaar platform. Its main functions include allowing customers to register or log in, browse vendors and products, add items to their cart, confirm orders and review their order history. This application is intended for general users who wish to make purchases from local vendors through the eBazaar platform.

The frontend was developed using standard web technologies such as HTML, CSS and JavaScript. We used JSP (JavaServer Pages) for dynamic page rendering and relied on client-side scripting to manage UI behavior and make API calls. The application utilizes the Fetch API to interact with the backend server and uses localStorage to temporarily store customer information such as customer ID and name after login. This enables session-like persistence across multiple pages without requiring server-side sessions.

The frontend communicates with the backend by calling dedicated REST API endpoints. For example:

   - To authenticate the customer, it sends a POST request to /api/login.
   -  To fetch the list of vendors, it calls GET /api/vendors.
   -  To retrieve products of a selected vendor, it sends a GET request to /api/vendor/products?vendorId=....
   -  When confirming an order, it sends order details using POST /api/orders.
   -  For displaying the customer's past orders, it requests GET /api/customer/orders?custId=....

All these interactions are handled using JavaScript's fetch() function and the responses are processed dynamically to update the user interface.

### 2) Vendor Frontend
   The vendor‑owner frontend is a web application that empowers individual stall owners to manage every stage of their online bazaar presence. After authentication, a vendor lands on an intuitive dashboard that immediately greets them by name and lists all incoming pre‑orders filtered to their Vend_ID.

One of the core functions is the real-time preorder queue. Orders arrive with the status Pending and are displayed in a Bootstrap‑styled table. Vendors can update the status of each order using action buttons such as "Preparing", "Ready for Pickup", or "Rejected". These buttons trigger a fetch() POST request to /updateItemStatus, which ensures that riders and customers receive live updates on order progress.

The frontend communicates with the backend by calling dedicated REST API endpoints. For example:
   - To authenticate the vendor, it sends a POST request to /api/loginvendor with the vendor’s email and password. On success, it stores vendName and vendId in localStorage.
   - To fetch the list of preorders assigned to the logged-in vendor, it sends a GET request to /vendor/viewOrderVendor?vendId=.... The response contains a JSON object with an array of order items filtered by that vendor ID.
   - To update the status of a specific order item (e.g., "Preparing", "Ready for Pickup", or "Rejected"), the vendor UI sends a POST request to /updateItemStatus with the body parameters orderItemId and status.

All these interactions are handled using JavaScript’s fetch() function. The frontend processes the responses dynamically, refreshing the table and displaying alerts without reloading the page. Vendor login persistence is maintained using localStorage, and each operation is secured by backend session validation (vendId), ensuring that vendors can only manage their own orders.

### 3) Rider Frontend

# Database Design
## Entity-Relationship Diagram (ERD)
![eBazaar ERD](ERDeBazaar.jpg)

## Schema Justification
The system’s database is designed based on normalized relational principles to avoid data redundancy and ensure data consistency. The database consists of several main tables, including:

- Customer – stores customer details

- Vendor – stores vendor details

- Product – stores products offered by vendors

- Cart – temporary storage for products added to the cart

- Order – main record of an order placed by a customer

- OrderItem (bridge table) – details of individual items within an order

- Delivery – records delivery status for each order

Each table includes primary and foreign keys to establish one-to-many relationships, such as:
   - Each customer can places many orders, but each order can only be placed by one customer.
   - Customer can own one cart.
   - Each cart can add many products, but each product can be added to one cart,
   - Each vendor can prepares many orders from customers, and each orders can be prepared by many vendors.
   - Each vendor can sells many products, but each product can be sold by one vendor.
   - Each rider can handles many delivery, but each delivery can be handled by one rider.
   - Each delivery is associated with many orders, but each order is associate with one delivery.
   - Each product can be include in many orders, and each orders can include many products.

The OrderItem table acts as a bridge table between the Order and Product entities & Order and Vendor entities. This enables us to track multiple products within a single order and capture vendor information, quantities, and item statuses individually.

# Business Logic and Data Validation

## Use case
![eBazaar Use Case](UseCase.jpg)

## Data Validation

### FrontEnd
In the eBazaar System, frontend validation is implemented using JavaScript to enhance user experience and prevent invalid data from reaching the backend. For example, on the customer, vendor and rider login page, the system ensures that both the email and password fields are filled before allowing submission and displays error messages if either field is empty. During checkout, users are required to provide a delivery address and select a payment method before confirming their order with alerts triggered if these inputs are missing. Additionally, the system checks localStorage to ensure that user session data such as custId and custName exist to  prevent unauthorized access to restricted pages like the cart or order history same goes to vendor that also use localstorage but rider use Url Query String. These client-side validations provide immediate feedback, reduce server load and help maintain data quality.

