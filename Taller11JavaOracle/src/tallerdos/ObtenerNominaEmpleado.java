/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package tallerdos;
 import java.sql.*;
/**
 *
 * @author maria
 */
public class ObtenerNominaEmpleado {
    public static void ejecutar() {
        try {
            Class.forName("org.postgresql.Driver");

            Connection conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/postgres", "postgres", "12345678");
 
            CallableStatement stmt = conn.prepareCall("{ call taller9.obtener_nomina_empleado(?,?,?)}");
            stmt.setString(1, "1");
            stmt.setInt(2, 10);
            stmt.setInt(3, 2024);            

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                System.out.println("Nombre: "+ rs.getString("v_nombre"));
                System.out.println("Total Devengado: "+ rs.getString("v_total_devengado"));
                System.out.println("Total deducciones: "+ rs.getString("v_total_deducciones"));
                System.out.println("Total: "+ rs.getString("v_total"));
            }
            rs.close();
            stmt.close();
            conn.close();

        } catch (ClassNotFoundException | SQLException e) {
            System.out.println(e.getMessage());
        }
    }
}
