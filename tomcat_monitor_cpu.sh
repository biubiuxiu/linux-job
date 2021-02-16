#!/bin/bash
# while loop

CpuMemStat=""
datemk=""
TomcatID=$(ps -ef |grep tomcat |grep -w 'apache-tomcat-9.0.41'|grep -v 'grep'|awk '{print $2}')
#创建存放dump的目录
mkdir /home/$TomcatID
#dump 方法栈信息
jstack $TomcatID > /home/$TomcatID/jstack.txt
#dump jvm内存使用情况
jmap -heap $TomcatID > /home/$TomcatID/jmapheap.txt
#dump jvm二进制的内存详细使用情况
jmap -dump:format=b,file=/home/$TomcatID/jmapdump.txt $TomcatID
while true
do
CpuMemStat=`ps -p $TomcatID -o pcpu |grep -v CPU | awk '{print $1}' | awk -F. '{print $1}'`
MemStat=`ps aux | grep $TomcatID | grep -v 'grep' | grep -v 'watch_mem.sh' | awk '{print $3;}'`
datemk=`date "+%Y-%m-%d %H:%M:%S"`
Jmap=`jmap -heap $TomcatID`
Jstack=`jstack $TomcatID`
Jstat=`jstat -gc $TomcatID`
if (($CpuMemStat >= 90)); then  
for SWAP in `grep Swap $TomcatID/smaps 2>/dev/null| awk '{ print $2 }'`
do
let SUM=$SUM+$SWAP
done
      echo $datemk TOMCAT CPU: $CpuMemStat >> JVMStatus.log 
      echo $datemk TOMCAT MEM: $MemStat >> JVMStatus.log 
      echo $datemk "TOMCAT SWAP: $SUM" >> JVMStatus.log
      echo $datemk TOMCAT JVM的堆内存: $Jmap >> JVMStatus.log
      echo $datemk TOMCAT JVMGC: $Jstat >> JVMStatus.log
      echo $datemk TOMCAT JVM的线程堆栈: $Jstack >> JVMStatus.log
fi 
#echo $datemk $CpuMemStat
sleep 5s
done 
