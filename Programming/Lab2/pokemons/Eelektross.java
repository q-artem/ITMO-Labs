package pokemons;

import attacks.AcidSpray;
import attacks.ChargeBeam;
import attacks.Confide;
import attacks.ThunderWave;
import ru.ifmo.se.pokemon.Pokemon;
import ru.ifmo.se.pokemon.Type;

public class Eelektross extends Pokemon {
    public Eelektross(String name, int lvl) {
        setStats(85, 115, 80, 105, 80, 50);
        addType(Type.ELECTRIC);
        setMove(new ThunderWave(), new ChargeBeam(), new AcidSpray(), new Confide());
    }
}
