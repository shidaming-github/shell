#!/bin/bash
#打印国际象棋棋盘
for i in {1..8}
do
  for j in {1..8}
  do
  a=$[i+j]
    if [ $[a%2] -eq 0 ];then
      echo -ne "\033[46m  \033[0m"
    else
      echo -ne "\033[47m  \033[0m"
    fi
   done
   echo
done

