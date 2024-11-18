package pokemons;

import attacks.Confide;
import ru.ifmo.se.pokemon.Type;

public class Eelektross extends Eelektrik {
    public Eelektross(String name, int lvl) {
        super(name, lvl);
        setStats(85, 115, 80, 105, 80, 50);
        addType(Type.ELECTRIC);
        addMove(new Confide());
    }
}
