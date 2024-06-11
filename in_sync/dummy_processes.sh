#!/bin/bash

# Define the names of the processes
DUMMY_PROCESS="dummy_process"
LIVE_DUMMY_PROCESS="live_dummy_process"

start_processes() {
    # Start dummy_process in the background
    nohup perl -MPOSIX -e '$0="dummy_process"; pause' &
    DUMMY_PID=$!
    echo $DUMMY_PID > "/tmp/${DUMMY_PROCESS}.pid"
    echo "dummy_process started with PID $DUMMY_PID"
    
    # Start live_dummy_process in the background
    nohup perl -MPOSIX -e '$0="live_dummy_process"; pause' &
    LIVE_DUMMY_PID=$!
    echo $LIVE_DUMMY_PID > "/tmp/${LIVE_DUMMY_PROCESS}.pid"
    echo "live_dummy_process started with PID $LIVE_DUMMY_PID"
}

stop_processes() {
    # Stop dummy_process with 50% chance of not stopping
    if [ -f "/tmp/${DUMMY_PROCESS}.pid" ]; then
        DUMMY_PID=$(cat "/tmp/${DUMMY_PROCESS}.pid")
        if ps -p $DUMMY_PID > /dev/null 2>&1; then
            if [ $((RANDOM % 2)) -eq 0 ]; then
                kill $DUMMY_PID
                echo "$DUMMY_PROCESS stopped"
                rm "/tmp/${DUMMY_PROCESS}.pid"
            else
                echo "Failed to stop $DUMMY_PROCESS (simulated failure)"
            fi
        else
            echo "$DUMMY_PROCESS is not running"
            rm "/tmp/${DUMMY_PROCESS}.pid"
        fi
    fi
    
    # Stop live_dummy_process
    if [ -f "/tmp/${LIVE_DUMMY_PROCESS}.pid" ]; then
        LIVE_DUMMY_PID=$(cat "/tmp/${LIVE_DUMMY_PROCESS}.pid")
        if ps -p $LIVE_DUMMY_PID > /dev/null 2>&1; then
            kill $LIVE_DUMMY_PID
            echo "$LIVE_DUMMY_PROCESS stopped"
            rm "/tmp/${LIVE_DUMMY_PROCESS}.pid"
        else
            echo "$LIVE_DUMMY_PROCESS is not running"
            rm "/tmp/${LIVE_DUMMY_PROCESS}.pid"
        fi
    fi
}

case "$1" in
    start)
        start_processes &
        ;;
    stop)
        stop_processes &
        ;;
    *)
        echo "Usage: $0 {start|stop}"
        exit 1
        ;;
esac
