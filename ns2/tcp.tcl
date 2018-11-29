set ns [new Simulator]
set nr [open outcp.tr w]
$ns trace-all $nr
set nf [open outcp.nam w]
$ns namtrace-all $nf

for { set i 0 } { $i < 12} { incr i 1 } {
set n($i) [$ns node]}

for {set i 0} {$i < 8} {incr i} {
$ns duplex-link $n($i) $n([expr $i+1]) 3Mb 10ms DropTail }
$ns duplex-link $n(0) $n(8) 3Mb 10ms DropTail
$ns duplex-link $n(1) $n(10) 3Mb 10ms DropTail
$ns duplex-link $n(0) $n(9) 3Mb 10ms DropTail
$ns duplex-link $n(9) $n(11) 3Mb 10ms DropTail
$ns duplex-link $n(10) $n(11) 3Mb 10ms DropTail
$ns duplex-link $n(11) $n(5) 3Mb 10ms DropTail

set tcp0 [new Agent/TCP]
$ns attach-agent $n(0) $tcp0
set sink0 [new Agent/TCPSink]
$ns attach-agent $n(5) $sink0
set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0


set tcp1 [new Agent/TCP]
$ns attach-agent $n(1) $tcp1
set sink1 [new Agent/TCPSink]
$ns attach-agent $n(5) $sink1
set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1

$ns connect $tcp0 $sink0
$ns connect $tcp1 $sink1

$ns rtproto DV 

$ns rtmodel-at 2.5 down $n(11) $n(5)
$ns rtmodel-at 5 down $n(6) $n(5)
$ns rtmodel-at 5 down $n(0) $n(1)


$ns color 1 Red
$ns color 2 Green

proc finish { } {
	global ns nf nr
	$ns flush-trace
	close $nf
	close $nr
	exec nam out.nam &
	exit 0
	}

$ns at 1.0 "$ftp0 start"
$ns at 2.0 "$ftp1 start"
$ns at 22.0 "$ftp1 stop"
$ns at 21.0 "$ftp0 stop"

$ns at 25.0 "finish"
$ns run



