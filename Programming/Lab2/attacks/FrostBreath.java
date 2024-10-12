package attacks;

import ru.ifmo.se.pokemon.*;

public class FrostBreath extends SpecialMove {
    public FrostBreath() {
        super(Type.ICE, 60, 90);
    }

    @Override
    public void applySelfDamage(Pokemon att, double damage) {
        att.setMod(Stat.ATTACK, 90);
    }

    @Override
    protected double calcCriticalHit(Pokemon att, Pokemon def) {
        return 1;
    }

    @Override
    public String describe() {
        return "применяет FrostBreath";
    }
}
