package attacks;

import ru.ifmo.se.pokemon.*;

public class Confide extends StatusMove {
    public Confide() {
        super(Type.NORMAL, 0, 0);
    }

    @Override
    public void applyOppEffects(Pokemon opp) {
        opp.setMod(Stat.SPECIAL_ATTACK, -1);
    }

    @Override
    public String describe() {
        return "применяет Confide";
    }
}
