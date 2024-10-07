package attacks;

import ru.ifmo.se.pokemon.*;

import java.util.Random;

public class ChargeBeam extends SpecialMove {
    public ChargeBeam() {
        super(Type.ELECTRIC, 50, 90);
    }

    @Override
    public void applySelfEffects(Pokemon p) {
        Random random = new Random();
        if (random.nextFloat(0, 1) < 0.7) {
            p.setMod(Stat.SPECIAL_ATTACK, 1);
        }
    }

    @Override
    public String describe() {
        return "применяет ChargeBeam";
    }
}
