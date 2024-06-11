unit module ResistorColor;

constant all-colors = <black brown red orange yellow green blue violet grey white>;

sub all-colors( --> all-colors ) is export { }

sub color-code ( $color --> UInt ) is export {
    all-colors.first($color, :k)
}
