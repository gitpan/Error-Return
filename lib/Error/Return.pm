package Error::Return;

use strict;
use warnings;
use Scope::Upper qw(unwind want_at :words);

our $VERSION = '0.01';

use base 'Exporter';

our @EXPORT = qw(RETURN);

sub RETURN {
    my $context = SUB UP SUB UP SUB UP SUB;

    # Do the cleanup that try() would normally do if the try-block had ended
    # without an exception>
    shift @Error::STACK;

    unwind +(want_at($context) ? @_ : $_[0]) => $context;
}

1;

__END__

=head1 NAME

Error::Return - return(), skipping a scope

=head1 SYNOPSIS

    use Error ':try';
    use Error::Return;

    sub doit {
        print " in doit, before try\n";
        try {
            print "  in try: start\n";
            RETURN 456;
            print "  in try: end\n";
        } catch Error with {
            my $E = shift;
            print "  caught error [$E]\n";
        };
        print " in doit, after try\n";
    }

    print "before doit\n";
    my $x = doit();
    print "doit() returned [$x]\n";
    print "after doit\n";

prints

    before doit
     in doit, before try
      in try: start
    doit() returned [456]
    after doit

=head1 DESCRIPTION

The L<Error> module provides C<try()>, which takes a coderef using the C<&>
prototype so it looks more like a normal Perl block or like C<map()> or
C<grep()>. But the "block" is still just an anonymous subroutine, so using
C<return> within the sub won't do what you think it will do. For example:

    sub doit {
        print " in doit, before try\n";
        try {
            print "  in try: start\n";
            return 456;
            print "  in try: end\n";
        } catch Error with {
            my $E = shift;
            print "  caught error [$E]\n";
        };
        print " in doit, after try\n";
    }

    print "before doit\n";
    my $x = doit();
    print "doit() returned [$x]\n";
    print "after doit\n";

The C<return> in the C<try> block (we call it a block, but it really isn't)
looks like it should return from C<doit()>, but it doesn't - it just returns
from the anonymous sub that was passed to C<try()>. Therefore, this program
prints the following:

    before doit
     in doit, before try
      in try: start
     in doit, after try
    doit() returned [1]
    after doit

So C<in doit, after try> is still reached, and C<doit()> returns C<1> because
of its last C<print> statement.

While that is the correct behaviour, it is unintuitive. This module provides a
more powerful way of returning.

=head1 METHODS

=over 4

=item C<RETURN>

Like C<return> except that it doesn't just return to its upper scope but
smashes right through it to the next-higher scope. Actually, it skips two
scopes, because it has to return from the C<try()> subroutine as well. It does
take care of the cleanup that C<try()> would normally perform.

See the Synopsis as an example - this way, the C<try> block will "do what you
mean".

=back

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests through the web interface at
L<http://rt.cpan.org>.

=head1 INSTALLATION

See perlmodinstall for information and options on installing Perl modules.

=head1 AVAILABILITY

The latest version of this module is available from the Comprehensive Perl
Archive Network (CPAN). Visit L<http://www.perl.com/CPAN/> to find a CPAN
site near you. Or see L<http://www.perl.com/CPAN/authors/id/M/MA/MARCEL/>.

The development version lives at L<http://github.com/hanekomu//>.
Instead of sending patches, please fork this project using the standard git
and github infrastructure.

=head1 AUTHORS

Marcel GrE<uuml>nauer, C<< <marcel@cpan.org> >>

=head1 COPYRIGHT AND LICENSE

Copyright 2009 by Marcel GrE<uuml>nauer

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

