#!/bin/bash
sleep 60
docker restart $(docker ps -q) 1>/dev/null 2>&1