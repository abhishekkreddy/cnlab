
#Ethernet LAN using N nodes set multiple traffic nodes and determine collission accross different nodes
set ns [new Simulator]
set trf [open prog3.tr w]
$ns trace-all $trf
set naf [open prog3.nam w]
$ns namtrace-all $naf
set n0 [$ns node]
$n0 color 'red'
$n0 label 'source1'

set n1 [$ns node]
$n1 color 'blue'
$n1 label 'Source2'

set n2 [$ns node]
$n2 color 'magneta'
$n2 label 'Destination1'

set n3 [$ns node]
$n3 color 'green'
$n3 label 'Destinaiton2'

set lan [$ns newLan "$n0 $n1 $n2 $n3" 5Mb 10ms LL Queue/DropTail Mac/802_3]

set tcp [new Agent/TCP]
$ns attach-agent $n0 $tcp
set ftp [new Application/FTP]
$ftp attach-agent $tcp
set sink [new Agent/TCPSink]
$ns attach-agent $n2 $sink
$ns connect $tcp $sink
set udp [new Agent/UDP]
$ns attach-agent $n1 $udp
set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp
set null [new Agent/Null]
$ns attach-agent $n3 $null
$ns connect $udp $null

proc finish {} {
global ns naf trf
$ns flush-trace
exec nam prog3.nam &
close $trf
close $naf
exec echo "The number of packets dropped due to collision are :" &
exec grep -c "^d" prog3.tr &
exit 0
}

$ns at 0.1 "$cbr start"
$ns at 2.0 "$ftp start"
$ns at 1.9 "$cbr stop"
$ns at 4.3 "$ftp stop"
$ns at 6.0 "finish"
$ns run


