package attacks;

import java.util.Random;
import ru.ifmo.se.pokemon.*;

public class Bite extends PhysicalMove {
    public Bite() {
        super(Type.DARK, 60, 100);
    }

    @Override
    public void applyOppEffects(Pokemon opp) {
        Random random = new Random();
        if (random.nextFloat(0, 1) < 0.3) {
            Effect.flinch(opp);
        }
    }

    @Override
    public String describe() {
        return "применяет Bite";
    }
}
