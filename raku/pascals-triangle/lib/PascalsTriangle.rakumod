proto pascals-triangle ( UInt $rows --> Seq ) is export {*}
multi pascals-triangle ( 0 ) { () }
multi pascals-triangle ( 1 ) { ((1,),) }
multi pascals-triangle ( $rows ) {
    my $row = (1,);
    gather {
        take $row;
        take $row = (|$row, 0) »+« (0, |$row) for 2..$rows
    }
}