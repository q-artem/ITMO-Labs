    ORG 0x0
V0: WORD $DEFAULT, 0x180  ; Вектор прерывания #0
V1: WORD $INT_1, 0x180    ; Вектор прерывания #1
V2: WORD $INT_2, 0x180    ; Вектор прерывания #2
V3: WORD $DEFAULT, 0x180  ; Вектор прерывания #3
V4: WORD $DEFAULT, 0x180  ; Вектор прерывания #4
V5: WORD $DEFAULT, 0x180  ; Вектор прерывания #5
V6: WORD $DEFAULT, 0x180  ; Вектор прерывания #6
V7: WORD $DEFAULT, 0x180  ; Вектор прерывания #7

DEFAULT: IRET  ; Дефолтный вектор

X:           WORD 0x084   ; Адрес ячейки X (по заданию 5, но оно пересекается с векторами)
start_value: WORD 0x0042  ; стартовое значение X

START: NOP
       LD start_value  ; записали стартовое значение в X
       CALL clamp_var
       ST (X)
                       ;
       DI              ; запрет прерываний
       LD #0x9         ; Разрешение прерываний и вектор 1
       OUT 0x3         ; ВУ-1 на вектор INT_1
       LD #0xA         ; Разрешение прерываний и вектор 2
       OUT 0x5         ; ВУ-2 на вектор INT_2
       EI              ; Прерываемся
                       ;
main:  DI
       LD (X)
       SUB #0x02
       CALL clamp_var
       ST (X)
       OUT 0x06        ; добавлен вывод текущего X на ВУ-3
       EI
       NOP             ; прерываемся только здесь
       JUMP main


min_var:       WORD 0x0000
max_var:       WORD 0x00FF
clamp_var:     CMP max_var      ; ограничение переменной в AC от min_var до max_var
               BNC fix_max_var  ; если максимум строго меньше значения
               DEC
               CMP min_var
               BNS fix_min_var  ; если минимум больше или равен значению-1 => строго больше
               INC
               JUMP end_clamp_var
fix_max_var:   LD max_var
               JUMP end_clamp_var
fix_min_var:   LD max_var       ; LD min_var  ; по заданию пишем максимальное число
               JUMP end_clamp_var
end_clamp_var: RET



cntr:           WORD ?
var_a:          WORD 0x05
var_b:          WORD 0x06
calculate_func: LD var_a   ; Подсчёт функции a*X - b, X - в стеке
                ST cntr    ; записали на сколько умножить
                CLA
loop1:          ADD &1     ; сложили в цикле
                LOOP cntr
                JUMP loop1
                SUB var_b  ; минус b
                ST &1      ; записали в стек
                RET

buffer:  WORD ?      ; ;                                             1       2     3     4     5
not_xor: NOP         ; исключающее ИЛИ-НЕ (00-1, 01-0, 10-0, 11-1) (not ((a or b) and (not (a and b))))
         LD &1
         AND &2      ; 5
         NOT         ; 4
         ST buffer
         LD &1
         OR &2       ; 2
         AND buffer  ; 3
         NOT         ; 1
         ST &2       ; запись в стек
         POP
         SWAP        ; убрали ненужный аргумент
         RET


                            ; прерывание по ВУ-1
INT_1: NOP                  ; подсчёт функции и вывод на ВУ-1
       LD (X)               ; загружаем X в AC
       PUSH
       CALL calculate_func  ; Подсчёт функции
       POP
       CALL clamp_var
       OUT 0x02             ; вывод на ВУ-1
       IRET

mask:  WORD 0x00FF   ; прерывание по ВУ-2
INT_2: NOP           ; подсчёт исключающего ИЛИ-НЕ и запись в X
       LD (X)        ; загружаем X в AC
       PUSH
       IN 0x04
       PUSH
       CALL not_xor  ; Подсчёт исключающего ИЛИ-НЕ
       POP
                     ; AND #0xFF  ; обрежем мусор почему не работает?
       AND mask      ; обрежем мусор
       CALL clamp_var
       ST (X)
       IRET
