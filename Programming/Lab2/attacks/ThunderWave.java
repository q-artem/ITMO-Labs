package attacks;

import ru.ifmo.se.pokemon.*;
import java.util.Random;

public class ThunderWave extends StatusMove {
    public ThunderWave() {
        super(Type.ELECTRIC, 0, 90);
    }

    @Override
    public void applyOppEffects(Pokemon opp) {
        if (opp.hasType(Type.ELECTRIC)) {
            Random random = new Random();
            if (random.nextFloat(0, 1) < 0.25) {
                Effect.paralyze(opp);
            }
        }
    }

    @Override
    public String describe() {
        return "применяет ThunderWave";
    }
}
