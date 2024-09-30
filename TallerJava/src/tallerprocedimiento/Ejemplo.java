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
public  class Ejemplo {
    public static  void ejecutar (){
        try {
            // Cargar el driver de JDBC
            Class.forName("org.postgresql.Driver");

            // Establecer la conexión
            Connection conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/postgres", "postgres", "12345678");

            // Crear un CallableStatement
            CallableStatement stmt = conn.prepareCall("call taller9.poblar()");
            CallableStatement stmt1 = conn.prepareCall("{ call taller9.obtener_nomina_empleado(?,?,?)}");
            stmt1.setString(1, "1");
            stmt1.setInt(2, 10);
            stmt1.setInt(3, 0);
            
            ResultSet resultado = stmt1.executeQuery();
            while (resultado.next()){
                
            }
            
            // Ejecutar el procedimiento almacenado
            stmt.execute();
                       // Cerrar recursos
            stmt.close();
            conn.close();

        } catch (ClassNotFoundException | SQLException e) {
                System.out.println(e.getMessage());
        }
    }
}
