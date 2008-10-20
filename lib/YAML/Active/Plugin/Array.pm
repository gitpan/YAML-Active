package YAML::Active::Plugin::Array;

# $Id: Array.pm 9177 2005-06-14 12:33:38Z gr $

use warnings;
use strict;
use YAML::Active qw/assert_arrayref array_activate yaml_NULL/;


our $VERSION = '1.08';


use base 'YAML::Active::Plugin';


__PACKAGE__->mk_array_accessors('__array');


sub run_plugin {
    my $self = shift;
    assert_arrayref($self);
    $self->__array(array_activate($self, $self->__phase));

    yaml_NULL();
}


1;


__END__



=head1 NAME

YAML::Active::Plugin::Array - Base class for array plugins

=head1 SYNOPSIS

None.

=head1 DESCRIPTION

None yet.

=head1 METHODS

=over 4

=item __array

    my @values    = $obj->__array;
    my $array_ref = $obj->__array;
    $obj->__array(@values);
    $obj->__array($array_ref);

Get or set the array values. If called without an arguments, it returns the
array in list context, or a reference to the array in scalar context. If
called with arguments, it expands array references found therein and sets the
values.

=item __array_clear

    $obj->__array_clear;

Deletes all elements from the array.

=item __array_count

    my $count = $obj->__array_count;

Returns the number of elements in the array.

=item __array_index

    my $element   = $obj->__array_index(3);
    my @elements  = $obj->__array_index(@indices);
    my $array_ref = $obj->__array_index(@indices);

Takes a list of indices and returns the elements indicated by those indices.
If only one index is given, the corresponding array element is returned. If
several indices are given, the result is returned as an array in list context
or as an array reference in scalar context.

=item __array_pop

    my $value = $obj->__array_pop;

Pops the last element off the array, returning it.

=item __array_push

    $obj->__array_push(@values);

Pushes elements onto the end of the array.

=item __array_set

    $obj->__array_set(1 => $x, 5 => $y);

Takes a list of index/value pairs and for each pair it sets the array element
at the indicated index to the indicated value. Returns the number of elements
that have been set.

=item __array_shift

    my $value = $obj->__array_shift;

Shifts the first element off the array, returning it.

=item __array_splice

    $obj->__array_splice(2, 1, $x, $y);
    $obj->__array_splice(-1);
    $obj->__array_splice(0, -1);

Takes three arguments: An offset, a length and a list.

Removes the elements designated by the offset and the length from the array,
and replaces them with the elements of the list, if any. In list context,
returns the elements removed from the array. In scalar context, returns the
last element removed, or C<undef> if no elements are removed. The array grows
or shrinks as necessary. If the offset is negative then it starts that far
from the end of the array. If the length is omitted, removes everything from
the offset onward. If the length is negative, removes the elements from the
offset onward except for -length elements at the end of the array. If both the
offset and the length are omitted, removes everything. If the offset is past
the end of the array, it issues a warning, and splices at the end of the
array.

=item __array_unshift

    $obj->__array_unshift(@values);

Unshifts elements onto the beginning of the array.

=item clear___array

    $obj->clear___array;

Deletes all elements from the array.

=item count___array

    my $count = $obj->count___array;

Returns the number of elements in the array.

=item index___array

    my $element   = $obj->index___array(3);
    my @elements  = $obj->index___array(@indices);
    my $array_ref = $obj->index___array(@indices);

Takes a list of indices and returns the elements indicated by those indices.
If only one index is given, the corresponding array element is returned. If
several indices are given, the result is returned as an array in list context
or as an array reference in scalar context.

=item pop___array

    my $value = $obj->pop___array;

Pops the last element off the array, returning it.

=item push___array

    $obj->push___array(@values);

Pushes elements onto the end of the array.

=item set___array

    $obj->set___array(1 => $x, 5 => $y);

Takes a list of index/value pairs and for each pair it sets the array element
at the indicated index to the indicated value. Returns the number of elements
that have been set.

=item shift___array

    my $value = $obj->shift___array;

Shifts the first element off the array, returning it.

=item splice___array

    $obj->splice___array(2, 1, $x, $y);
    $obj->splice___array(-1);
    $obj->splice___array(0, -1);

Takes three arguments: An offset, a length and a list.

Removes the elements designated by the offset and the length from the array,
and replaces them with the elements of the list, if any. In list context,
returns the elements removed from the array. In scalar context, returns the
last element removed, or C<undef> if no elements are removed. The array grows
or shrinks as necessary. If the offset is negative then it starts that far
from the end of the array. If the length is omitted, removes everything from
the offset onward. If the length is negative, removes the elements from the
offset onward except for -length elements at the end of the array. If both the
offset and the length are omitted, removes everything. If the offset is past
the end of the array, it issues a warning, and splices at the end of the
array.

=item unshift___array

    $obj->unshift___array(@values);

Unshifts elements onto the beginning of the array.

=back

YAML::Active::Plugin::Array inherits from L<YAML::Active::Plugin>.

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

