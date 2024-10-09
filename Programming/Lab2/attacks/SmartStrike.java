package attacks;

import ru.ifmo.se.pokemon.PhysicalMove;
import ru.ifmo.se.pokemon.Type;

public class SmartStrike extends PhysicalMove {
    public SmartStrike() {
        super(Type.STEEL, 70, 1000000000);
    }

    @Override
    public String describe() {
        return "применяет SmartStrike";
    }
}
