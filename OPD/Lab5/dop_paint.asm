    ORG 0x0
V0: WORD $DEFAULT, 0x180    ; Вектор прерывания #0
V1: WORD $INT_TIMER, 0x180  ; Вектор прерывания #1
V2: WORD $DEFAULT, 0x180    ; Вектор прерывания #2
V3: WORD $DEFAULT, 0x180    ; Вектор прерывания #3
V4: WORD $DEFAULT, 0x180    ; Вектор прерывания #4
V5: WORD $DEFAULT, 0x180    ; Вектор прерывания #5
V6: WORD $DEFAULT, 0x180    ; Вектор прерывания #6
V7: WORD $DEFAULT, 0x180    ; Вектор прерывания #7
    
DEFAULT: IRET  ; Дефолтный вектор
         
curr_x:              WORD 0x00    ; Текущая координата X (0..7)
curr_y:              WORD 0x00    ; Текущая координата Y (0..31)
max_x:               WORD 0x07    ; Максимальный X
max_y:               WORD 0x1F    ; Максимальный Y и размер массива соотв.
blink_cursor_period: WORD 0x01    ; Период мигания курсора в 1/10 сек.
cursor_state:        WORD 0x00    ; Состояние курсора сейчас ((0) - 0011, (1) - 1110, (2) - 0001)
pen_state:           WORD 0x00    ; Перо поднято (0), опущено как перо (1), опущено как ластик (2)
st_arr:              WORD 0xA000  ; Начало массива
                     
START: DI
       LD #0x9                 ; Разрешение прерываний и вектор 1
       OUT 0x1                 ; Таймер на вектор INT_TIMER
       LD blink_cursor_period  ; Таймер на 0.2 * 10 = 2 сек
       OUT 0x0                 ; Запись в DR таймера
       EI                      ; Прерываемся!!
       
ind:   WORD 0x0000
loop0: LD ind
       INC
       OUT 0x10   ; Вывести правый байт в ВУ-6
       ST ind

       IN 0x1D     ; Читаем регистр состояния ВУ-9
       AND #0x40  ; Проверка на 6 бит
       BEQ skip  ; Если не стоит, дальше
       IN 0x1C
       ST pen_state

       skip: IN 0x7     ; Читаем регистр состояния ВУ-3
       AND #0x40  ; Проверка на 6 бит
       BEQ loop0  ; Если не стоит, повторить
       OUT 0x6    ; Вывести правый байт в ВУ-3
       HLT
       CALL $clear_arr
       HLT
       JUMP loop0
       
show:
       
       
clear_arr: NOP       ; очистка холста
cntr:      WORD 0x00
           LD max_y
           INC
           ST cntr
pointer:   WORD 0x00
           LD st_arr
           ST pointer
           CLA
loop1:     OUT 0x10  ; Пишем пустой столбец
           LOOP cntr
           JUMP loop1
           RET
                   
       
                                          ; Возвращает текущее состояние точки курсора (0 или 1)
get_cursor_state:  
                   LD &1                  ; Состояние счётчика (случай счётчик == 0)
                   BZC if_cursor_state_1  ; Если не 0, дальше
                   LD pen_state           ; Если 0, грузим состояние пера
                   DEC
                   BZS if_1_0             ; Если опущено как перо (1)
                   LD #0x00
                   ST &1                  ; Возвращаем 0
                   RET
if_1_0:            LD #0x01
                   ST &1                  ; Возвращаем 1
                   RET
if_cursor_state_1: LD &1                  ; Состояние счётчика (случай счётчик == 1)
                   DEC
                   BZC if_cursor_state_2  ; Если не 1, дальше
                   LD pen_state           ; Если 0, грузим состояние пера
                   DEC
                   BZS if_1_1             ; Если опущено как перо (1)
                   LD #0x00
                   ST &1                  ; Возвращаем 0
                   RET
if_1_1:            LD #0x01
                   ST &1                  ; Возвращаем 1
                   RET
if_cursor_state_2: LD &1                  ; Состояние счётчика (случай счётчик == 2)
                   DEC
                   DEC
                   BZC if_cursor_state_3  ; Если не 2, дальше
                   LD pen_state           ; Если 0, грузим состояние пера
                   DEC
                   DEC
                   BZS if_1_2             ; Если опущено как ластик (2)
                   LD #0x01
                   ST &1                  ; Возвращаем 1
                   RET
if_1_2:            ST &1                  ; Возвращаем 0
                   RET
if_cursor_state_3: LD pen_state           ; Грузим состояние пера (случай счётчик == 3)
                   DEC
                   BZS if_1_3             ; Если опущено как перо (1)
                   LD #0x01
                   ST &1                  ; Возвращаем 1
                   RET
if_1_3:            ST &1                  ; Возвращаем 0
                   RET


INT_TIMER: 
                                   ; Инкрементируем счётчик состояния курсора
           LD cursor_state
           INC
           SUB #0x04
           BZS if1
           ADD #0x04
if1:       ST cursor_state
                                   ; Получаем текущее сосотояние курсора
           PUSH
           CALL get_cursor_state
           LD cursor_state
           ASL
           ASL
           ASL
           ASL
           OR &0
           OUT 0x6
           POP
                                   ; Переставляем таймер
           LD blink_cursor_period  ; Перезаводим эту хрень
           OUT 0x0                 ; Запись в DR таймера
           IRET
           
           