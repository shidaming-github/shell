#!/bin/bash
for i in {1..9}
do
 for j in {1..9}
 do
  if [ $i -eq $j ];then
  echo -ne "$i*$j=$[i*j]\t"
  fi
 done
 echo
done
