package My::YAML::Active::Add;

use YAML::Active qw/array_activate assert_arrayref/;

sub yaml_activate {
    my ($self, $phase) = @_;
    assert_arrayref($self);
    my $result;
    $result += $_ for @{ array_activate($self, $phase) };
    return $result;
}

1;
