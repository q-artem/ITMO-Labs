package attacks;

import ru.ifmo.se.pokemon.*;

public class AcidSpray extends SpecialMove {
    public AcidSpray() {
        super(Type.POISON, 40, 1);
    }

    @Override
    public void applyOppEffects(Pokemon opp) {
        opp.setMod(Stat.SPECIAL_DEFENSE, -2);
    }

    @Override
    public String describe() {
        return "применяет AcidSpray";
    }
}
