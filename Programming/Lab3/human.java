public abstract class Human() {
    protected String name;

    public Person(String name, Eyes eyes) {
        this.name = name;
    }

    public void setName(String name) {
        this.name = name
    }

    public String getName() {
        return name;
    }
}