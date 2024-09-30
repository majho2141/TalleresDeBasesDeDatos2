/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package tallerprocedimiento;
import java.sql.*;import java.time.LocalDate;
/**
 *
 * @author juane
 */
public class GenerarAuditoria {
    public static  void ejecutar (){
        try {
            // Cargar el driver de JDBC
            Class.forName("org.postgresql.Driver");

            // Establecer la conexión
            Connection conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/postgres", "postgres", "12345678");

            // Crear un CallableStatement
            CallableStatement stmt = conn.prepareCall("call taller5.generar_auditoria(?,?)");
            // CallableStatement stmt1 = conn.prepareCall("{ call taller9.obtener_nomina_empleado(?,?,?)}");
            String dateString = "2024-06-01";
            Date sqlDate = Date.valueOf(dateString);
            stmt.setDate(1, sqlDate); 
            String dateString2 = "2024-06-31";
            Date sqlDate2 = Date.valueOf(dateString2);
            stmt.setDate(2, sqlDate2); 
            
            
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
