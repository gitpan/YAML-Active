package YAML::Active::Plugin;

# $Id: Plugin.pm 9177 2005-06-14 12:33:38Z gr $

use warnings;
use strict;
use YAML::Active 'yaml_NULL';


our $VERSION = '1.08';


use base 'Class::Accessor::Complex';


__PACKAGE__->mk_accessors(qw(__phase));


sub yaml_activate {
    my ($self, $phase) = @_;
    $self->__phase($phase);
    $self->run_plugin;
}


sub run_plugin {
    my $self = shift;
    yaml_NULL();
}


1;


__END__



=head1 NAME

YAML::Active::Plugin - Base class for plugins

=head1 SYNOPSIS

None.

=head1 DESCRIPTION

None yet.

=head1 METHODS

=over 4



=back

YAML::Active::Plugin inherits from L<Class::Accessor::Complex>.

The superclass L<Class::Accessor::Complex> defines these methods and
functions:

    mk_abstract_accessors(), mk_array_accessors(), mk_boolean_accessors(),
    mk_class_array_accessors(), mk_class_hash_accessors(),
    mk_class_scalar_accessors(), mk_concat_accessors(),
    mk_forward_accessors(), mk_hash_accessors(), mk_integer_accessors(),
    mk_new(), mk_object_accessors(), mk_scalar_accessors(),
    mk_set_accessors(), mk_singleton()

The superclass L<Class::Accessor> defines these methods and functions:

    new(), _carp(), _croak(), _mk_accessors(), accessor_name_for(),
    best_practice_accessor_name_for(), best_practice_mutator_name_for(),
    follow_best_practice(), get(), make_accessor(), make_ro_accessor(),
    make_wo_accessor(), mk_accessors(), mk_ro_accessors(),
    mk_wo_accessors(), mutator_name_for(), set()

The superclass L<Class::Accessor::Installer> defines these methods and
functions:

    install_accessor()

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests through the web interface at
L<http://rt.cpan.org>.

=head1 INSTALLATION

See perlmodinstall for information and options on installing Perl modules.

=head1 AVAILABILITY

The latest version of this module is available from the Comprehensive Perl
Archive Network (CPAN). Visit <http://www.perl.com/CPAN/> to find a CPAN
site near you. Or see <http://www.perl.com/CPAN/authors/id/M/MA/MARCEL/>.

=head1 AUTHORS

Marcel GrE<uuml>nauer, C<< <marcel@cpan.org> >>

=head1 COPYRIGHT AND LICENSE

Copyright 2003-2008 by the authors.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.


=cut

