package YAML::Active;

use 5.006001;
use strict;
use warnings;

use base 'Exporter';
use YAML ();   # no imports, we'll define our own Load() and LoadFile()

our $VERSION = '1.00';

our %EXPORT_TAGS = (
    load   => [ qw{Load LoadFile} ],
    active => [ qw{node_activate array_activate hash_activate} ],
    assert => [ qw{assert_arrayref assert_hashref} ],
    null   => [ qw{yaml_NULL NULL} ],
);
our @EXPORT_OK = @{ $EXPORT_TAGS{all} = [ map { @$_ } values %EXPORT_TAGS ] };

use constant NULL => 'YAML::Active::NULL';

sub array_activate ($) {
    [
        grep { ref ne NULL }
        map  { node_activate($_) }
        @{ $_[0] }
    ]
}


sub hash_activate ($) {
    my $node = shift;
    return {
        map {
            my $val = node_activate($node->{$_});
            ref $val eq NULL ? () : ($_ => $val)
        } keys %$node
    };
}


sub node_activate ($) {
    my $node = shift;
    return array_activate($node) if ref $node eq 'ARRAY';
    return hash_activate($node)  if ref $node eq 'HASH';
    if (my $class = ref $node) {
        if (!$node->can('yaml_activate') && index($node,'YAML::Active') != -1) {
            eval "require $class";
            die $@ if $@;
        }
        return $node->can('yaml_activate') ? $node->yaml_activate : $node;
    }
    return $node;
}


sub Load     { node_activate YAML::Load    (+shift) }
sub LoadFile { node_activate YAML::LoadFile(+shift) }


sub assert_arrayref {
    return if UNIVERSAL::isa($_[0], 'ARRAY');
    die sprintf "%s expects an array ref", (caller)[0];
}


sub assert_hashref {
    return if UNIVERSAL::isa($_[0], 'HASH');
    die sprintf "%s expects a hash ref", (caller)[0];
}


sub yaml_NULL { bless {}, NULL }


package YAML::Active::Concat;
YAML::Active->import(':all');
sub yaml_activate {
    my $self = shift;
    assert_arrayref($self);
    return join '' => @{ array_activate($self) };
}


package YAML::Active::Eval;
YAML::Active->import(':all');
sub yaml_activate {
    my $self = shift;
    assert_hashref($self);
    my $code_ref = eval node_activate($self->{code});
    return $code_ref->();
}


package YAML::Active::Include;
YAML::Active->import(':all');
sub yaml_activate {
    my $self = shift;
    assert_hashref($self);
    return LoadFile(node_activate($self->{filename}));
}


sub YAML::Active::PID::yaml_activate { $$ }


package YAML::Active::Shuffle;
YAML::Active->import(':all');
sub yaml_activate {
    my $self = shift;
    assert_arrayref($self);
    return [ sort { 1-int rand 3 } @{ array_activate($self) } ];
}


# example of a side-effect-only plugin

package YAML::Active::Print;
YAML::Active->import(':all');
sub yaml_activate {
    my $self = shift;
    assert_arrayref($self);
    my $result = array_activate($self);
    print @$result;
    return yaml_NULL();
}


package YAML::Active::ValueMutator;
YAML::Active->import(':all');

sub mutate_value { $_[1] }

sub yaml_activate {
    my $self = shift;
    if (UNIVERSAL::isa($self, 'ARRAY')) {
        return [
            map  { ref($_) ? $_ : $self->mutate_value($_) }
            @{ array_activate($self) }
        ];
    } elsif (UNIVERSAL::isa($self, 'HASH')) {
        my $h = hash_activate($self);
        $_ = $self->mutate_value($_) for grep { !ref } values %$h;
        return $h;
    }
    return $self;    # shouldn't get here
}


package YAML::Active::uc;
our @ISA = 'YAML::Active::ValueMutator';
sub mutate_value { uc $_[1] }


package YAML::Active::lc;
our @ISA = 'YAML::Active::ValueMutator';
sub mutate_value { lc $_[1] }


1;

__END__

=head1 NAME

YAML::Active - Combine data and logic in YAML

=head1 SYNOPSIS

  use YAML::Active;
  my $data = Load(<<'EOYAML');
  pid: !perl/YAML::Active::PID
    doit:
  foo: bar
  include_test: !perl/YAML::Active::Include
      filename: t/testperson.yaml
  ticket_no: !perl/YAML::Active::Concat
    - '20010101.1234'
    - !perl/YAML::Active::PID
      doit:
    - !perl/YAML::Active::Eval
      code: sub { sprintf "%04d", ++(our $cnt) }
  setup:
    1: !perl/Registry::YAML::Active::WritePerson
       person:
         personname: Foobar
         nichdl: AB123456-NICAT
    2: !perl/Registry::YAML::Active::WritePerson
       person: !perl/YAML::Active::Include
         filename: t/testperson.yaml
  EOYAML

=head1 DESCRIPTION

YAML is an intuitive way to describe nested data structures. This
module extends YAML's capabilities so that it ceases to be a static
data structure and become something more active, with data and logic
combined. This makes the logic reusable since it is bound to the data
structure. Without C<YAML::Active>, you have to load the YAML data,
then process it in some way. The logic describing which parts of the
data have to be processed and how was separated from the data. Using
C<YAML::Active>, the description of how to process the data can be
encapsulated in the data structure itself.

The way this works is to assign a transfer type to the YAML nodes you
want to process. The transfer type refers to a Perl package which is
expected to have a C<yaml_active()> method which contains the
logic; you can think of the array or hash structure below that node as
the subroutine's arguments.

C<YAML::Active> provides its own C<Load()> and C<LoadFile()>
subroutines which work like the subroutines of the same name in
C<YAML>, except that they also traverse the whole data structure,
recognizing packages named as transfer types that have a
C<yaml_active()> method and calling that method on the given node.

An example:

  some_string: !perl/YAML::Active::Concat
    - foo
    - bar
    - baz

defines a hash key whose value is an active YAML element. When you call
C<YAML::Active>'s C<Load()> on that data, at some point the hash value
is being encountered. The C<YAML::Active::Concat> plugin (as a
convenience also defined in the same file as C<YAML::Active>) has a
C<yaml_active()> method which expects to be called on an array
reference (that is, the thing blessed into C<YAML::Active::Concat> is
expected to be an array reference). The method in turn activates all of
the array's elements and joins the results. So after loading the data
structure, the result is equivalent to

  some_string: foobarbaz

Because C<YAML::Active::Concat> also activates all of its arguments,
you can nest activation logic:

  some_string !perl/YAML::Active::Concat
    - foo
    - !perl/YAML::Active::PID
      doit:
    - !perl/YAML::Active::Eval
      code: sub { sprintf "%04d", ++(our $cnt) }

This active YAML uses two more plugins, C<YAML::Active::PID> and
C<YAML::Active::Eval>. C<YAML::Active::PID> replaces its node with the
current process's id. Note that even though this plugin doesn't need
any arguments, we have to provide something - anything, in fact,
whether it be an array reference or a hash reference, because YAML can
bless only references. C<YAML::Active::Eval> expects a hash reference
with a C<code> key whose value is the source code for an anonymous sub
which the plugin calls and whose return value it uses to replace the
activated node.

An activation plugin (that is, a package referred to by a node's
transfer type) can have any name, but if that name contains the string
C<YAML::Active>, it is being C<required()> if it doesn't already
provide a C<yaml_active()> method. This is merely a convenience so you
don't have to C<use()> or C<require()> the packages beforehand and
things work a bit more transparently. If you merely want to bless a
node (that is, provide a transfer type) into a package that's not an
activation plugin, be sure that the package name doesn't contain the
string C<YAML::Active>.

=head2 EXPORT

Nothing is exported by default, but you can request each of the
following subroutines individually or grouped by tags. The tags and
their symbols are, in YAML notation:

  load:
    - Load
    - LoadFile
  active:
    - node_activate
    - array_activate
    - hash_activate
  assert:
    - assert_arrayref
    - assert_hashref
  null:
    - yaml_NULL
    - NULL

There is also the C<all> tag, which contains all of the above symbols.

=over 4

=item C<Load()>

Like C<YAML>'s C<Load()>, but activates the data structure after
loading it and returns the activated data structure.

=item C<LoadFile()>

Like C<YAML>'s C<LoadFile()>, but activates the data structure after
loading it and returns the activated data structure.

=item C<node_activate()>

Expects a reference and recursively activates it, returning the
resulting reference.

If it encounters an array, it calls C<array_activate()> on the node and
returns the result.

If it encounters a hash, it calls C<hash_activate()> on the node and
returns the result.

If it encounters a node that can be activated (i.e., that is blessed
into a package that has a C<yaml_activate()> method, it activates the
node and returns the result. If the package name contains the string
C<YAML::Active> and it doesn't have a C<yaml_activate()> method,
C<node_activate()> tries to C<require()> the package (as a
convenience). That is, if you want to write a plugin, you can either
include the string C<YAML::Active> somewhere in its package name, or
use any other name but then you'd have to C<use()> or C<require()> it
before activating some YAML.

Otherwise it just returns the node as it could be an unblessed scalar
or a reference blessed into a package that's got nothing to do with
activation.

=item C<array_activate()>

Takes an array reference and activates every array element in turn,
then returns a new array references containing the results. Null
elements (that is, elements blessed into C<YAML::Active::NULL>) are
ignored.

=item C<hash_activate()>

Takes a hash reference and activates every value, then returns a new
hash references containing the results (the hash keys are left alone).
Keys with null values (that is, values blessed into
C<YAML::Active::NULL>) are ignored.

=item C<assert_arrayref()>

Checks that its argument is an array reference. If not, C<die()>s
reporting the caller.

=item C<assert_hashref()>

Checks that its argument is a hash reference. If not, C<die()>s
reporting the caller.

=item C<yaml_NULL()>

Returns an empty hash reference blessed into the C<YAML::Active::NULL>
package. This function is used by side-effect-only plugins that don't
want to have a trace of their existence left in the activated data
structure. For an example see the C<YAML::Active::Print>.

=item C<NULL()>

This is a constant with the value C<YAML::Active::NULL>.

=back

=head1 DEFAULT PLUGINS

=over 4

=item C<YAML::Active::Concat>

Expects an array reference and joins the activated array elements,
returning the joined string.

For an example, see the L<DESCRIPTION> above.

=item C<YAML::Active::Eval>

Expects a hash reference with a C<code> key. C<eval>s the activated
hash value returns the result from executing the coderef (passing no
arguments).

Example:

  - !perl/YAML::Active::Eval
    code: sub { sprintf "%04d", ++(our $cnt) }

Result:

  - 1

At least, that's the answer the first time around.

=item C<YAML::Active::Include>

Expects a hash reference with a C<filename> key. Calls
C<YAML::Active>'s C<LoadFile()> on the activated filename. That is,
the filename can itself use an activation plugin, and the file contents
are activated as well.

Example:

  description: !perl/YAML::Active::Include
    filename: description.yaml

Result:

  description: >
    The content of the included file goes here.

=item C<YAML::Active::PID>

Returns the current process id.

Example:

  the_pid: !perl/YAML::Active::PID
    whatever:

Result (for example):

  the_pid: 12345

Note that, although this plugin doesn't require any arguments, we have
to give it either an array reference or a hash reference, because
C<YAML> can't bless something that's not a reference. The contents of
the reference don't matter.

=item C<YAML::Active::Shuffle>

Expects an array reference and returns another array reference with the
activated original elements in random order.

Example:

  data: !perl/YAML::Active::Shuffle
        - 1
        - 2
        - 3
        - 4
        - 5

Result (for example):

  data:
    - 3
    - 5
    - 1
    - 2
    - 4

=item C<YAML::Active::Print>

Expects an array reference and joins the activated array elements,
printing the result and returning a null (i.e., a
C<YAML::Active::NULL>) node. That is, the node won't appear in the
resulting activated data structure.

Example:

  data:
    - foo
    - !perl/YAML::Active::Print
       - '# Hello, world!'
       - 'Goodbye, world!'
    - baz

Result:

  data:
    - foo
    - baz

and the string C<# Hello, world!Goodbye, world!> is printed.

=item C<YAML::Active::uc>

Replaces node values (scalars, array elements and hash values) with
their lowercased value. Does not descend into deeper array references
or hash references, but passes them through unaltered.

Example:

  data: !perl/YAML::Active::uc
    - Hello
    - world and
    - one: GOoD
      two: byE
    - wOrLd!

Result:

  data:
    - HELLO
    - WORLD AND
    - one: GOoD
      two: byE
    - WORLD!

=item C<YAML::Active::lc>

Like C<YAML::Active::uc>, but lowercases the values.

=back

=head1 WRITING YOUR OWN PLUGIN

Suppose you want to write an activation plugin that takes a reference
to an array of numbers and adds them.

By including the string C<YAML::Active> in the package name we can let
C<YAML::Active> load the package when necessary. All we need to do is
to provide a C<yaml_activate()> method that does the work.

  package My::YAML::Active::Add;
  
  use YAML::Active qw/array_activate assert_arrayref/;
  
  sub yaml_activate {
      my $self = shift;
      assert_arrayref($self);
      my $result;
      $result += $_ for @{ array_activate($self) };
      return $result;
  }

Now you can do:

  result: !perl/My::YAML::Active::Add
    - 1
    - 2
    - 3
    - 7
    - 15

And the result would be:

  result: 28

This could be the beginning of a YAML-based stack machine or at least
an RPN calculator...

=head1 BUGS

If you find any bugs or oddities, please do inform the author.

=head1 INSTALLATION

See perlmodinstall for information and options on installing Perl modules.

=head1 AVAILABILITY

The latest version of this module is available from the Comprehensive Perl
Archive Network (CPAN). Visit <http://www.perl.com/CPAN/> to find a CPAN
site near you. Or see <http://www.perl.com/CPAN/authors/id/M/MA/MARCEL/>.

=head1 VERSION

This document describes version 1.00 of C<YAML::Active>.

=head1 AUTHOR

Marcel GrE<uuml>nauer <marcel@cpan.org>

=head1 COPYRIGHT

Copyright 2001-2003 Marcel GrE<uuml>nauer. All rights reserved.

This library is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

