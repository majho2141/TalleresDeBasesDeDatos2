/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package tallerprocedimiento;

import java.sql.*;

/**
 *
 * @author juane
 */
public class TransaccionesTotalMes {

    public static void ejecutar() {
        try {
            // Cargar el driver de JDBC
            Class.forName("org.postgresql.Driver");

            // Establecer la conexión
            Connection conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/postgres", "postgres", "12345678");

            // Crear un CallableStatement
            CallableStatement stmt = conn.prepareCall("{ call taller6.transacciones_total_mes(?,?)}");
            stmt.setInt(1, 8);
            stmt.setString(2, "1");

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                double total = rs.getDouble(1);
                System.out.println("Total de transacciones en el mes: " + total);
            }
            // Ejecutar el procedimiento almacenado
            rs.close();
            //Cerrar recursos
            stmt.close();
            conn.close();

        } catch (ClassNotFoundException | SQLException e) {
            System.out.println(e.getMessage());
        }
    }

}
