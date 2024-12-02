package parcial;

import java.sql.Connection;

import org.bson.Document;

import com.mongodb.client.MongoCollection;

import connection.ConexionMongo;
import connection.ConexionPostgres;

public class Main {
    public static void main(String[] args) {
        MongoCollection<Document> collection = ConexionMongo.getCollection();
        Connection connection = ConexionPostgres.getConnection();
        Neo4jConnection.connect();
        Neo4jConnection.disconnect();
        
        ConexionPostgres.closeConnection();
    }
}