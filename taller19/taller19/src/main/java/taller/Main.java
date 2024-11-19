package taller;
import org.bson.Document;

import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoCursor;
import com.mongodb.client.MongoDatabase;
import static com.mongodb.client.model.Filters.eq;
import static com.mongodb.client.model.Filters.gt;
import static com.mongodb.client.model.Filters.and;
import static com.mongodb.client.model.Updates.set;

import java.util.Arrays;

import static com.mongodb.client.model.Sorts.ascending;
import com.mongodb.client.MongoClients;

public class Main {
    public static void main(String[] args) {
        String uri = "mongodb://localhost:27017";

        MongoClient mongoClient = MongoClients.create(uri);

        MongoDatabase database = mongoClient.getDatabase("taller19");

        MongoCollection<Document> collection = null;

        
        Document categoria1 = new Document("categoria_id", 1).append("nombre_categoria", "Libros");
        Document categoria2 = new Document("categoria_id", 2).append("nombre_categoria", "Juguetes");
        Document categoria3 = new Document("categoria_id", 3).append("nombre_categoria", "Muebles");

        collection = database.getCollection("categorias");
        collection.insertMany(Arrays.asList(categoria1, categoria2, categoria3));

        Document comentario1 = new Document("comentario_id", 1).append("texto", "Muy interesante").append("cliente", "Carlos");
        Document comentario2 = new Document("comentario_id", 2).append("texto", "Divertido").append("cliente", "Maria");
        Document comentario3 = new Document("comentario_id", 3).append("texto", "Muy cómodo").append("cliente", "Pedro");

        collection = database.getCollection("comentarios");
        collection.insertMany(Arrays.asList(comentario1, comentario2, comentario3));

        Document producto1 = new Document("producto_id", 1)
            .append("nombre", "novela")
            .append("descripcion", "Novela de misterio")
            .append("precio", 15)
            .append("categoria", categoria1)
            .append("comentarios", Arrays.asList(comentario1, comentario2));

        Document producto2 = new Document("producto_id", 2)
            .append("nombre", "puzzle")
            .append("descripcion", "Puzzle de 1000 piezas")
            .append("precio", 25)
            .append("categoria", categoria2)
            .append("comentarios", Arrays.asList(comentario3));

        Document producto3 = new Document("producto_id", 3)
            .append("nombre", "sofa")
            .append("descripcion", "Sofá de cuero")
            .append("precio", 500)
            .append("categoria", categoria3)
            .append("comentarios", Arrays.asList(comentario1, comentario3));

        Document producto4 = new Document("producto_id", 4)
            .append("nombre", "mesa de centro")
            .append("descripcion", "Mesa de centro de vidrio")
            .append("precio", 150)
            .append("categoria", categoria3)
            .append("comentarios", Arrays.asList(comentario2));

        Document producto5 = new Document("producto_id", 5)
            .append("nombre", "juego de mesa")
            .append("descripcion", "Juego de mesa estratégico")
            .append("precio", 40)
            .append("categoria", categoria2)
            .append("comentarios", Arrays.asList(comentario3));

        collection = database.getCollection("productos");
        collection.insertMany(Arrays.asList(producto1, producto2, producto3, producto4, producto5));

        collection.updateOne(eq("producto_id", 1), set("descripcion", "Novela de misterio con giros inesperados"));
        collection.updateOne(eq("producto_id", 2), set("descripcion", "Puzzle de 1000 piezas con imagen de paisaje"));
        collection.deleteOne(eq("producto_id", 3));
        collection.updateOne(eq("comentarios.comentario_id", 1), set("comentarios.$.texto", "Muy interesante y atrapante"));
        collection.updateOne(eq("comentarios.comentario_id", 2), set("comentarios", Arrays.asList()));
        collection.updateOne(eq("categoria.categoria_id", 1), set("categoria.nombre_categoria", "Libros de ficción"));
        collection.updateOne(eq("categoria.categoria_id", 2), set("categoria.nombre_categoria", "Juguetes educativos"));
        collection.updateOne(eq("categoria.categoria_id", 3), set("categoria", new Document()));
        collection.deleteOne(eq("categoria.categoria_id", 3));

        MongoCursor<Document> cursor1 = collection.find(gt("precio", 10)).iterator();
        while(cursor1.hasNext()) {
            System.out.println(cursor1.next().toJson());
        }

        MongoCursor<Document> cursor2 = collection.find(and(eq("categoria.nombre_categoria", "Libros"), gt("precio", 50))).iterator();
        while(cursor2.hasNext()) {
            System.out.println(cursor2.next().toJson());
        }
    }
}