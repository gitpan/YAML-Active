package My::YAML::Active::WritePerson;

use 5.006001;
use strict;
use warnings;

use YAML::Active ':all';

our $VERSION = '0.01';

sub yaml_activate {
    my $self = shift;
    UNIVERSAL::isa($self, 'HASH') && exists $self->{person} or
        die 'YAML::Active::Eval expects a hash ref like { person => {...} }';
    $main::result .= "Writing person:\n";
    my $person = node_activate($self->{person});
    $main::result .= " $_ => $person->{$_}\n" for sort keys %$person;
    return 1;   # rc: OK
}


1;

__END__

=head1 NAME

YAML::Active - Perl extension for blah blah blah

=head1 SYNOPSIS

  use YAML::Active;
  blah blah blah

=head1 ABSTRACT

  This should be the abstract for YAML::Active.
  The abstract is used when making PPD (Perl Package Description) files.
  If you don't want an ABSTRACT you should also edit Makefile.PL to
  remove the ABSTRACT_FROM option.

=head1 DESCRIPTION

Stub documentation for YAML::Active, created by h2xs. It looks like the
author of the extension was negligent enough to leave the stub
unedited.

Blah blah blah.

=head2 EXPORT

None by default.



=head1 SEE ALSO

Mention other useful documentation such as the documentation of
related modules or operating system documentation (such as man pages
in UNIX), or any relevant external documentation such as RFCs or
standards.

If you have a mailing list set up for your module, mention it here.

If you have a web site set up for your module, mention it here.

=head1 AUTHOR

marcel gruenauer, E<lt>gr@cc.univie.ac.atE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2003 by marcel gruenauer

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself. 

=cut
