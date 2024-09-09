import java.util.Random;

//TIP To <b>Run</b> code, press <shortcut actionId="Run"/> or
// click the <icon src="AllIcons.Actions.Execute"/> icon in the gutter.
public class Main {
    static Random random = new Random();

    static int num_elem = (16 - 6) / 2 + 1;
    static long[] n = new long[num_elem];
    static float[] x = new float[16];
    static double[][] s = new double[6][16];

    public static void main(String[] args) {
        for (int q = 0; q < num_elem; q++) {
            n[q] = 16 - q * 2L;
        }
        for (int q = 0; q < 16; q++) {
            x[q] = random.nextFloat(-11, 6);
        }

        for (int i = 0; i < 6; i++) {
            for (int j = 0; j < 16; j++) {
                s[i][j] = calculate_next_elem(i, j);
            }
        }

        print_results(s);
    }

    public static double calculate_next_elem(int i, int j) {
        switch ((int) n[i]) {
            case 6:
                return Math.pow(Math.log(Math.pow(Math.tan(x[j]), 2)) - 1, 3);
            case 8:
            case 12:
            case 14:
                return Math.sin(Math.sin(Math.sin(x[j])));
            default: {
                double pow = Math.pow(2 * Math.pow(Math.cbrt(x[j]), Math.log(Math.abs(x[j]))), 3);
                double numerator = Math.cbrt(Math.tan(Math.exp(x[j])));
                double denumenator = 1.0 / 4 - Math.pow(2 / (1 - Math.cbrt(Math.cbrt(x[j]))), 3);
                return Math.pow(numerator / denumenator, pow);
            }
        }
    }

    public static void print_results(double[][] s) {
        for (int i = 0; i < 6; i++) {
            for (int j = 0; j < 16; j++) {
                System.out.printf("%-11.5f", s[i][j]);
            }
            System.out.println();
        }
    }
}