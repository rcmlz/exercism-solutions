unit class GradeSchool;

has %!grades;

method add (:$student, :$grade --> Bool) {
    if $student ∉ %!grades.values.all {
        push %!grades{$grade}, $student;
        return True
    }
    return False
}

multi method roster( --> List(Seq) ) {
    flat %!grades.sort.values.map: *.value.sort || ()
}
multi method roster (UInt:D :$grade, --> List(Seq)) {
    sort %!grades{$grade} || ()
}
