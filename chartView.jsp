<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.ResultSet, java.sql.Statement, java.sql.SQLException" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Visualisation des Moyennes</title>
    <!-- Inclure Bootstrap -->
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <!-- Inclure Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap" rel="stylesheet">
    <!-- Inclure Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #e9ecef;
            font-family: 'Roboto', sans-serif;
            padding: 20px;
        }
        .container {
            max-width: 600px;
            margin: auto;
            background: #ffffff;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            animation: slideIn 0.8s ease-out;
        }
        @keyframes slideIn {
            from { transform: translateY(20px); opacity: 0; }
            to { transform: translateY(0); opacity: 1; }
        }
        h1 {
            color: #343a40;
            margin-bottom: 20px;
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
    </style>
</head>
<body>
    <div class="container">
        <h1>Visualisation des Moyennes</h1>
        <canvas id="moyenneChart" width="400" height="400"></canvas>
        <div class="text-center mt-2">
            <a href="listStudents.jsp" class="btn btn-primary shadow-sm my-2">
                <i class="fas fa-list"></i> Retourner voir la liste des étudiants
            </a>
        </div>
    </div>

    <%
        String url = "jdbc:mysql://localhost:3306/gestion_etudiants";
        String user = "root";
        String password = "Madarauchiwa1560";

        double totalMoyenne = 0;
        double minMoyenne = Double.MAX_VALUE;
        double maxMoyenne = Double.MIN_VALUE;
        int count = 0;

        try (Connection connection = DriverManager.getConnection(url, user, password);
             Statement statement = connection.createStatement()) {
            String sql = "SELECT moyenne FROM etudiants";
            try (ResultSet resultSet = statement.executeQuery(sql)) {
                while (resultSet.next()) {
                    double moyenne = resultSet.getDouble("moyenne");
                    totalMoyenne += moyenne;
                    if (moyenne < minMoyenne) minMoyenne = moyenne;
                    if (moyenne > maxMoyenne) maxMoyenne = moyenne;
                    count++;
                }
            }
        } catch (SQLException e) {
            out.println("<div class='alert alert-danger'>Erreur lors de la récupération des moyennes: " + e.getMessage() + "</div>");
        }

        double moyenneClasse = count > 0 ? totalMoyenne / count : 0;
    %>

    <script>
        const ctx = document.getElementById('moyenneChart').getContext('2d');
        const moyenneChart = new Chart(ctx, {
            type: 'pie',
            data: {
                labels: ['Moyenne de la classe', 'Moyenne minimale', 'Moyenne maximale'],
                datasets: [{
                    data: [<%= moyenneClasse %>, <%= minMoyenne %>, <%= maxMoyenne %>],
                    backgroundColor: ['#007bff', '#dc3545','#28a745' ],
                    hoverOffset: 4,
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: {
                        position: 'top',
                    },
                    title: {
                        display: true,
                        text: 'Distribution des Moyennes'
                    }
                }
            }
        });
    </script>
</body>
</html> 