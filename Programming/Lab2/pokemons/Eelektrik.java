package pokemons;

import attacks.AcidSpray;
import ru.ifmo.se.pokemon.Type;

public class Eelektrik extends Tynamo {
    public Eelektrik(String name, int lvl) {
        super(name, lvl);
        setStats(65, 85, 70, 75, 70, 40);
        addType(Type.ELECTRIC);
        addMove(new AcidSpray());
    }
}