package attacks;

import ru.ifmo.se.pokemon.*;

public class MudShot extends SpecialMove {
    public MudShot() {
        super(Type.GROUND, 55, 95);
    }

    @Override
    public void applyOppEffects(Pokemon opp) {
        opp.setMod(Stat.SPEED, -1);
    }

    @Override
    public String describe() {
        return "применяет MudShot";
    }
}
