  ; ;;;;;;;;;;;;;;;; Paint в БЭВМ!!!!!! ;;;;;;;;;;;;;;;;
  
  ; ;;;;;;;;;;;;; Вывод данных ;;;;;;;;;;;;;;
  ; ВУ-6 - бегущая строка - поле для рисования
  ; КВУ-3 - (индикация курсора), на холсте курсор не мигает потому что БЭВМ костыль
  ; КВУ-1 - Координаты курсора, старшие 4 бита - Y mod 16, младшие 4 бита - X
  
  ; ;;;;;;;;;;;;; Ввод данных ;;;;;;;;;;;;;;;
  ; ВУ-9 - клавиатура
  ; ;; Управление курсором
  ; ;;;; "*" - курсор
  ; ;;;; "+" - карандаш
  ; ;;;; "-" - ластик
  ; ;; Управление передвижением курсора
  ; ;;;; цифры 1, 2, 3, 4, 6, 7, 8, 9 - перемещение курсора в соотв. направлении относительно цифры 5
  ; ;;;; 0 - сброс положения курсора в ноль
  ; ;; Очистка холста - клавиша "/"
  ; ;; Вывод битмапа - клавиша "="
  ; КВУ-3 - кнопка Готов - остановка программы
  
  ; ;;;;;;;;;;;;;; Настройки ;;;;;;;;;;;;;;;;
  ; Для нормальной работы
  ; ;; Поставить максимальную скорость клавишей F12 (5 нажатий)
  ; ;; Поставить минимальную задержку бегущей строки
  ; ;; Открыть вкладку "БЭВМ"

  ; ;;;;;;;;;;;; (не)приятного пользования! ;;;;;;;;;;;;

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

                                ; Настройки
blink_cursor_period: WORD 0x01  ; Период мигания курсора в 1/10 сек.

                          ; Глобальные переменные
curr_x:       WORD 0x00   ; Текущая координата X (0..7)
curr_y:       WORD 0x00   ; Текущая координата Y (0..31)
max_x:        WORD 0x07   ; Максимальный X
max_y:        WORD 0x1F   ; Максимальный Y и размер массива соотв.
cursor_state: WORD 0x00   ; Состояние курсора сейчас ((0) - 0011, (1) - 1110, (2) - 0001)
pen_state:    WORD 0x00   ; Перо поднято (0), опущено как перо (1), опущено как ластик (2)
st_arr:       WORD 0x400  ; Начало массива

  ; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; MAIN

START: NOP
       DI                      ; запрет прерываний
       LD #0x9                 ; Разрешение прерываний и вектор 1
       OUT 0x1                 ; Таймер на вектор INT_TIMER
       LD blink_cursor_period  ; Таймер на 0.2 * 10 = 2 сек
       OUT 0x0                 ; Запись в DR таймера
       EI                      ; Прерываемся
                               ;
loop0: DI
       CALL tick               ; обработка клавиатуры
       EI
       NOP                     ; прерываемся только здесь, чтобы ничего не мешало выводу
skip:  IN 0x7                  ; Читаем регистр состояния ВУ-3
       AND #0x40               ; Проверка на 6 бит
       BEQ loop0               ; Если не стоит, повторить
       IN 0x6                  ; Иначе стоп
       HLT
       JUMP loop0

  ; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; FUNCTIONS

tick:                 ; Обработка клавиатуры
          IN 0x1D     ; Читаем регистр состояния ВУ-9
          AND #0x40   ; Проверка на 6 бит
          BEQ ret_0   ; Если не стоит, скип
          IN 0x1C
                      ;
          CMP #0x00   ; сброс курсора в 0
          BZC skip_NLL
          LD #0x00
          ST curr_x
          ST curr_y
          LD #0x01
          PUSH
          PUSH
          CALL move_cursor
          JUMP ret_tick
skip_NLL: CMP #0x0F   ; вывод битмапы
          BZC skip_btp
          CALL $show_duck
          JUMP ret_0
skip_btp: CMP #0x0C   ; очистка холста
          BZC skip_C
          CALL $clear_arr
          JUMP ret_tick
skip_C:   CMP #0x0D   ; режим курсора
          BZC skip_00
          LD #0x00
          ST $pen_state
          JUMP ret_0
skip_00:  CMP #0x0B   ; режим рисования
          BZC skip_000
          LD #0x01
          ST $pen_state
          JUMP ret_0
skip_000: CMP #0x0A   ; режим ластика
          BZC skip_0  ; если нет - переходим к проверке на сдвиг курсора
          LD #0x02
          ST $pen_state
          JUMP ret_0
skip_0:   CMP #0x07   ; влево-вверх (x|, y-) (0 - в минус, 1 - в ноль, 2 - в плюс)
          BZC skip_1
          LD #0x02
          PUSH
          PUSH
          CALL move_cursor
          JUMP ret_tick
skip_1:   CMP #0x08   ; вверх
          BZC skip_2
          LD #0x02
          PUSH
          LD #0x01
          PUSH
          CALL move_cursor
          JUMP ret_tick
skip_2:   CMP #0x09   ; вправо-вверх
          BZC skip_3
          LD #0x02
          PUSH
          LD #0x00
          PUSH
          CALL move_cursor
          JUMP ret_tick
skip_3:   CMP #0x04   ; влево
          BZC skip_4
          LD #0x01
          PUSH
          LD #0x02
          PUSH
          CALL move_cursor
          JUMP ret_tick
skip_4:   CMP #0x06   ; вправо
          BZC skip_5
          LD #0x01
          PUSH
          LD #0x00
          PUSH
          CALL move_cursor
          JUMP ret_tick
skip_5:   CMP #0x01   ; влево-вниз
          BZC skip_6
          LD #0x00
          PUSH
          LD #0x02
          PUSH
          CALL move_cursor
          JUMP ret_tick
skip_6:   CMP #0x02   ; вниз
          BZC skip_7
          LD #0x00
          PUSH
          LD #0x01
          PUSH
          CALL move_cursor
          JUMP ret_tick
skip_7:   CMP #0x03   ; вправо-вниз
          BZC skip_8
          LD #0x00
          PUSH
          PUSH
          CALL move_cursor
          JUMP ret_tick
skip_8:   JUMP ret_0
ret_tick: CALL $show
ret_0:    RET



move_cursor:             ; движение курсора на значения в стеке
             LD &1       ; смещение по y
             DEC         ; поправка для удобства
             ADD $curr_y
             CMP #0x00
             BLT skip_y  ; если получилось меньше 0 - скип
             DEC
             CMP $max_y  ; если больше максимума - тоже скип
             BGE skip_y
             INC
             ST $curr_y
skip_y:      LD &2       ; смещение по x
             DEC         ; поправка для удобства
             ADD $curr_x
             CMP #0x00
             BLT skip_x  ; если получилось меньше 0 - скип
             DEC
             DEC
             CMP $max_x  ; если больше максимума - тоже скип
             BGE skip_x
             INC
             INC
             ST $curr_x
skip_x:      POP
             SWAP
             POP
             SWAP
             LD $curr_x
             OUT 0x06
             LD $curr_y
             ASL
             ASL
             ASL
             ASL
             ADD $curr_x
             OUT 0x02
             CALL draw_dot
             RET



mask:       WORD 0x00       ; будущая маска
mask_cntr:  WORD 0x00       ; цикл
y_pos:      WORD 0x00       ; для нахождение позиции y
draw_dot:
            LD $curr_x
            ST mask_cntr
            LD #0x01
loop_mask:  ASL
            LOOP mask_cntr
            JUMP loop_mask
            ASR
            ST mask
            LD $st_arr      ; готовим координату
            ADD $curr_y
            ST y_pos
                            ;
            LD $pen_state
            BZS skip_point  ; если режим курсора - скип
            DEC
            BZC eraser      ; если режим ластика => в AC 1
            LD #0x02
eraser:     DEC             ; теперь 0й бит в AC - нужный цвет пикселя (x, y)
                            ;
            BZS draw_light  ; если рисуем, а не стираем
            LD (y_pos)
            OR mask
            ST (y_pos)
            RET
draw_light:
            LD mask
            NEG
            ST mask
            LD (y_pos)
            AND mask
            ST (y_pos)
skip_point: RET



cntr1:    WORD 0x00
pointer1: WORD 0x00
show:     NOP  ; обновление холста
          LD $max_y
          INC
          ST cntr1
          LD $st_arr
          ADD cntr1
          ST pointer1
          CLA
loop2:    LD -(pointer1)
          OUT 0x10
          NOP
          LOOP cntr1
          JUMP loop2
          RET


cntr2:     WORD 0x00
pointer2:  WORD 0x00
bitmap2:   WORD 0x141
show_duck: NOP  ; вывод битмапы
           LD $max_y
           INC
           ST cntr2
           LD bitmap2
           ADD cntr2
           ST pointer2
loop3:     LD -(pointer2)
           NOT
           OUT 0x10
           NOP
           LOOP cntr2
           JUMP loop3
           RET



cntr:      WORD 0x00
pointer:   WORD 0x00
clear_arr: NOP           ; очистка холста
           LD $max_y
           INC
           ST cntr
           LD $st_arr
           ST pointer
           CLA
loop1:     ST (pointer)+  ; Пишем пустой столбец
           LOOP cntr
           JUMP loop1
           CALL show
           RET



get_cursor_state:                         ; Возвращает текущее состояние точки курсора (0 или 1)
                   LD &1                  ; Состояние счётчика (случай счётчик == 0)
                   BZC if_cursor_state_1  ; Если не 0, дальше
                   LD $pen_state          ; Если 0, грузим состояние пера
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
                   LD $pen_state          ; Если 0, грузим состояние пера
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
                   LD $pen_state          ; Если 0, грузим состояние пера
                   DEC
                   DEC
                   BZS if_1_2             ; Если опущено как ластик (2)
                   LD #0x01
                   ST &1                  ; Возвращаем 1
                   RET
if_1_2:            ST &1                  ; Возвращаем 0
                   RET
if_cursor_state_3: LD $pen_state          ; Грузим состояние пера (случай счётчик == 3)
                   DEC
                   BZS if_1_3             ; Если опущено как перо (1)
                   LD #0x01
                   ST &1                  ; Возвращаем 1
                   RET
if_1_3:            ST &1                  ; Возвращаем 0
                   RET



INT_TIMER:                          ; Инкрементируем счётчик состояния курсора
           LD $cursor_state
           INC
           SUB #0x04
           BZS if1
           ADD #0x04
if1:       ST $cursor_state
                                    ; Получаем текущее состояние курсора
           PUSH
           CALL get_cursor_state
           POP
           OUT 0x6                  ; вот здесь вот должна быть show, а в show отрисовка курсора, но бэвм медленная хрень
                                    ; Переставляем таймер
           LD $blink_cursor_period  ; Перезаводим эту хрень
           OUT 0x0                  ; Запись в DR таймера
           IRET
NOP
NOP
NOP
NOP
WORD 0x00, 0x00, 0x7e, 0xff, 0xff, 0xe3, 0xe1, 0xf1, 0x81, 0x01, 0x81, 0xd3, 0xff, 0x7f, 0x3f, 0x3f, 0x01, 0x01, 0x3f, 0x3f, 0xff, 0x83, 0x81, 0x2d, 0x2d, 0x01, 0x01, 0xff, 0xff, 0x7e, 0x00, 0x00