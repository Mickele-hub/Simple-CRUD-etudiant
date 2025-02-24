<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.SQLException" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Test de Connexion à la Base de Données</title>
</head>
<body>
    <h1>Test de Connexion à la Base de Données</h1>
    <%
        String url = "jdbc:mysql://localhost:3306/gestion_etudiants";
        String user = "root";
        String password = "Madarauchiwa1560";
        Connection connection = null;
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            connection = DriverManager.getConnection(url, user, password);
            out.println("<p>Connexion réussie à la base de données!</p>");
        } catch (ClassNotFoundException e) {
            out.println("<p>Erreur: Pilote JDBC non trouvé.</p>");
        } catch (SQLException e) {
            out.println("<p>Erreur: Impossible de se connecter à la base de données.</p>");
            out.println("<p>" + e.getMessage() + "</p>");
        } finally {
            if (connection != null) {
                try {
                    connection.close();
                } catch (SQLException e) {
                    out.println("<p>Erreur lors de la fermeture de la connexion.</p>");
                }
            }
        }
    %>
</body>
</html> 