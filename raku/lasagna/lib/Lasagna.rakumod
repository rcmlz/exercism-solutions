unit module Lasagna;

constant $EXPECTED-MINUTES-IN-OVEN = 40;
constant $MINUTES-PER-LAYER = 2;

sub remaining-minutes-in-oven ($actual-minutes-in-oven) is export {
	$EXPECTED-MINUTES-IN-OVEN - $actual-minutes-in-oven
}

sub preparation-time-in-minutes ($number-of-layers) is export {
	$MINUTES-PER-LAYER * $number-of-layers
}

sub total-time-in-minutes ( $number-of-layers, $actual-minutes-in-oven ) is export {
	preparation-time-in-minutes($number-of-layers) + $actual-minutes-in-oven
}

sub oven-alarm () is export {
	'Ding!'
}
