package parcial;

public class Persona {
    private String identificacion;
    private String nombre;
    private int edad;


    public Persona(String identificacion, String nombre, int edad) {
        this.identificacion = identificacion;
        this.nombre = nombre;
        this.edad = edad;
    }

    public String getId() {
        return identificacion;
    }

    public String getNombre() {
        return nombre;
    }

    public int getEdad() {
        return edad;
    }

    public void setId(String identificacion) {
        this.identificacion = identificacion;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public void setEdad(int edad) {
        this.edad = edad;
    }

    

}
