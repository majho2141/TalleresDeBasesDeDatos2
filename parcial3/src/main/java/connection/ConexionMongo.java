package connection;
import org.bson.Document;

import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoCollection;
//import com.mongodb.client.MongoCursor;
import com.mongodb.client.MongoDatabase;

//import static com.mongodb.client.model.Filters.eq;
//import static com.mongodb.client.model.Filters.gt;
//import static com.mongodb.client.model.Filters.and;
//import static com.mongodb.client.model.Updates.set;
//import static com.mongodb.client.model.Sorts.ascending;
import com.mongodb.client.MongoClients;

public class ConexionMongo {
    private static ConexionMongo instance;
    private String uri;
    private MongoClient mongoClient;
    private MongoDatabase database;
    private MongoCollection<Document> collection;

    private ConexionMongo() {
        this.uri = "mongodb://localhost:27017";
        this.mongoClient = MongoClients.create(uri);
        this.database = mongoClient.getDatabase("parcial");
        this.collection = database.getCollection("nombre_coleccion");
        System.out.println("Conexión MongoDB exitosa");
    }

    public static void setCollection(String nombreColeccion) {
        instance.collection = instance.database.getCollection(nombreColeccion);
    }

    public static ConexionMongo getInstance() {
        if (instance == null) {
            instance = new ConexionMongo();
        }
        return instance;
    }

    public static MongoCollection<Document> getCollection() {
        return getInstance().collection;
    }
}