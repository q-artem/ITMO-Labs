package pokemons;

import attacks.AcidSpray;
import attacks.ChargeBeam;
import attacks.ThunderWave;
import ru.ifmo.se.pokemon.Pokemon;
import ru.ifmo.se.pokemon.Type;

public class Eelektrik extends Pokemon {
    public Eelektrik(String name, int lvl) {
        super(name, lvl);
        setStats(65, 85, 70, 75, 70, 40);
        addType(Type.ELECTRIC);
        setMove(new ThunderWave(), new ChargeBeam(), new AcidSpray());
    }
}