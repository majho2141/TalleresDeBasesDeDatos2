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
public class SimularVentasMes {
    public static  void ejecutar (){
        try {
            // Cargar el driver de JDBC
            Class.forName("org.postgresql.Driver");

            // Establecer la conexión
            Connection conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/postgres", "postgres", "12345678");

            // Crear un CallableStatement
            CallableStatement stmt = conn.prepareCall("call taller5.simular_ventas_mes()");
                      
            
            // Ejecutar el procedimiento almacenado
            stmt.execute();
            //Cerrar recursos
            stmt.close();
            conn.close();

        } catch (ClassNotFoundException | SQLException e) {
                System.out.println(e.getMessage());
        }
    }
}
