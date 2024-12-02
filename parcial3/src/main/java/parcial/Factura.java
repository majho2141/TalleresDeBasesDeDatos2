package parcial;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.Date;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Scanner;

public class Factura {

    public static boolean agregarFactura(Connection connection, String codigo, Date fecha, double subtotal,
            double totalImpuestos, double total, String estadoF, int idCliente, int idMetodoPago) {
        String sql = "CALL proyecto.agregar_factura(?, ?, ?, ?, ?, ?, ?, ?)";
        try {
            CallableStatement stmt = connection.prepareCall(sql);
            stmt.setString(1, codigo);
            stmt.setDate(2, fecha);
            stmt.setDouble(3, subtotal);
            stmt.setDouble(4, totalImpuestos);
            stmt.setDouble(5, total);
            stmt.setString(6, estadoF);
            stmt.setInt(7, idCliente);
            stmt.setInt(8, idMetodoPago);
            stmt.execute();
            stmt.close();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public static boolean modificarFactura(Connection connection, int id, String codigo, Date fecha,
            double subtotal, double totalImpuestos, double total, String estadoF, int idCliente, int idMetodoPago) {
        String sql = "CALL proyecto.modificar_factura(?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try {
            CallableStatement stmt = connection.prepareCall(sql);
            stmt.setInt(1, id);
            stmt.setString(2, codigo);
            stmt.setDate(3, fecha);
            stmt.setDouble(4, subtotal);
            stmt.setDouble(5, totalImpuestos);
            stmt.setDouble(6, total);
            stmt.setString(7, estadoF);
            stmt.setInt(8, idCliente);
            stmt.setInt(9, idMetodoPago);
            stmt.execute();
            stmt.close();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public static boolean eliminarFactura(Connection connection, int id) {
        String sql = "CALL proyecto.eliminar_factura(?)";
        try {
            CallableStatement stmt = connection.prepareCall(sql);
            stmt.setInt(1, id);
            stmt.execute();
            stmt.close();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public static boolean agregarClienteAFactura(Connection connection, int facturaId, int clienteId) {
        String sql = "SELECT proyecto.agregar_cliente_a_factura(?, ?)";
        try {
            CallableStatement stmt = connection.prepareCall(sql);
            stmt.setInt(1, facturaId);
            stmt.setInt(2, clienteId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                String resultado = rs.getString(1);
                System.out.println(resultado);
            }
            rs.close();
            stmt.close();
            return true;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            return false;
        }
    }

    public static boolean agregarProductoADetalleFactura(Connection connection, int facturaId, int productoId,
            int cantidad) {
        String sql = "SELECT proyecto.agregar_producto_a_detalle_factura(?, ?, ?)";
        try {
            CallableStatement stmt = connection.prepareCall(sql);
            stmt.setInt(1, facturaId);
            stmt.setInt(2, productoId);
            stmt.setInt(3, cantidad);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                String resultado = rs.getString(1);
                System.out.println(resultado);
            }
            rs.close();
            stmt.close();
            return true;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            return false;
        }
    }

    public static boolean calcularImpuestosFactura(Connection connection, int facturaId) {
        String sql = "SELECT proyecto.calcular_impuestos_factura(?)";
        try {
            CallableStatement stmt = connection.prepareCall(sql);
            stmt.setInt(1, facturaId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                String resultado = rs.getString(1);
                System.out.println(resultado);
            }
            rs.close();
            stmt.close();
            return true;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            return false;
        }
    }

    public static boolean aplicarDescuentoFactura(Connection connection, int facturaId, String tipoDescuento,
            double valorDescuento) {
        String sql = "SELECT proyecto.aplicar_descuento_factura(?, ?, ?)";
        try {
            CallableStatement stmt = connection.prepareCall(sql);
            stmt.setInt(1, facturaId);
            stmt.setString(2, tipoDescuento);
            stmt.setDouble(3, valorDescuento);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                String resultado = rs.getString(1);
                System.out.println(resultado);
            }
            rs.close();
            stmt.close();
            return true;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            return false;
        }
    }

    public static boolean agregarMetodoPagoAFactura(Connection connection, int facturaId, int metodoPagoId) {
        String sql = "SELECT proyecto.agregar_metodo_pago_a_factura(?, ?)";
        try {
            CallableStatement stmt = connection.prepareCall(sql);
            stmt.setInt(1, facturaId);
            stmt.setInt(2, metodoPagoId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                String resultado = rs.getString(1);
                System.out.println(resultado);
            }
            rs.close();
            stmt.close();
            return true;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            return false;
        }
    }

    public static int obtenerUltimaFacturaId(Connection connection) {
        String sql = "SELECT MAX(id) FROM proyecto.facturas";
        try {
            CallableStatement stmt = connection.prepareCall(sql);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Menú de Facturas
    public static void menuFacturas(Scanner scanner, Connection connection) {
        int option;
        do {
            System.out.println("\n--- Facturas ---");
            System.out.println("1. Crear Factura");
            System.out.println("2. Modificar Factura");
            System.out.println("3. Eliminar Factura");
            System.out.println("4. Agregar Cliente a Factura");
            System.out.println("5. Agregar Producto a Detalle de Factura");
            System.out.println("6. Calcular Impuestos de Factura");
            System.out.println("7. Aplicar Descuento a Factura");
            System.out.println("8. Agregar Método de Pago a Factura");
            System.out.println("0. Regresar");

            System.out.print("Seleccione una opción: ");
            option = scanner.nextInt();
            scanner.nextLine();

            switch (option) {
                case 1:
                    System.out.print("Ingrese el código de la factura: ");
                    String codigoFactura = scanner.nextLine();
                    System.out.print("Ingrese la fecha de la factura (YYYY-MM-DD): ");
                    String fechaStr = scanner.nextLine();
                    Date fecha = Date.valueOf(fechaStr);
                    System.out.print("Ingrese el subtotal: ");
                    double subtotal = scanner.nextDouble();
                    System.out.print("Ingrese el total de impuestos: ");
                    double totalImpuestos = scanner.nextDouble();
                    System.out.print("Ingrese el total: ");
                    double total = scanner.nextDouble();
                    scanner.nextLine();
                    System.out.print("Ingrese el estado de la factura (PAGADA, PENDIENTE, EN PROCESO): ");
                    String estadoF = scanner.nextLine();
                    System.out.print("Ingrese el ID del cliente: ");
                    int idCliente = scanner.nextInt();
                    System.out.print("Ingrese el ID del método de pago: ");
                    int idMetodoPago = scanner.nextInt();
                    agregarFactura(connection, codigoFactura, fecha, subtotal, totalImpuestos, total, estadoF,
                            idCliente, idMetodoPago);
                    break;
                case 2:
                    System.out.print("Ingrese el ID de la factura a modificar: ");
                    int idFacturaModificar = scanner.nextInt();
                    scanner.nextLine();
                    System.out.print("Ingrese el nuevo código de la factura: ");
                    String nuevoCodigoFactura = scanner.nextLine();
                    System.out.print("Ingrese la nueva fecha de la factura (YYYY-MM-DD): ");
                    String nuevaFechaStr = scanner.nextLine();
                    Date nuevaFecha = Date.valueOf(nuevaFechaStr);
                    System.out.print("Ingrese el nuevo subtotal: ");
                    double nuevoSubtotal = scanner.nextDouble();
                    System.out.print("Ingrese el nuevo total de impuestos: ");
                    double nuevoTotalImpuestos = scanner.nextDouble();
                    System.out.print("Ingrese el nuevo total: ");
                    double nuevoTotal = scanner.nextDouble();
                    scanner.nextLine();
                    System.out.print("Ingrese el nuevo estado de la factura (PAGADA, PENDIENTE, EN PROCESO): ");
                    String nuevoEstadoF = scanner.nextLine();
                    System.out.print("Ingrese el nuevo ID del cliente: ");
                    int nuevoIdCliente = scanner.nextInt();
                    System.out.print("Ingrese el nuevo ID del método de pago: ");
                    int nuevoIdMetodoPago = scanner.nextInt();
                    modificarFactura(connection, idFacturaModificar, nuevoCodigoFactura, nuevaFecha,
                            nuevoSubtotal, nuevoTotalImpuestos, nuevoTotal, nuevoEstadoF, nuevoIdCliente,
                            nuevoIdMetodoPago);
                    break;
                case 3:
                    System.out.print("Ingrese el ID de la factura a eliminar: ");
                    int idFacturaEliminar = scanner.nextInt();
                    eliminarFactura(connection, idFacturaEliminar);
                    break;
                case 4:
                    System.out.print("Ingrese el ID de la factura: ");
                    int idFactura = scanner.nextInt();
                    System.out.print("Ingrese el ID del cliente: ");
                    int idClienteF = scanner.nextInt();
                    agregarClienteAFactura(connection, idFactura, idClienteF);
                    break;
                case 5:
                    System.out.print("Ingrese el ID de la factura: ");
                    int idFacturaD = scanner.nextInt();
                    System.out.print("Ingrese el ID del producto: ");
                    int idProducto = scanner.nextInt();
                    System.out.print("Ingrese la cantidad: ");
                    int cantidad = scanner.nextInt();
                    agregarProductoADetalleFactura(connection, idFacturaD, idProducto, cantidad);
                    break;
                case 6:
                    System.out.print("Ingrese el ID de la factura: ");
                    int idFacturaImp = scanner.nextInt();
                    calcularImpuestosFactura(connection, idFacturaImp);
                    break;
                case 7:
                    System.out.print("Ingrese el ID de la factura: ");
                    int idFacturaDesc = scanner.nextInt();
                    scanner.nextLine();
                    System.out.print("Ingrese el tipo de descuento (POR PRODUCTO, TOTAL): ");
                    String tipoDescuento = scanner.nextLine();
                    System.out.print("Ingrese el valor del descuento: ");
                    double valorDescuento = scanner.nextDouble();
                    aplicarDescuentoFactura(connection, idFacturaDesc, tipoDescuento, valorDescuento);
                    break;
                case 8:
                    System.out.print("Ingrese el ID de la factura: ");
                    int idFacturaMP = scanner.nextInt();
                    System.out.print("Ingrese el ID del método de pago: ");
                    int idMetodoPagoF = scanner.nextInt();
                    agregarMetodoPagoAFactura(connection, idFacturaMP, idMetodoPagoF);
                    break;
                case 0:
                    System.out.println("Regresando al Menú Principal...");
                    break;
                default:
                    System.out.println("Opción no válida. Intente nuevamente.");
            }
        } while (option != 0);
    }

}
