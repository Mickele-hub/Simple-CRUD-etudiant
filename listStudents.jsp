<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.ResultSet, java.sql.Statement, java.sql.SQLException" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Liste des Étudiants</title>
    <!-- Inclure Bootstrap -->
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <!-- Inclure Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" rel="stylesheet">
    
    <style>
        body {
            background-color: #e9ecef;
            font-family: 'Roboto', sans-serif;
            padding: 20px;
        }
        .container {
            max-width: 800px;
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
        }
        .table-striped tbody tr:nth-of-type(odd) {
            background-color: rgba(0, 123, 255, 0.05);
        }
        .btn-link {
            color: #007bff;
            transition: color 0.3s, transform 0.3s;
        }
        .btn-link:hover {
            color: #0056b3;
            transform: translateY(-2px);
        }
        .alert {
            margin-top: 20px;
        }
        .stats {
            display: flex;
            justify-content: space-around;
            margin-top: 20px;
        }
        .stat-box {
            flex: 1;
            margin: 0 10px;
            padding: 20px;
            background-color: #f8f9fa;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            text-align: center;
            transition: transform 0.3s;
        }
        .stat-box:hover {
            transform: scale(1.05);
        }
        .stat-box h5 {
            margin-bottom: 10px;
            color: #333;
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
        <h1 class="text-center">Liste des Étudiants</h1>

        <table class="table table-striped">
            <thead>
                <tr>
                    <th>Nom</th>
                    <th>Moyenne</th>
                    <th>Observation</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <%
                    String url = "jdbc:mysql://localhost:3306/gestion_etudiants";
                    String user = "root";
                    String password = "Madarauchiwa1560";
            
                    double totalMoyenne = 0;
                    double minMoyenne = Double.MAX_VALUE;
                    double maxMoyenne = Double.MIN_VALUE;
                    int count = 0;
                    boolean etudiantTrouve = false; // Variable pour vérifier si des étudiants ont été trouvés
            
                    try (Connection connection = DriverManager.getConnection(url, user, password);
                        Statement statement = connection.createStatement()) {
                        
                        // Requête SQL pour récupérer tous les étudiants
                        String sql = "SELECT numEl, nom, moyenne FROM etudiants";
            
                        try (ResultSet resultSet = statement.executeQuery(sql)) {
                            while (resultSet.next()) {
                                String numEl = resultSet.getString("numEl");
                                String nom = resultSet.getString("nom");
                                double moyenne = resultSet.getDouble("moyenne");
                                String obs;
                                if (moyenne >= 10) {
                                    obs = "admis";
                                } else if (moyenne >= 5) {
                                    obs = "redoublant";
                                } else {
                                    obs = "exclus";
                                }
            
                                totalMoyenne += moyenne;
                                if (moyenne < minMoyenne) minMoyenne = moyenne;
                                if (moyenne > maxMoyenne) maxMoyenne = moyenne;
                                count++;
                                etudiantTrouve = true; // Des étudiants ont été trouvés
            
                                %>
                                <tr>
                                    <td><%= nom %></td>
                                    <td><%= moyenne %></td>
                                    <td><%= obs %></td>
                                    <td>
                                        <a href="editStudent.jsp?numEl=<%= numEl %>" class="btn btn-warning btn-sm">Modifier</a>
                                        <button class="btn btn-danger btn-sm" onclick="confirmDelete('<%= numEl %>')">Supprimer</button>
                                    </td>
                                </tr>
                                <%
                            }
            
                            // Si aucun étudiant n'a été trouvé, afficher un message
                            if (!etudiantTrouve) {
                                out.println("<tr><td colspan='4' class='text-center alert alert-warning'>Aucun étudiant trouvé.</td></tr>");
                            }
                        }
                    } catch (SQLException e) {
                        out.println("<div class='alert alert-danger'>Erreur lors de la récupération des étudiants: " + e.getMessage() + "</div>");
                    }
            
                    double moyenneClasse = count > 0 ? totalMoyenne / count : 0;
                %>
            </tbody>
            
        </table>

        <div class="stats">
            <div class="stat-box">
                <h5>Moyenne de la classe</h5>
                <p><strong><%= String.format("%.2f", moyenneClasse) %></strong></p>
            </div>
            <div class="stat-box">
                <h5>Moyenne minimale</h5>
                <p><strong><%= String.format("%.2f", minMoyenne) %></strong></p>
            </div>
            <div class="stat-box">
                <h5>Moyenne maximale</h5>
                <p><strong><%= String.format("%.2f", maxMoyenne) %></strong></p>
            </div>
        </div>

        <div class="text-center mt-3">
            <a href="addStudent.jsp" class="btn btn-primary shadow-sm my-2">
                <i class="fas fa-user-plus"></i> Ajouter un nouvel étudiant
            </a>
            <br>
            <a href="chartView.jsp" class="btn btn-outline-primary shadow-sm my-2">
                <i class="fas fa-chart-bar"></i> Voir le graphique
            </a>
        </div>
    </div>

    <!-- Modal de confirmation -->
    <div class="modal fade" id="confirmDeleteModal" tabindex="-1" aria-labelledby="confirmDeleteModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="confirmDeleteModalLabel">Confirmer la suppression</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    Êtes-vous sûr de vouloir supprimer cet étudiant ?
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Annuler</button>
                    <a id="confirmDeleteButton" href="#" class="btn btn-danger">Supprimer</a>
                </div>
            </div>
        </div>
    </div>

    <!-- JavaScript pour la confirmation de suppression -->
    <script>
        function confirmDelete(numEl) {
            var deleteUrl = "deleteStudent.jsp?numEl=" + numEl;
            document.getElementById('confirmDeleteButton').href = deleteUrl;
            $('#confirmDeleteModal').modal('show');
        }
    </script>

    <!-- Inclure les scripts Bootstrap -->
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.3/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
