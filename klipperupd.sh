#!/bin/bash
i=0
# Скрипт обновления прошивки Klipper на плате Trigorilla (AtMega 2560) при подключении по UART
# Задержка подачи питания после начала прошивки
# Задержка по-умолчанию 0.5с
####
zz=0.5
####

while [ $i -eq 0 ]; do

    echo " "
    echo " "
    echo " "
    echo " "
    echo " "
    echo " "
    echo "        Скрипт обновления klipper"
    echo "        на плате Trigorilla (AtMega 2560) при подключении по UART "
    echo "        Задержка подачи питания после начала прошивки"
    echo " "
    echo " "
    echo " "
    echo "        1 Обновление скрипта "
    echo "        2 Обновление Klipper"
    echo "        3 Сборка Klipper  "
    echo "        4 Прошивка Klipper"
    echo "        5 Выход "
    echo " "

    read -p "Выберите команду " step

    if [ $step -eq 1 ]; then # Обновление скрипта "
    # https://translated.turbopages.org/proxy_u/en-ru.ru.809fe21d-67c6a8de-ad1cd57d-74722d776562/https/stackoverflow.com/questions/59727780/self-updating-bash-script-from-github

        self_update() {
            cd ~
            rm -rf klipperupd.sh
            wget https://raw.githubusercontent.com/alexkoo/klipperupd/refs/heads/main/klipperupd.sh
            chmod +x klipperupd.sh
            echo " скрипт обновлен "
            sleep 5

        }

        self_update
        break

    elif [ $step -eq 2 ]; then #Обновление Klipper

        #gpio write 25 1
        cd ~/klipper
        git pull
        ~/klipper/scripts/install-octopi.sh

    elif [ $step -eq 3 ]; then # Сборка Klipper

        cd ~/klipper
        make config
        #make menuconfig
        make clean
        make

    elif [ $step -eq 4 ]; then # Прошивка Klipper

        echo
        read -e -p "Задержка: " -i $zz z
        echo
        sleep 1

        gpio write 25 0
        sudo service klipper stop
        sudo service moonraker stop
        # sudo service octoprint stop

        echo "Сервисы остановлены"
        echo " "
        echo " "
        echo "Start..."

        sleep $z && gpio write 25 1 && echo "On..." & # Задержка подачи питания после начала прошивки
        # Для асинхронного выполнения команды в Bash нужно поставить в самом конце команды символ &. В случае необходимости закомментировать

        # gpio write 25 1 && echo "On..." && sleep $z      # Задержка прошивки после подачи питания
        echo "Flash..."

        make flash FLASH_DEVICE=/dev/ttyS1

        sudo service klipper start
        sudo service moonraker start
        # sudo service octoprint start

        echo "Сервисы Запущены"
        echo " "

        gpio write 25 0

    elif [ $step -eq 5]; then #Выход
        break


    else
        echo "Неверная команда"
        echo " "
        break
    fi

done
