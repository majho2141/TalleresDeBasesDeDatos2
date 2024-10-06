package tallerdos;

import java.sql.*;
import java.util.Scanner;

public class Procedimientos {

    public static void main(String[] args) {

        Scanner scanner = new Scanner(System.in);
        int option;

        do {
            System.out.println("\nSeleccione el procedimiento a ejecutar:");
            System.out.println("1. Obtener nómina empleado");
            System.out.println("2. Total por contrato");
            System.out.println("3.Generar auditoria Oracle");
            System.out.println("4. Simular entas mes Oracle");
            System.out.println("5. Obtener nómina empleado Oracle");
            System.out.println("6. Total por contrato Oracle");
            System.out.println("0. Salir");

            // Capturar la opción
            System.out.print("Opción: ");
            option = scanner.nextInt();

            // Ejecutar la opción seleccionada
            switch (option) {
                case 1:
                    ObtenerNominaEmpleado.ejecutar();
                    break;
                case 2:

                    TotalPorContrato.ejecutar();
                    break;
                case 3:

                    GenerarAuditoriaOracle.ejecutar();
                    break;
                case 4:

                    SimularVentasMesOracle.ejecutar();
                    break;
                case 5:

                    ObtenerNominaEmpleadoOracle.ejecutar();
                    break;
                case 6:

                    TotalPorContratoOracle.ejecutar();
                    break;
                case 0:

                    System.out.println("Saliendo...");
                    break;
                default:
                    System.out.println("Opción no válida. Intente nuevamente.");
            }
        } while (option != 0);

        scanner.close();
    }

}
