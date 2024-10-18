/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Main.java to edit this template
 */
package tallerxml;

import java.util.Scanner;

/**
 *
 * @author juane
 */
public class TallerXML {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        int option;

        do {
            System.out.println("\nSeleccione el procedimiento a ejecutar:");
            System.out.println("1.Guardar Libro");
            System.out.println("2. Editar Libro");
            System.out.println("3. Obtener Autor por ISBN");
            System.out.println("4. Obtner Autor por titulo");
            System.out.println("5. Obtener Autor por anios");
            System.out.println("0. Salir");
            System.out.println("");

            System.out.print("Opción: ");
            System.out.println("");
            option = scanner.nextInt();

            // Ejecutar la opción seleccionada
            switch (option) {
                case 1:
                    GuardarLibro.ejecutar();
                    System.out.println("Creado  con exito");

                    break;
                case 2:
                    actualizar_libro.ejecutar();
                    break;
                case 3:
                    ObtenerAutorLibroIsbn.ejecutar();
                    break;
                case 4:
                    ObtenerAutorLibroTitulo.ejecutar();
                    break;
                case 5:
                    ObtenerLibrosAnios.ejecutar();
                    break;
                case 0:
                    System.out.println("Saliendo...");
                    break;
                default:
                    System.out.println("Opción no válida. Intente nuevamente.");
            }
        } while (option != 0);
    }

}
