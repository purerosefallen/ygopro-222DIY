@echo off

cd ygopro-server/redis

start redis-server.exe

cd ../windbot

start windbot.exe servermode=true serverport=2399
cd ..

node.exe ygopro-server.js

pause