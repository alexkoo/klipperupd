#!/bin/bash

i=0

# Подача питания через 0.5 сек после начала прошивки

while [ $i -eq 0  ]
do

echo " "
echo " "
echo " "
echo "   Скрипт обновления klipper"
echo
echo
echo "   1 Обновление "
echo "   2 Сборка   "
echo "   3 Прошивка "
echo "   4 Выход "
echo " "


read -p "Выберите команду " step



if [ $step -eq 1 ] 
then 


#gpio write 25 1
cd ~/klipper
git pull 
~/klipper/scripts/install-octopi.sh



elif [ $step -eq 2 ]
then


cd ~/klipper
make config 
								 #make menuconfig
make clean
make



elif [ $step -eq 3 ]
then


echo 
read -e -p "Задержка: " -i 0.5 z
echo 

gpio write  25 0
sudo service octoprint stop
sudo service moonraker stop
sudo service klipper stop

echo "Сервисы остановлены"
echo " "


sleep $z && gpio write  25 1  && echo "off"	& 				# Задержка №1 после начала прошивки
sleep 0
echo "flash"											# Задержка №2 перед началом прошивки
make flash FLASH_DEVICE=/dev/ttyS1 


sudo service moonraker start
sudo service klipper start
sudo service octoprint start

echo "Сервисы Запущены"
echo " "

#gpio write  25 0


elif [ $step -eq 4 ]
then

break

else
echo "Неверная команда"
echo " "
break
fi

done
