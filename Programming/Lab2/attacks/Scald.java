package attacks;

import ru.ifmo.se.pokemon.*;

public class Scald extends SpecialMove {
    public Scald() {
        super(Type.WATER, 80, 100);
    }



    @Override
    public String describe() {
        return "применяет Scald";
    }
}
