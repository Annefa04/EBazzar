# eBaazar System
The eBazaar System is a web-based online marketplace designed to digitize traditional bazaar operations.

# Backend Application
### Technology Stack
### Language: Java
### Framework: Java Servlets (using MVC pattern)
### Database: MySQL (via JDBC + DAO pattern)
### IDE: Eclipse IDE for Enterprise Java
### Server: Apache Tomcat

# eBaazar System
The eBazaar System is a web-based online marketplace designed to digitize traditional bazaar operations.

#Backend Application
Technology Stack
Language: Java
Framework: Java Servlets (using MVC pattern)
Database: MySQL (via JDBC + DAO pattern)
IDE: Eclipse IDE for Enterprise Java
Server: Apache Tomcat

# Frontend Application
### 1) Customer Frontend
   The customer-facing frontend is a web application designed to provide a smooth shopping experience for customers who visit the eBazaar platform. Its main functions include allowing customers to register or log in, browse vendors and products, add items to their cart, confirm orders and review their order history. This application is intended for general users who wish to make purchases from local vendors through the eBazaar platform.

The frontend was developed using standard web technologies such as HTML, CSS and JavaScript. We used JSP (JavaServer Pages) for dynamic page rendering and relied on client-side scripting to manage UI behavior and make API calls. The application utilizes the Fetch API to interact with the backend server and uses localStorage to temporarily store customer information such as customer ID and name after login. This enables session-like persistence across multiple pages without requiring server-side sessions.

The frontend communicates with the backend by calling dedicated REST API endpoints. For example:

  > To authenticate the customer, it sends a POST request to /api/login.

  > To fetch the list of vendors, it calls GET /api/vendors.

  > To retrieve products of a selected vendor, it sends a GET request to /api/vendor/products?vendorId=....

  > When confirming an order, it sends order details using POST /api/orders.

  > For displaying the customer's past orders, it requests GET /api/customer/orders?custId=....

All these interactions are handled using JavaScript's fetch() function and the responses are processed dynamically to update the user interface.



