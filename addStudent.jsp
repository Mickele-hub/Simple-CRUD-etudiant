<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.ResultSet, java.sql.SQLException, java.text.DecimalFormat" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ajouter un Étudiant</title>
    <!-- Inclure Bootstrap -->
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <!-- Inclure Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap" rel="stylesheet">
    <!-- Inclure Font Awesome pour les icônes -->
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
        .form-group {
            position: relative;
            margin-bottom: 25px;
        }
        .form-control {
            padding-left: 40px;
            transition: border-color 0.3s;
        }
        .form-control:focus {
            border-color: #007bff;
            box-shadow: none;
        }
        .form-group i {
            position: absolute;
            left: 10px;
            top: 10px;
            color: #aaa;
            transition: color 0.3s;
        }
        .form-control:focus + i {
            color: #007bff;
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
        <h1>Ajouter un Étudiant</h1>
        <form method="post">
            <div class="form-group">
                <input type="text" class="form-control" id="numEl" name="numEl" placeholder="Numéro d'Élève" required>
                <i class="fas fa-id-card"></i>
            </div>
            <div class="form-group">
                <input type="text" class="form-control" id="nom" name="nom" placeholder="Nom" required>
                <i class="fas fa-user"></i>
            </div>
            <div class="form-group">
                <input type="number" step="0.01" class="form-control" id="moyenne" name="moyenne" placeholder="Moyenne" required>
                <i class="fas fa-percentage"></i>
            </div>
            <button type="submit" class="btn btn-primary btn-block">Ajouter</button>
        </form>

        <%
            if (request.getMethod().equalsIgnoreCase("POST")) {
                String numEl = request.getParameter("numEl");
                String nom = request.getParameter("nom");
                double moyenne = Double.parseDouble(request.getParameter("moyenne"));

                // Formatage de la moyenne à 2 chiffres après la virgule
                DecimalFormat df = new DecimalFormat("#.00");
                String moyenneFormat = df.format(moyenne);
                
                // Vérification de la validité de la moyenne
                double moyenneFinale = Double.parseDouble(moyenneFormat.replace(",", ".")); // Conversion du formaté en double
                if (moyenneFinale < 0 || moyenneFinale > 20) {
                    out.println("<div class='alert alert-danger'>Erreur : La note doit être entre 0 et 20.</div>");
                } else {
                    String url = "jdbc:mysql://localhost:3306/gestion_etudiants";
                    String user = "root";
                    String password = "Madarauchiwa1560";

                    try (Connection connection = DriverManager.getConnection(url, user, password)) {
                        // Vérification si le numéro d'élève existe déjà
                        String checkSql = "SELECT COUNT(*) FROM etudiants WHERE numEl = ?";
                        try (PreparedStatement checkStmt = connection.prepareStatement(checkSql)) {
                            checkStmt.setString(1, numEl);
                            ResultSet rs = checkStmt.executeQuery();
                            rs.next();
                            if (rs.getInt(1) > 0) {
                                out.println("<div class='alert alert-danger'>Erreur : Le numéro d'élève existe déjà.</div>");
                            } else {
                                // Si le numéro d'élève n'existe pas, on l'ajoute
                                String insertSql = "INSERT INTO etudiants (numEl, nom, moyenne) VALUES (?, ?, ?)";
                                try (PreparedStatement insertStmt = connection.prepareStatement(insertSql)) {
                                    insertStmt.setString(1, numEl);
                                    insertStmt.setString(2, nom);
                                    insertStmt.setDouble(3, moyenneFinale);  // Utilisation de la moyenne formatée
                                    insertStmt.executeUpdate();
                                    out.println("<div class='alert alert-success'>Étudiant ajouté avec succès!</div>");
                                }
                            }
                        }
                    } catch (SQLException e) {
                        out.println("<div class='alert alert-danger'>Erreur lors de l'ajout de l'étudiant: " + e.getMessage() + "</div>");
                    }
                }
            }
        %>
        <div class="text-center mt-2">
            <a href="listStudents.jsp" class="btn btn-primary shadow-sm my-2">
                <i class="fas fa-list"></i> Retourner voir la liste des étudiants
            </a>
        </div>
    </div>
</body>
</html>
