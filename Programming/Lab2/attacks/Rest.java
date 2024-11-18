package attacks;

import ru.ifmo.se.pokemon.*;

public class Rest extends PhysicalMove {
    public Rest() {
        super(Type.PSYCHIC, 0, 0);
    }

    @Override
    public void applySelfEffects(Pokemon att) {
        Effect.sleep(att);
        att.setMod(Stat.HP, -(int)att.getStat(Stat.HP));
    }
}
