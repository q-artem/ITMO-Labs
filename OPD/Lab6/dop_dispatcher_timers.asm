  ; ;;;;;;;;;;;;;;;; Dispatcher в БЭВМ ;;;;;;;;;;;;;;;;;

  ; ; Диспетчер с очередью таймеров. Для добавления задачи в очередь нужно запушить в стек
  ; ; 4 аргумента и вызвать add_task. Пример на строке 63. НЕОБХОДИМО УКАЗАТЬ ТОЧНЫЙ АДРЕС НАЧАЛА КОМАНДЫ

  ; ; Для быстрой работы можно разогнать БЭВМ (5 раз нажать F12) и переключиться на вкладку ассемблера,
  ; ; графический интерфейс силь замедляет работу

    ORG 0x0
V0: WORD $DEFAULT, 0x180    ; Вектор прерывания #0
V1: WORD $INT_TIMER, 0x180  ; Вектор прерывания #1
V2: WORD $DEFAULT, 0x180    ; Вектор прерывания #2
V3: WORD $DEFAULT, 0x180    ; Вектор прерывания #3
V4: WORD $DEFAULT, 0x180    ; Вектор прерывания #4
V5: WORD $DEFAULT, 0x180    ; Вектор прерывания #5
V6: WORD $DEFAULT, 0x180    ; Вектор прерывания #6
V7: WORD $DEFAULT, 0x180    ; Вектор прерывания #7

DEFAULT:      IRET  ; Дефолтный вектор
timer_period: WORD 0x01

flag_blink_byte: WORD 0x0000
  ; ;;;;;;;;;;;;;;;;;;;;; MAIN ;;;;;;;;;;;;;;;;;;;;;;

START: NOP
       CALL start_clean_tasks
       NOP              ; Первоначальная постановка задач
                        ;
       LD #0x0A         ; Таймер 1 секунда
       PUSH             ; Аргумент 2
       PUSH             ; Аргумент 1
       PUSH             ; Таймер 1 c
       LD #0x27         ; Адрес задачи
       PUSH
       CALL add_task    ; добавили задачу
                        ;
       NOP              ; Настройка прерывания
       DI               ; запрет прерываний
       LD #0x9          ; Разрешение прерываний и вектор 1
       OUT 0x1          ; Таймер на вектор INT_TIMER
       LD timer_period  ; Таймер
       OUT 0x0          ; Запись в DR таймера
       EI               ; Прерываемся
                        ;
loop0: CALL tick        ; обработка очереди
       NOP              ; Прерываемся
       JUMP loop0       ; Цикл

  ; ;;;;;;;;;;;;;;;;;;;;;;;; TASKS ;;;;;;;;;;;;;;;;;;;;;;;

blink_byte: POP                 ; для примера помигаем раз в секунду ВУ 1  адрес 0x27
            SWAP                ; убрали аргумент из стека
            POP
            SWAP
                                ;
            LD flag_blink_byte  ; загрузили - инвертировали
            NOT
            ST flag_blink_byte
            OUT 0x2             ; зажгли
                                ; Запускаем эту же задачу через 1 секунду
            LD #0x0A            ; Таймер 1 секунда
            PUSH                ; Аргумент 2
            PUSH                ; Аргумент 1
            PUSH                ; Таймер 1 c
            LD #0x27            ; Адрес задачи
            PUSH
            CALL add_task       ; добавили задачу
            RET


  ; ;;;;;;;;;;;;;;;;;;;;;; FUNCTIONS ;;;;;;;;;;;;;;;;;;;;;

pointer_clean_tasks: WORD 0x0000  ; указатель на элемент очереди
cntr_clean_tasks:    WORD ?       ; счётчик для цикла
col_tasks:           WORD 0x0100  ; количество задач

start_clean_tasks:  ; стартовая очистка области задач
                   LD $start_queue_timers
                   ST $pointer_clean_tasks
                   LD col_tasks
                   ST $cntr_clean_tasks
                    ;
                   CLA
                   NOT
loop_clean_tasks:  ST (pointer_clean_tasks)+
                   LOOP $cntr_clean_tasks
                   JUMP loop_clean_tasks
                   RET



cntr_add_task:    WORD ?  ; счётчик для цикла
pointer_add_task: WORD ?  ; указатель на элемент очереди

add_task:                          ; Добавление задачи в очередь. в стеке 4:arg2, 3:arg1, 2:таймер, 1:адрес задачи. В AC 1 - если удачно, 0 - если нет места в очереди
                     LD #0x40                  ; 64 таймера в очереди
                     ST $cntr_add_task         ; установили счётчик
                     LD $start_queue_timers
                     ST $pointer_add_task      ; поставили указатель на начало очереди
                                               ;
loop_find_task:      LD (pointer_add_task)     ; Поиск места в очереди
                     AND mask_no_tasks         ; взяли старший полубайт
                     BZS skip_add_task         ; если ноль, значит место занято - скип
                                               ; Если место свободно
                     DI                        ; Чтобы ничего не сломалось из-за не полностью добавленной задачи - выключаем прерывания
                     LD &1                     ; загрузили адрес задачи
                     ST (pointer_add_task)     ; положили в очередь по указателю
                                               ; Таймер
                     LD pointer_add_task       ; инкрементируем указатель
                     INC
                     ST pointer_add_task
                     LD &2                     ; загрузили таймер
                     ST (pointer_add_task)     ; положили в очередь по указателю
                                               ; Первый аргумент
                     LD pointer_add_task       ; инкрементируем указатель
                     INC
                     ST pointer_add_task
                     LD &3                     ; загрузили первый аргумент
                     ST (pointer_add_task)     ; положили в очередь по указателю
                                               ; Второй аргумент
                     LD pointer_add_task       ; инкрементируем указатель
                     INC
                     ST pointer_add_task
                     LD &4                     ; загрузили второй аргумент
                     ST (pointer_add_task)     ; положили в очередь по указателю
                                               ;
                     LD &0                     ; загрузили адрес возврата
                     ST &4                     ; положили на место 2 аргумента
                     POP
                     POP
                     POP                       ; Удалили все аргументы
                     POP
                     EI                        ; добавили - включаем
                     JUMP successful_add_task  ; добавили успешно - выходим
                                               ;
skip_add_task:       LD pointer_add_task       ; инкрементируем указатель
                     ADD #0x04
                     ST pointer_add_task
                                               ;
                     LOOP $cntr_add_task
                     JUMP loop_find_task
                                               ;
                     JUMP not_find_place       ; если цикл закончился значит место не нашлось
                                               ; ищем первое свободное место в очереди
successful_add_task:                           ; Успешно
                     LD #0x01
                     JUMP exit_add_task        ; выходим
not_find_place:                                ; Не хватило места
                     CLA
exit_add_task:       RET


add_task_no_timer:                ; Добавление задачи в очередь без таймера. в стеке 3:arg2, 2:arg1, 1:адрес задачи
                   LD &0          ; загрузили адрес возврата
                   PUSH           ; положили на стек
                   LD &2          ; загрузили адрес задачи
                   ST &1          ; положили на правильную позицию
                   CLA
                   ST &2          ; поставили таймер в 0
                   CALL add_task  ; добавили задачу
                   RET



buffer_addr_task: WORD ?       ; буфер
mask_addr_task:   WORD 0x0FFF  ; маска только для адреса задачи

tick:                               ; Выполнение задачи из стека задач
          CALL get_col_stack_tasks  ; получили количество задач
          BZS no_tasks              ; если задач нет - выходим
          CALL get_from_stack       ; получили адрес адреса задачи

                                    ;
          ADD #0x02                 ; адрес первого аргумента
          ST buffer_addr_task
          LD (buffer_addr_task)     ; получили первый аргумент
          PUSH                      ; пихнули в стек
                                    ;
          LD buffer_addr_task
          INC                       ; адрес второго аргумента
          ST buffer_addr_task
          LD (buffer_addr_task)     ; получили второй аргумент
          PUSH                      ; пихнули в стек
                                    ;
          LD buffer_addr_task       ; вернули как было
          SUB #0x03
          ST buffer_addr_task
                                    ;
          LD (buffer_addr_task)     ; получили адрес задачи
          AND mask_addr_task        ; оставили только адрес
          ST buffer_addr_task       ; записали адрес задачи
          CALL (buffer_addr_task)   ; вызвали задачу, которая должна сделать x2 POP-SWAP
no_tasks: RET

  ; ;;;;;;;;;;;;;;;;;;;;;;;;;; Управление стеком задач ;;;;;;;;;;;;;;;;;;;;;;;;;;;

pointer_stack_tasks: WORD 0x5C0  ; 64 задачи, на 64 ячейки до таймеров, указывает на первую свободную ячейку
col_stack_tasks:     WORD 0x00   ; количество задач в стеке

add_to_stack:                           ; добавление в стек задачи, с адресом из AC
              ST (pointer_stack_tasks)  ; поставили задачу
              LD pointer_stack_tasks    ; увеличили указатель
              INC
              ST pointer_stack_tasks
              LD col_stack_tasks        ; увеличили количество задач
              INC
              ST col_stack_tasks
              RET

get_col_stack_tasks:  ; получение количества задач в стеке
                     LD $col_stack_tasks
                     RET

get_from_stack:                           ; получение задачи из стека в AC
                LD $pointer_stack_tasks   ; уменьшили указатель
                DEC
                ST $pointer_stack_tasks
                LD $col_stack_tasks       ; уменьшили количество задач
                DEC
                ST $col_stack_tasks
                LD (pointer_stack_tasks)  ; получили задачу
                RET

  ; ;;;;;;;;;;;;;;;;;;;;;;;;;; Прерывание таймера ;;;;;;;;;;;;;;;;;;;;;;;;;;

start_queue_timers:   WORD 0x600   ; 64 таймера
pointer_queue_timers: WORD ?
cntr_queue_timers:    WORD ?
mask_no_tasks:        WORD 0xF000  ; для отметки задачи как завершённой

INT_TIMER:
                   LD $start_queue_timers
                   ST $pointer_queue_timers   ; поставили указатель на начало
                   LD #0x40                   ; всего может быть (0x700 - 0x600) / 4 = 0x40 = 64 таймера
                   ST $cntr_queue_timers
                                              ;
loop_queue_timers: LD (pointer_queue_timers)  ; загрузили адрес
                   AND mask_no_tasks          ; проверяем, завершена ли задача
                   BZC end_check_timer        ; если F а не 0 - скип
                                              ;
                   LD $pointer_queue_timers   ; пробегаемся по очереди таймеров, сначала проверяем на 0, чтобы можно было ставить задачи с нулевым временем
                   INC                        ; смотрим таймер
                   ST $pointer_queue_timers
                   LD (pointer_queue_timers)  ; загрузили таймер
                   BZC timer_not_zero         ; если 0, то закидываем адрес адреса в стек и помечаем задачу как завершённую
                   LD $pointer_queue_timers
                   DEC
                   ST $pointer_queue_timers   ; вернули как было
                   CALL $add_to_stack         ; закинули в стек
                                              ; помечаем задачу как завершённую
                   LD (pointer_queue_timers)  ; загрузили по указателю
                   OR mask_no_tasks           ; поставили 0xFXXX
                   ST (pointer_queue_timers)  ; записали
                   JUMP end_check_timer
                                              ;
timer_not_zero:    DEC                        ; если не 0, то уменьшаем и записываем
                   ST (pointer_queue_timers)  ; уменьшаем время
                                              ;
end_check_timer:   LD $pointer_queue_timers   ; инкрементировали указатель
                   ADD #0x04                  ; инкремент на 4
                   ST $pointer_queue_timers
                                              ;
                   LOOP $cntr_queue_timers
                   JUMP loop_queue_timers
                                              ;
                   LD $timer_period           ; Перезаводим эту хрень
                   OUT 0x0                    ; Запись в DR таймера
                                              ;
                   IRET
