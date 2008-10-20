package YAML::Active::Plugin::Hash;

# $Id: Hash.pm 9177 2005-06-14 12:33:38Z gr $

use warnings;
use strict;
use YAML::Active qw/assert_hashref hash_activate yaml_NULL/;


our $VERSION = '1.08';


use base 'YAML::Active::Plugin';


# Differentiate between normal plugin args, args prefixed with a single
# underscore, and args prefixed with a double underscore. Double underscore
# args are for the YAML::Active mechanism itself - things like '__phase'.
# Single underscore args can be used by specific plugins as they wish.

# We need to prefix all members with __ so they're not confused with the
# actual args used in the YAML.

__PACKAGE__->mk_hash_accessors(qw(__hash));


sub run_plugin {
    my $self = shift;
    assert_hashref($self);
    $self->__hash(
        hash_activate(scalar($self->get_args($self)), $self->__phase)
    );
    yaml_NULL();
}


sub get_args {
    my ($self, $hash) = @_;

    # Get the actual args used in the YAML file; don't just copy %self,
    # because we don't want the properties of this object to be confused with
    # the YAML data, which would lead to endless recursion

    my %args;
    while (my ($key, $value) = each %$hash) {
        next if substr($key, 0, 2) eq '__';
        $args{$key} = $value;
    }

    wantarray ? %args : \%args;
}


1;


__END__



=head1 NAME

YAML::Active::Plugin::Hash - Base class for hash plugins

=head1 SYNOPSIS

None.

=head1 DESCRIPTION

None yet.

=head1 METHODS

=over 4

=item __hash

    my %hash     = $obj->__hash;
    my $hash_ref = $obj->__hash;
    my $value    = $obj->__hash($key);
    my @values   = $obj->__hash([ qw(foo bar) ]);
    $obj->__hash(%other_hash);
    $obj->__hash(foo => 23, bar => 42);

Get or set the hash values. If called without arguments, it returns the hash
in list context, or a reference to the hash in scalar context. If called
with a list of key/value pairs, it sets each key to its corresponding value,
then returns the hash as described before.

If called with exactly one key, it returns the corresponding value.

If called with exactly one array reference, it returns an array whose elements
are the values corresponding to the keys in the argument array, in the same
order. The resulting list is returned as an array in list context, or a
reference to the array in scalar context.

If called with exactly one hash reference, it updates the hash with the given
key/value pairs, then returns the hash in list context, or a reference to the
hash in scalar context.

=item __hash_clear

    $obj->__hash_clear;

Deletes all keys and values from the hash.

=item __hash_delete

    $obj->__hash_delete(@keys);

Takes a list of keys and deletes those keys from the hash.

=item __hash_exists

    if ($obj->__hash_exists($key)) { ... }

Takes a key and returns a true value if the key exists in the hash, and a
false value otherwise.

=item __hash_keys

    my @keys = $obj->__hash_keys;

Returns a list of all hash keys in no particular order.

=item __hash_values

    my @values = $obj->__hash_values;

Returns a list of all hash values in no particular order.

=item clear___hash

    $obj->clear___hash;

Deletes all keys and values from the hash.

=item delete___hash

    $obj->delete___hash(@keys);

Takes a list of keys and deletes those keys from the hash.

=item exists___hash

    if ($obj->exists___hash($key)) { ... }

Takes a key and returns a true value if the key exists in the hash, and a
false value otherwise.

=item keys___hash

    my @keys = $obj->keys___hash;

Returns a list of all hash keys in no particular order.

=item values___hash

    my @values = $obj->values___hash;

Returns a list of all hash values in no particular order.

=back

YAML::Active::Plugin::Hash inherits from L<YAML::Active::Plugin>.

The superclass L<YAML::Active::Plugin> defines these methods and functions:

    yaml_activate()

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

