package pokemons;

import attacks.AcidSpray;
import attacks.ChargeBeam;
import attacks.ThunderWave;
import ru.ifmo.se.pokemon.Pokemon;
import ru.ifmo.se.pokemon.Type;

public class Tynamo extends Pokemon {
    public Tynamo(String name, int lvl) {
        super(name, lvl);
        setStats(35, 55, 40, 45, 40, 60);
        addType(Type.ELECTRIC);
        setMove(new ThunderWave(), new ChargeBeam());
    }
}
