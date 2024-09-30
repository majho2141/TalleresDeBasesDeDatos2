package tallerprocedimiento;

import java.sql.*;
import java.util.Scanner;

public class Procedimientos {

    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        int option;

        do {
            // Mostrar menú de opciones
            System.out.println("\nSeleccione el procedimiento a ejecutar:");
            System.out.println("1. Ejecutar Ejemplo");
            System.out.println("2. Generar Auditoría");
            System.out.println("3. Simular Ventas Mes");
            System.out.println("4. Transacciones Total Mes");
            System.out.println("5. Servicios No Pagados");
            System.out.println("0. Salir");

            // Capturar la opción
            System.out.print("Opción: ");
            option = scanner.nextInt();

            // Ejecutar la opción seleccionada
            switch (option) {
                case 1:
                    Ejemplo.ejecutar();
                    break;
                case 2:
                    GenerarAuditoria.ejecutar();
                    System.out.println("Crada con exito");
                    break;
                case 3:
                    SimularVentasMes.ejecutar();
                    break;
                case 4:
                    TransaccionesTotalMes.ejecutar();
                    break;
                case 5:
                    ServiciosNoPagados.ejecutar();
                    break;
                case 0:
                    System.out.println("Saliendo...");
                    break;
                default:
                    System.out.println("Opción no válida. Intente nuevamente.");
            }
        } while (option != 0); // El bucle se repite hasta que el usuario seleccione "0" para salir.

        scanner.close();
    }

}
