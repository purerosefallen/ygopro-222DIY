@echo off
cd ygopro-server
start redis-server.exe
cd windbot
start windbot.exe 2399
cd ..
node.exe ygopro-server.js
