exec echo "Three Node Point to Point NW with duplex links and vary queue size and find no of packets dropped"

set ns [new Simulator]
set ntrace [open prog1.tr w]
$ns trace-all $ntrace
set namfile [open prog1.nam w]
$ns namtrace-all $namfile
proc Finish {} {
global ns ntrace namfile

$ns flush-trace
close $ntrace
close $namfile

exec nam prog1.nam &
exec echo "The number of packets dropped are:" &
exec grep -c "^d" prog1.tr &
exit 0
}
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]

$ns duplex-link $n0 $n1 0.2Mb 10ms DropTail
$ns duplex-link $n1 $n2 1Mb 10ms DropTail

$ns queue-limit $n0 $n1 10
$ns queue-limit $n1 $n2 10

set udp [new Agent/UDP]
$ns attach-agent $n0 $udp
set null [new Agent/Null]
$ns attach-agent $n2 $null
$ns connect $udp $null

set cbr0 [new Application/Traffic/CBR]
$cbr0 attach-agent $udp

$ns at 0.0 "$cbr0 start"
$ns at 5.0 "Finish"

$ns run
