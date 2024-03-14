unit class Robot;

my constant ALL-NAMES = set eager 'A00' .. 'Z99'; # pre-calculate for speeeeeeed!

has Str $.name;
my SetHash $names;

submethod TWEAK {
    once { $names = ALL-NAMES.SetHash }
    self.reset-name
}

method reset-name {
    die 'All names used.' if not $names;
    $!name = $names.grab;
}