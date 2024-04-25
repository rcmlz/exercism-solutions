unit module Matrix;

subset StrictlyPositiveInteger of UInt where * != 0;
subset StrOfDigits of Str where not /<:!Number -:Separator -[\R + -]>/;

sub extract-row(StrOfDigits :$string, StrictlyPositiveInteger :$index --> Seq) is export {
    $string.lines.skip($index.pred).head.words
}

sub extract-column(StrOfDigits :$string, StrictlyPositiveInteger :$index --> Seq) is export {
    $string.lines.map: *.words.skip($index.pred).head
}