package pokemons;

import attacks.*;
import ru.ifmo.se.pokemon.Pokemon;
import ru.ifmo.se.pokemon.Type;

public class Basculin extends Pokemon {
    public Basculin(String name, int lvl) {
        super(name, lvl);
        setStats(70, 92, 65, 80, 55, 98);
        addType(Type.WATER);
        setMove(new MudShot(), new DoubleEdge(), new Scald(), new Bite());
    }
}
