unit module ResistorColorTrio;

constant all-colors = <black brown red orange yellow green blue violet grey white>;
constant si-units = {
    1 => '',
    1e3 => 'kilo',
    1e6 => 'mega',
    1e9 => 'giga',
}

sub format-result-and-si-unit(UInt $result) {
    si-units.sort.reverse.map({ return $result div .key.UInt, .value
                                if $result %% .key })
            if $result > 0;
    return $result, ''
}

sub create-label ( *@colors --> Str ) is export {
    my $value = @colors.head(2).map({all-colors.first($_, :k)}).join;
    my $multiplicator = exp(all-colors.first(@colors[2], :k) || 0, 10);
    my ($result, $si-unit) = format-result-and-si-unit($value * $multiplicator);
    "%d %sohms".sprintf($result, $si-unit)
}
