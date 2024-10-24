package src;

import pokemons.Eelektross;
import ru.ifmo.se.pokemon.*;
import pokemons.*;

public class Main {
    public static void main(String[] args) {
        Battle battle = new Battle();
        Pokemon red1 = new Basculin("Баскулин", 10);
        Pokemon red2 = new Seel("Верёвка", 7);
        Pokemon red3 = new Dewgong("Девгонг", 27);
        battle.addAlly(red1);
        battle.addAlly(red2);
        battle.addAlly(red3);
        Pokemon blue1 = new Tynamo("Тынамо", 10);
        Pokemon blue2 = new Eelektrik("Электрик", 27);
        Pokemon blue3 = new Eelektross("Электрон", 15);
        battle.addFoe(blue1);
        battle.addFoe(blue2);
        battle.addFoe(blue3);
        battle.go();
    }
}
