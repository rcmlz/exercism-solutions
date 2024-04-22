unit module SpaceAge;

constant $secs-per-year-on-earth = 31557600;
constant %secs-per-year-on-earth-on =
    <Mercury Venus Earth Mars Jupiter Saturn Uranus Neptune>
      Z=>
    (0.2408467, 0.61519726, 1, 1.8808158, 11.862615, 29.447498, 84.016846, 164.79132)
      »×»
    $secs-per-year-on-earth;

sub age-on ( :$planet, :$seconds ) is export {
    fail 'not a planet' without %secs-per-year-on-earth-on{$planet};
    round $seconds ÷ %secs-per-year-on-earth-on{$planet}, 0.01
}
