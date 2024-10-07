package pokemons;

import attacks.*;
import ru.ifmo.se.pokemon.Pokemon;
import ru.ifmo.se.pokemon.Type;


public class Dewgong extends Pokemon {
    public Dewgong(String name, int lvl) {
        super(name, lvl);
        setStats(90, 70, 80, 70, 95, 70);
        addType(Type.WATER);
        addType(Type.ICE);
        setMove(new Rest(), new SmartStrike(), new IceShard(), new FrostBreath());
    }
}
