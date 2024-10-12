package pokemons;

import attacks.*;
import ru.ifmo.se.pokemon.Pokemon;
import ru.ifmo.se.pokemon.Type;

public class Seel extends Pokemon {
    public Seel(String name, int lvl) {
        super(name, lvl);
        setStats(65, 45, 55, 45, 70, 45);
        addType(Type.WATER);
        setMove(new Rest(), new SmartStrike(), new IceShard());
    }
}
