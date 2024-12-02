package parcial;

import org.neo4j.driver.Driver;
import org.neo4j.driver.Session;
import org.neo4j.driver.SessionConfig;
import static org.neo4j.driver.Values.parameters;

public class PersonaService {
    private static final Driver driver = Neo4jConnection.getDriver();
    private Session session;

    public PersonaService() {
        this.session = driver.session(SessionConfig.forDatabase("neo4j"));
    }

    public void createPersona(Persona persona) {
        String cypherQuery = "CREATE (p:Persona {id: $id, nombre: $nombre, edad: $edad})";
        session.run(cypherQuery, parameters("id", persona.getId(), "nombre", persona.getNombre(), "edad", persona.getEdad()));
        System.out.println("Persona creada correctamente" + persona.getNombre());
    }

    public Persona obtenerPersona(String id) {
        String cypherQuery = "MATCH (p:Persona) WHERE p.id = $id RETURN p";
        org.neo4j.driver.Result result = session.run(cypherQuery, parameters("id", id));
        var persona = result.single().get("p").asNode();
        return new Persona(persona.get("id").asString(), persona.get("nombre").asString(), persona.get("edad").asInt());
    }
}
