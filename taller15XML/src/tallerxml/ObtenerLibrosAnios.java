/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package tallerxml;

import java.sql.*;

/**
 *
 * @author juane
 */
public class ObtenerLibrosAnios {

    public static void ejecutar() {
        try {
            Class.forName("org.postgresql.Driver");
            Connection conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/postgres", "postgres", "12345678");
            CallableStatement stmt = conn.prepareCall("{ call tallerxml.obtener_libros_por_anio(?) }");
            stmt.setString(1, "1500");

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                System.out.println("Isbn: " + rs.getString("isbn"));
                System.out.println("Titulo: " + rs.getString("titulo"));
                System.out.println("Autor: " + rs.getString("autor"));
                System.out.println("Anio: " + rs.getString("anio"));
            }

            rs.close();
            //Cerrar recursos
            stmt.close();
            conn.close();

        } catch (ClassNotFoundException | SQLException e) {
            System.out.println(e.getMessage());
        }

    }
}
