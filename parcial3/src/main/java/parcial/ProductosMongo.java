package parcial;

import com.mongodb.client.MongoCollection;
import java.util.Scanner;

import org.bson.Document;

public class ProductosMongo {

    public static void insertarProducto(MongoCollection<Document> collection, String id, String name,
            String descripcion, Double precio, Integer cantidad) {
        Document document = new Document("id", id)
                .append("name", name)
                .append("descripcion", descripcion)
                .append("precio", precio)
                .append("cantidad", cantidad);
        collection.insertOne(document);
    };

    public static void editarProducto(MongoCollection<Document> collection, String id, String name,
            String descripcion, Double precio, Integer cantidad) {
        Document query = new Document("id", id);
        Document newData = new Document("name", name)
                .append("descripcion", descripcion)
                .append("precio", precio)
                .append("cantidad", cantidad);
        Document updateObject = new Document("$set", newData);
        collection.updateOne(query, updateObject);
    }

    public static void eliminarProducto(MongoCollection<Document> collection, String id) {
        Document query = new Document("id", id);
        collection.deleteOne(query);
    }

    public static void obtenerProductos(MongoCollection<Document> collection) {
        Document query = new Document("precio", new Document("$gt", 20));
        for (Document doc : collection.find(query)) {
            System.out.println(doc.toJson());
        }
    }

    
    public static void menuProducto(Scanner scanner, MongoCollection<Document> collection) {
        int option;
        do {
            System.out.println("--- Menú Producto ---");
            System.out.println("1. Insertar Producto");
            System.out.println("2. Editar Producto");
            System.out.println("3. Eliminar Producto");
            System.out.println("4. Obtener Productos con precio mayor a 20");
            System.out.println("0. Salir");

            System.out.print("Seleccione una opción: ");
            option = scanner.nextInt();

            switch (option) {
                case 1:
                    System.out.print("Ingrese el id del producto: ");
                    String id = scanner.nextLine();
                    System.out.print("Ingrese el nombre del producto: ");
                    String name = scanner.nextLine();
                    System.out.print("Ingrese la descripción del producto: ");
                    String descripcion = scanner.nextLine();
                    System.out.print("Ingrese el precio del producto: ");
                    Double precio = scanner.nextDouble();
                    System.out.print("Ingrese la cantidad del producto: ");
                    Integer cantidad = scanner.nextInt();
                    insertarProducto(collection, id, name, descripcion, precio, cantidad);
                    break;
                case 2:
                    System.out.print("Ingrese el id del producto a editar: ");
                    String idEditar = scanner.nextLine();
                    System.out.print("Ingrese el nombre del producto: ");
                    String nameEditar = scanner.nextLine();
                    System.out.print("Ingrese la descripción del producto: ");
                    String descripcionEditar = scanner.nextLine();
                    System.out.print("Ingrese el precio del producto: ");
                    Double precioEditar = scanner.nextDouble();
                    System.out.print("Ingrese la cantidad del producto: ");
                    Integer cantidadEditar = scanner.nextInt();
                    editarProducto(collection, idEditar, nameEditar, descripcionEditar, precioEditar, cantidadEditar);
                    break;
                case 3:
                    System.out.print("Ingrese el id del producto a eliminar: ");
                    String idEliminar = scanner.nextLine();
                    eliminarProducto(collection, idEliminar);
                    break;
                case 4:
                    obtenerProductos(collection);
                    break;
                case 0:
                    System.out.println("vOLVER");
                    break;
            }
        } while (option != 0);
    }
}
