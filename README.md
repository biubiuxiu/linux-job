# linux-job
（1）监控tomcat进程，当tomcat进程不存在时，重启tomcat进程

     解：tomcat_monitor.sh
     
（2）当tomcat的cpu使用率大于90%时，持续记录log直至tomcat进程崩溃或者cpu使用率低于90%

     1.日志中包含时间，每隔5s记录一次tomcat的cpu、内存、swap使用量，jvm的堆内存信息，jvm的线程堆栈信息至 JVMStatus.log（jstat，jstack）
      
     2.记录jvm的堆dump信息并输出到heap.bin（仅执行一次）

     解：tomcat_monitor_cpu.sh
