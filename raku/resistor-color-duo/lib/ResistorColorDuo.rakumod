unit module ResistorColorDuo;

constant all-colors = <black brown red orange yellow green blue violet grey white>;

sub decoded-value ( *@colors --> UInt(Str) ) is export {
    @colors.head(2).map({all-colors.first($_, :k)}).join
}
