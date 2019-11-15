#!/bin/bash
#输出不通颜色的矩阵
for i in {1..4}
do
  for i in {1..8}
  do
   echo -ne "\033[4${i}m  \033[0m"
  done
  echo
  for i in {8..1}
  do
    echo -ne "\033[4${i}m  \033[0m"
  done
  echo
done
