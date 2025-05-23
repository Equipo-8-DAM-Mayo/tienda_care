<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, com.tienda.utils.DBConnection" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    String idParam = request.getParameter("customer_id");
    int customerId = -1;

    String name = "", email = "", phone = "", address = "";
    String registrationDate = "";

    if (idParam != null && !idParam.isEmpty()) {
        customerId = Integer.parseInt(idParam);

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement("SELECT * FROM customers WHERE customer_id = ?")) {

            stmt.setInt(1, customerId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    name = rs.getString("name");
                    email = rs.getString("email");
                    phone = rs.getString("phone");
                    address = rs.getString("address");
                    Date date = rs.getDate("registration_date");

                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                    registrationDate = sdf.format(date);
                } else {
                    out.println("<p style='color:red;'>Cliente no encontrado.</p>");
                    return;
                }
            }
        } catch (Exception e) {
            out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
            return;
        }
    } else {
        out.println("<p style='color:red;'>ID de cliente no válido.</p>");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Editar Cliente</title>
    <meta charset="UTF-8">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <!-- BOOTSTRAP 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

    <!-- CSS PERSONALIZADO -->
    <link rel="stylesheet" href="css/style.css">
    <link rel="icon" href="img/logo.jpg" type="image/x-icon">
</head>
<body>
<header class="bg-light py-3 shadow-sm mb-4">
    <div class="container header-container">
        <img src="img/logo.png" alt="Care Logo" class="logo">
        <h1 class="h3 mb-0">Care</h1>
        <nav>
            <a href="index.jsp" class="text-decoration-none text-dark fw-semibold">Home</a>
            <a href="products" class="text-decoration-none text-dark fw-semibold">Products</a>
            <a href="customers" class="text-decoration-none text-dark fw-semibold">Customers</a>
        </nav>
    </div>
</header>

<h1>✏️ Edit customer</h1>

<div class="form-container">
    <form method="post" action="edit-customer">
        <input type="hidden" name="customer_id" value="<%= customerId %>">

        <label for="name">Name *</label>
        <input type="text" id="name" name="name" required value="<%= name %>">

        <label for="email">Email</label>
        <input type="email" id="email" name="email" value="<%= email %>">

        <label for="phone">Phone</label>
        <input type="tel" id="phone" name="phone" value="<%= phone %>">

        <label for="address">Address</label>
        <input type="text" id="address" name="address" value="<%= address %>">

        <label for="registration_date">Registration date *</label>
        <input type="date" id="registration_date" name="registration_date" required value="<%= registrationDate %>">

        <div class="actions">
            <button type="submit" class="btn btn-save">Save changes</button>
            <a href="customers" class="btn btn-cancel">Cancel</a>
        </div>
    </form>
</div>

</body>
</html>
