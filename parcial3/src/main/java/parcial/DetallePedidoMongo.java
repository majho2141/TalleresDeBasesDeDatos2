package parcial;

import com.mongodb.client.MongoCollection;


import java.util.Scanner;

import org.bson.Document;

public class DetallePedidoMongo {
    public static void insertarDetallePedido(MongoCollection<Document> collection, String id, String pedido_id,
            String producto_id, Integer cantidad, Double precio) {
        Document document = new Document("id", id)
                .append("idPedido", pedido_id)
                .append("idProducto", producto_id)
                .append("cantidad", cantidad)
                .append("precio", precio);
        collection.insertOne(document);
    };

    public static void EditarDetallePedido(MongoCollection<Document> collection, String id, String pedido_id,
            String producto_id, Integer cantidad, Double precio) {
        Document query = new Document("id", id);
        Document newData = new Document("idPedido", pedido_id)
                .append("idProducto", producto_id)
                .append("cantidad", cantidad)
                .append("precio", precio);
        Document updateObject = new Document("$set", newData);
        collection.updateOne(query, updateObject);
    }

    public static void eliminarDetallePedido(MongoCollection<Document> collection, String id) {
        Document query = new Document("id", id);
        collection.deleteOne(query);
    }

    public static void obtenerPedidosConProducto(MongoCollection<Document> collection, String producto_id) {
        Document query = new Document("idProducto", producto_id);
        for (Document doc : collection.find(query)) {
            System.out.println(doc.toJson());
        }
    }

    public static void menuDetallePedido(Scanner scanner, MongoCollection<Document> collection) {
        int option;
        do {
            System.out.println("--- Menú Detalle Pedido ---");
            System.out.println("1. Insertar Detalle Pedido");
            System.out.println("2. Editar Detalle Pedido");
            System.out.println("3. Eliminar Detalle Pedido");
            System.out.println("4. Obtener Detalles de Pedido con producto");
            System.out.println("0. Salir");

            System.out.print("Seleccione una opción: ");
            option = scanner.nextInt();

            switch (option) {
                case 1:
                    System.out.print("Ingrese el id del detalle pedido: ");
                    String id = scanner.nextLine();
                    System.out.print("Ingrese el id del pedido: ");
                    String pedido_id = scanner.nextLine();
                    System.out.print("Ingrese el id del producto: ");
                    String producto_id = scanner.nextLine();
                    System.out.print("Ingrese la cantidad del producto: ");
                    Integer cantidad = scanner.nextInt();
                    System.out.print("Ingrese el precio del producto: ");
                    Double precio = scanner.nextDouble();
                    insertarDetallePedido(collection, id, pedido_id, producto_id, cantidad, precio);
                    break;
                case 2:
                    System.out.print("Ingrese el id del detalle pedido a editar: ");
                    String idEditar = scanner.nextLine();
                    System.out.print("Ingrese el id del pedido: ");
                    String pedido_idEditar = scanner.nextLine();
                    System.out.print("Ingrese el id del producto: ");
                    String producto_idEditar = scanner.nextLine();
                    System.out.print("Ingrese la cantidad del producto: ");
                    Integer cantidadEditar = scanner.nextInt();
                    System.out.print("Ingrese el precio del producto: ");
                    Double precioEditar = scanner.nextDouble();
                    EditarDetallePedido(collection, idEditar, pedido_idEditar, producto_idEditar, cantidadEditar,
                            precioEditar);
                    break;
                case 3:
                    System.out.print("Ingrese el id del detalle pedido a eliminar: ");
                    String idEliminar = scanner.nextLine();
                    eliminarDetallePedido(collection, idEliminar);
                    break;
                case 4:
                    System.out.print("Ingrese el id del producto: ");
                    String producto_idC = scanner.nextLine();
                    obtenerPedidosConProducto(collection, producto_idC);
                    break;
                case 0:
                    System.out.println("vOLVER");
                    break;
            }
        } while (option != 0);
    }
}
