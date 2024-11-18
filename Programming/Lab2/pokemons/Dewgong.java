package pokemons;

import attacks.*;
import ru.ifmo.se.pokemon.Type;


public class Dewgong extends Seel {
    public Dewgong(String name, int lvl) {
        super(name, lvl);
        setStats(90, 70, 80, 70, 95, 70);
        addType(Type.WATER);
        addType(Type.ICE);
        addMove(new FrostBreath());
    }
}
