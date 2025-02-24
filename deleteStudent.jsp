<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.SQLException" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String numEl = request.getParameter("numEl");

    String url = "jdbc:mysql://localhost:3306/gestion_etudiants";
    String user = "root";
    String password = "Madarauchiwa1560";

    try (Connection connection = DriverManager.getConnection(url, user, password)) {
        String sql = "DELETE FROM etudiants WHERE numEl = ?";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, numEl);
            statement.executeUpdate();
        }
    } catch (SQLException e) {
        out.println("<div class='alert alert-danger'>Erreur lors de la suppression de l'étudiant: " + e.getMessage() + "</div>");
    }

    response.sendRedirect("listStudents.jsp");
%> 