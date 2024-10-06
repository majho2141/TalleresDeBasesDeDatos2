/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package tallerdos;

import java.sql.*;

/**
 *
 * @author Martin
 */
public class SimularVentasMesOracle {

    public static void ejecutar() {
        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            Connection conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:XE", "system", "12345678");
            CallableStatement stmt = conn.prepareCall("{ CALL PROCEDIMIENTOS.SIMULAR_VENTAS_MES(); }");

            stmt.execute();
            stmt.close();
            conn.close();

        } catch (ClassNotFoundException | SQLException e) {
            System.out.println(e.getMessage());
        }

    }
}
