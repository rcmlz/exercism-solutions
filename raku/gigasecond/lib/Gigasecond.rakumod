unit module Gigasecond;

sub giga-later (DateTime(Date) $date, --> DateTime) is export {
    DateTime.new: $date.posix + 1e9
}
