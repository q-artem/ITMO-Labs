# ====== Создание файлов ======

mkdir lab0

cd lab0
touch blastoise4
touch cinccino6
touch excadrill7

mkdir lillipup2
cd lillipup2
touch lileep
touch armaldo
touch patrat
mkdir quilava
touch trubbish
mkdir vanilluxe
cd ..

mkdir mamoswine0
cd mamoswine0
mkdir mienfoo
touch vanillite
touch glaceon
touch purrloin
cd ..

mkdir volcarona5
cd volcarona5
touch seismitoad
mkdir masquerain
mkdir shellder
mkdir magikarp
cd ..

# ====== Заполнение файлов ======

echo $"Тип покемона WATER NONE" > blastoise4
echo $"Тип покемона NORMAL" > cinccino6
echo $"Тип диеты Herbivore" > excadrill7

cd lillipup2
echo $"Тип покемона ROCK\nGRASS" > lileep
echo $"Тип покемона ROCK BUG" > armaldo
echo $"Живёт Forest\nGrassland" > patrat
echo $"Способности Venom Stench Sticky\nHold" > trubbish
cd ../mamoswine0

echo $"satk=7 sdef=6 spd=5" > vanillite
echo $"Тип покемона ICE\nNONE" > glaceon
echo $"Способности Dark Art Limber\nUnburden" > purrloin
cd ../volcarona5

echo $"Способности Supersonic Round Bubblebeam Mud Shot\nAqua Ring Uproar Muddy Water Rain Dance Acid Flail Drain Punch Echoed\nVoice Hydro Pump Hyper Voice" > seismitoad
cd ..

# ====== Установка прав ======


chmod 644 blastoise4
chmod u=rw,g=,o=r cinccino6
chmod u=rw,g=w,o=w excadrill7
chmod u=rx,g=wx,o=rwx lillipup2
cd lillipup2
chmod u=,g=rw,o=w lileep
chmod 404 armaldo
chmod u=,g=rw,o=w patrat
chmod u=rwx,g=wx,o=rwx quilava
chmod u=,g=,o=r trubbish
chmod 500 vanilluxe
cd ..
chmod u=wx,g=rw,o=x mamoswine0
cd mamoswine0
chmod 305 mienfoo
chmod u=,g=rw,o=w vanillite
chmod 046 glaceon
chmod u=r,g=,o= purrloin
cd ..
chmod u=rx,g=x,o=w volcarona5
cd volcarona5
chmod 404 seismitoad
chmod u=rwx,g=rx,o=w masquerain
chmod u=rwx,g=wx,o=rwx shellder
chmod u=wx,g=x,o=w magikarp
cd ..

# ====== Копирование файлов и создание ссылок ======

ln -s volcarona5 Copy_49
cp -R volcarona5 mamoswine0/mienfoo/volcarona5
ln -s excadrill7 mamoswine0/vanilliteexcadrill
cat cinccino6 > lillipup2/lileepcinccino
ln excadrill7 mamoswine0/purrloinexcadrill
cat lillipup2/lileep mamoswine0/glaceon > cinccino6_48
cp cinccino6 volcarona5/shellder/cinccino6

# ====== Поиск и фильтры ======



pause