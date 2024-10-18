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
public class GuardarLibro {
    public static  void ejecutar (){
         try {
            Class.forName("org.postgresql.Driver");
            Connection conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/postgres", "postgres", "12345678");
            CallableStatement stmt = conn.prepareCall("call tallerxml.guardar_libro(?,?,?,?)");
            stmt.setString(1, "002");
            stmt.setString(2, "La Divina Comedia 2");
            stmt.setString(3, "Dante Ali");
            stmt.setString(4, "1500");

            stmt.execute();
            stmt.close();
            conn.close();

        } catch (ClassNotFoundException | SQLException e) {
            System.out.println(e.getMessage());
        }
    }
}
