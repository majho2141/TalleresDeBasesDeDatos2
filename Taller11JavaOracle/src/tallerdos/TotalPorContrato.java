/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package tallerdos;
import java.sql.*;
public class TotalPorContrato {
    public static void ejecutar(){
        try {
            Class.forName("org.postgresql.Driver");

            // Establecer la conexión
            Connection conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/postgres", "postgres", "12345678");

            // Crear un CallableStatement
            CallableStatement stmt = conn.prepareCall("{ call taller9.total_por_contrato(?)}");
            
            stmt.setString(1, "3");
            
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                System.out.println("Nombre: "+ rs.getString("v_nombre"));
                System.out.println("Fecha pago: "+ rs.getString("v_fecha_pago"));
                System.out.println("El año es: "+ rs.getString("v_año"));
                System.out.println("El mes es: "+ rs.getString("v_mes"));
                System.out.println("El total devengado es: "+ rs.getString("v_total_devengado"));
                System.out.println("El total deducciones es: "+ rs.getString("v_total_deducciones"));
                System.out.println("El total  es: "+ rs.getString("v_total"));                               
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
