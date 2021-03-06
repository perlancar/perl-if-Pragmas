package if::prog;

# DATE
# VERSION

sub work {
  my $method = shift() ? 'import' : 'unimport';
  die "Too few arguments to 'use if::prog'"
    unless @_ >= 2;

  return unless $0 =~ shift;

  my $p = $_[0];		# PACKAGE
  (my $file = "$p.pm") =~ s!::!/!g;
  require $file;		# Works even if $_[0] is a keyword (like open)
  my $m = $p->can($method);
  goto &$m if $m;
}

sub import   { shift; unshift @_, 1; goto &work }
sub unimport { shift; unshift @_, 0; goto &work }

1;
# ABSTRACT: C<use> a Perl module if program matches

=head1 SYNOPSIS

In Perl script:

 use if::prog 'foo|bar', MODULE => ARGUMENTS;

On command-line:

 perl -Mif::prog='foo,Devel::EndStats::LoadedMods' foo ...

In crontab:

 PERL5OPT='-Mif::prog=foo,Devel::EndStats::LoadedMods'

 # this Perl program will load Devel::EndStats::LoadedMods
 0 0 * * * foo some arg
 # this Perl program won't
 1 1 * * * bar other args

=head1 DESCRIPTION

 use if::prog $prog, MODULE => ARGUMENTS;

is a shortcut for:

 use if $0 =~ $prog, MODULE => ARGUMENTS;

The reason this pragma is created is to make it easier to specify on
command-line (especially using the C<-M> perl switch or in C<PERL5OPT>).
