set ns [new Simulator]
set nr [open out.tr w]
$ns trace-all $nr
set nf [open out.nam w]
$ns namtrace-all $nf


for { set i 0 } { $i < 12} { incr i 1 } {
set n($i) [$ns node]}
$n(0) color Orange
$n(5) color Blue
$n(1) color Red

for {set i 0} {$i < 8} {incr i} {
$ns duplex-link $n($i) $n([expr $i+1]) 3Mb 10ms DropTail }
$ns duplex-link $n(0) $n(8) 3Mb 10ms DropTail
$ns duplex-link $n(1) $n(10) 3Mb 10ms DropTail
$ns duplex-link $n(0) $n(9) 3Mb 10ms DropTail
$ns duplex-link $n(9) $n(11) 3Mb 10ms DropTail
$ns duplex-link $n(10) $n(11) 3Mb 10ms DropTail
$ns duplex-link $n(11) $n(5) 3Mb 10ms DropTail

set udp0 [new Agent/UDP]
$ns attach-agent $n(0) $udp0

set cbr0 [new Application/Traffic/CBR]
$cbr0 set packetSize_ 500
$cbr0 set  interval_ 0.05
$cbr0 attach-agent $udp0

set null0 [new Agent/Null]
$ns attach-agent $n(5) $null0
$ns connect $udp0 $null0

set udp1 [new Agent/UDP]
$ns attach-agent $n(1) $udp1

set cbr1 [new Application/Traffic/CBR]
$cbr1 set packetSize_ 500
$cbr1 set  interval_ 0.05
$cbr1 attach-agent $udp1

set null0 [new Agent/Null]
$ns attach-agent $n(5) $null0
$ns connect $udp1 $null0

$ns rtproto DV 


$ns rtmodel-at 2.5 down $n(11) $n(5)
$ns rtmodel-at 5 down $n(6) $n(5)
$ns rtmodel-at 5 down $n(6) $n(5)
$ns rtmodel-at 5 down $n(0) $n(1)


$ns color 1 Red
$ns color 2 Green

proc finish { } {
	global ns nr nf
	$ns flush-trace
	close $nf
	close $nr
	exec nam out.nam &
	exit 0
	}

$ns at 1.0 "$cbr0 start"
$ns at 2.0 "$cbr1 start"
$ns at 22.0 "$cbr1 stop"
$ns at 21.0 "$cbr0 stop"

$ns at 25.0 "finish"
$ns run



