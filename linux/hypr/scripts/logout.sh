# Written by KalpaKavindu <kalpadevonline@gmail.com>

killcode(){
    ps cax | grep code > /dev/null
    if [ $? -eq 0 ]; then
        killall -SIGKILL code
    fi
}

killcode
uwsm stop