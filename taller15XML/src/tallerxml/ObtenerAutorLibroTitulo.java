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
public class ObtenerAutorLibroTitulo {
    public static void ejecutar() {
        try {
            Class.forName("org.postgresql.Driver");
            Connection conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/postgres", "postgres", "12345678");
            CallableStatement stmt = conn.prepareCall("{ call tallerxml.obtener_autor_libro_por_titulo(?) }");
            stmt.setString(1, "1000 Anios de soledad");

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                String autor = rs.getString(1);
                System.out.println("Autor ISBN: " + autor);
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
