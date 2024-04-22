unit module Meetup:ver<1>:auth<exercism:rcmlz>:api<1>;
#use Grammar::Debugger;

enum Day-of-week « :Monday(1) Tuesday Wednesday Thursday Friday Saturday Sunday »;
enum Month       « :January(1) February March April May June July August September October November December »;
enum Position    « :First(1) Second Third Fourth »;
enum Description « Last Teenth »;

grammar MeetUp {
    token TOP              { ^^ <weekday-of-month> <ws> <day-of-week> <ws> of <ws> <month> <ws> <year> $$ }
    token weekday-of-month { <position> | <description> }
    token day-of-week      { @( Day-of-week.keys ) }
    token month            { @( Month.keys ) }
    token year             { <digit> ** 4 }
    token position         { @( Position.keys ) }
    token description      { @( Description.keys ) }
}

class PreProcessor {
    method TOP ($match) {
        $match.make: { weekday-of-month => $match<weekday-of-month><position>.made || $match<weekday-of-month><description>,
                       day-of-week      => Day-of-week::{$match<day-of-week>}.value.UInt,
                       month            => Month::{$match<month>}.value.UInt,
                       year             => $match<year>.UInt
        };
    }
    method position($/) {
        make Position::{$/}.value.UInt
    }
}

sub meetup-date ($desc --> Date) is export {
    my %match = MeetUp.parse($desc, actions => PreProcessor.new).made;
    my $first-of-month = Date.new(%match<year>, %match<month>, 1);

    my \potential-dates = lazy grep { .day-of-week == %match<day-of-week> }, $first-of-month..$first-of-month.last-date-in-month;

    given %match<weekday-of-month> {
        when UInt     { potential-dates.first: *.weekday-of-month == %match<weekday-of-month> }
        when 'Last'   { potential-dates.eager.tail }
        when 'Teenth' { potential-dates.first: 12 < *.day }
        default       { fail 'unkown weekday-of-month:' ~ %match<weekday-of-month> }
    }
}