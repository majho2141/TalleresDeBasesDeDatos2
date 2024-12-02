package parcial;

import java.util.Date;
import com.mongodb.client.MongoCollection;
import java.util.Scanner;

import org.bson.Document;

public class PedidosMongo {
    public static void insertarPedidos(MongoCollection<Document> collection, String id, String cliente,
            Date fechaPedido, String estado, Double total) {
        Document document = new Document("id", id)
                .append("cliente", cliente)
                .append("fechaPedido", fechaPedido)
                .append("estado", estado)
                .append("total", total);
        collection.insertOne(document);
    };

    public static void editarPedidos(MongoCollection<Document> collection, String id, String cliente,
            Date fechaPedido, String estado, Double total) {
        Document query = new Document("id", id);
        Document newData = new Document("cliente", cliente)
                .append("fechaPedido", fechaPedido)
                .append("estado", estado)
                .append("total", total);
        Document updateObject = new Document("$set", newData);
        collection.updateOne(query, updateObject);
    }

    public static void eliminarPedidos(MongoCollection<Document> collection, String id) {
        Document query = new Document("id", id);
        collection.deleteOne(query);
    }

    public static void obtenerPedidosMayorA100(MongoCollection<Document> collection) {
        Document query = new Document("total", new Document("$gt", 100));
        for (Document doc : collection.find(query)) {
            System.out.println(doc.toJson());
        }
    }

    public static void menuPedidos(Scanner scanner, MongoCollection<Document> collection) {
        int option;
        do {
            System.out.println("--- Menú Pedidos ---");
            System.out.println("1. Insertar Pedido");
            System.out.println("2. Editar Pedido");
            System.out.println("3. Eliminar Pedido");
            System.out.println("4. Obtener Pedidos con total mayor a 100");
            System.out.println("0. Salir");

            System.out.print("Seleccione una opción: ");
            option = scanner.nextInt();

            switch (option) {
                case 1:
                    System.out.print("Ingrese el id del pedido: ");
                    String id = scanner.nextLine();
                    System.out.print("Ingrese el cliente del pedido: ");
                    String cliente = scanner.nextLine();
                    System.out.print("Ingrese la fecha del pedido: ");
                    Date fechaPedido = new Date();
                    System.out.print("Ingrese el estado del pedido: ");
                    String estado = scanner.nextLine();
                    System.out.print("Ingrese el total del pedido: ");
                    Double total = scanner.nextDouble();
                    insertarPedidos(collection, id, cliente, fechaPedido, estado, total);
                    break;
                case 2:
                    System.out.print("Ingrese el id del pedido a editar: ");
                    String idEditar = scanner.nextLine();
                    System.out.print("Ingrese el cliente del pedido: ");
                    String clienteEditar = scanner.nextLine();
                    System.out.print("Ingrese la fecha del pedido: ");
                    Date fechaPedidoEditar = new Date();
                    System.out.print("Ingrese el estado del pedido: ");
                    String estadoEditar = scanner.nextLine();
                    System.out.print("Ingrese el total del pedido: ");
                    Double totalEditar = scanner.nextDouble();
                    editarPedidos(collection, idEditar, clienteEditar, fechaPedidoEditar, estadoEditar, totalEditar);
                    break;
                case 3:
                    System.out.print("Ingrese el id del pedido a eliminar: ");
                    String idEliminar = scanner.nextLine();
                    eliminarPedidos(collection, idEliminar);
                    break;
                case 4:
                    obtenerPedidosMayorA100(collection);
                    break;
                case 0:
                    System.out.println("vOLVER");
                    break;
            }
        } while (option != 0);
    }
}
