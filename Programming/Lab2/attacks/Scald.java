package attacks;

import ru.ifmo.se.pokemon.*;

import java.util.Random;


public class Scald extends SpecialMove {
    public Scald() {
        super(Type.WATER, 80, 100);
    }


    @Override
    public void applyOppEffects(Pokemon opp) {
        Random random = new Random();
        if (random.nextFloat(0, 1) < 30) {
            if (!(opp.hasType(Type.FIRE) || opp.hasType(Type.WATER))) {
                opp.setMod(Stat.HP, 0);
            }
        }
        opp.setMod(Stat.SPECIAL_DEFENSE, -2);
    }


    @Override
    public String describe() {
        return "применяет Scald";
    }
}
