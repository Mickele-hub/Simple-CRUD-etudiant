<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.ResultSet, java.sql.SQLException" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Modifier un Étudiant</title>
    <!-- Inclure Bootstrap -->
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <!-- Inclure Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f0f2f5;
            font-family: 'Roboto', sans-serif;
            padding: 20px;
        }
        .container {
            max-width: 600px;
            margin: auto;
            background: #ffffff;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 6px 12px rgba(0, 0, 0, 0.1);
            animation: slideIn 0.8s ease-out;
        }
        @keyframes slideIn {
            from { transform: translateY(20px); opacity: 0; }
            to { transform: translateY(0); opacity: 1; }
        }
        h1 {
            color: #333;
            margin-bottom: 30px;
            text-align: center;
        }
        .btn-primary {
            background-color: #007bff;
            border-color: #007bff;
            transition: background-color 0.3s, transform 0.3s;
        }
        .btn-primary:hover {
            background-color: #0056b3;
            transform: translateY(-2px);
        }
        .alert {
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Modifier un Étudiant</h1>
        <%
            String numEl = request.getParameter("numEl");
            String nom = "";
            double moyenne = 0.0;

            String url = "jdbc:mysql://localhost:3306/gestion_etudiants";
            String user = "root";
            String password = "Madarauchiwa1560";

            if (request.getMethod().equalsIgnoreCase("POST")) {
                nom = request.getParameter("nom");
                moyenne = Double.parseDouble(request.getParameter("moyenne"));

                try (Connection connection = DriverManager.getConnection(url, user, password)) {
                    String sql = "UPDATE etudiants SET nom = ?, moyenne = ? WHERE numEl = ?";
                    try (PreparedStatement statement = connection.prepareStatement(sql)) {
                        statement.setString(1, nom);
                        statement.setDouble(2, moyenne);
                        statement.setString(3, numEl);
                        statement.executeUpdate();
                        out.println("<div class='alert alert-success'>Étudiant modifié avec succès!</div>");
                    }
                } catch (SQLException e) {
                    out.println("<div class='alert alert-danger'>Erreur lors de la modification de l'étudiant: " + e.getMessage() + "</div>");
                }
            } else {
                try (Connection connection = DriverManager.getConnection(url, user, password)) {
                    String sql = "SELECT nom, moyenne FROM etudiants WHERE numEl = ?";
                    try (PreparedStatement statement = connection.prepareStatement(sql)) {
                        statement.setString(1, numEl);
                        try (ResultSet resultSet = statement.executeQuery()) {
                            if (resultSet.next()) {
                                nom = resultSet.getString("nom");
                                moyenne = resultSet.getDouble("moyenne");
                            }
                        }
                    }
                } catch (SQLException e) {
                    out.println("<div class='alert alert-danger'>Erreur lors de la récupération des données de l'étudiant: " + e.getMessage() + "</div>");
                }
            }
        %>
        <form method="post">
            <div class="form-group position-relative">
                <input type="text" class="form-control" id="nom" name="nom" value="<%= nom %>" placeholder="Nom" required 
                       style="padding-left: 40px; height: 45px;">
                <i class="fas fa-user position-absolute" 
                   style="left: 10px; top: 50%; transform: translateY(-50%); color: grey; font-size: 18px;"></i>
            </div>
            
            <div class="form-group position-relative mt-3">
                <input type="number" step="0.01" class="form-control" id="moyenne" name="moyenne" value="<%= moyenne %>" placeholder="Moyenne" required 
                       style="padding-left: 40px; height: 45px;">
                <i class="fas fa-percentage position-absolute" 
                   style="left: 10px; top: 50%; transform: translateY(-50%); color: grey; font-size: 18px;"></i>
            </div>
        
            <button type="submit" class="btn btn-primary btn-block mt-4" style="height: 45px;">Modifier</button>
        </form>
        


        <div class="text-center mt-2">
            <a href="listStudents.jsp" class="btn btn-primary shadow-sm my-2">
                <i class="fas fa-list"></i> Retourner voir la liste des étudiants
            </a>
        </div>
    </div>
</body>
</html> 