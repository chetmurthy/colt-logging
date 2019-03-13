#!/usr/bin/perl -w

use strict ;

{
  my $f = shift @ARGV ;
  die "file $f must already exist and be writable" unless (-W $f) ;
  die "environment variable OCAMLFIND_DESTDIR must be set" unless (exists $ENV{'OCAMLFIND_DESTDIR'}) ;
  my $destdir = $ENV{'OCAMLFIND_DESTDIR'} ;
  my @l = f_read($f) ;
  for (my $i = 0 ; $i < int(@l) ; $i++) {
    if ($l[$i] =~ /^path=\"(.*)\"$/) {
      $l[$i] = "path=\"$destdir:$1\"\n" ;
    }
    elsif ($l[$i] =~ /^destdir=/) {
      $l[$i] = "destdir=\"$destdir\"\n" ;
    }
  }
  f_write($f, @l) ;
}

sub f_write {
  my $f = shift;
  open(F,">$f") || die "cannot open $f for writing";
  print F @_;
  close(F);
}

sub f_read {
  my $f = shift;
  open(F,"<$f") || die "cannot open $f for reading";
  my @l = <F> ;
  close(F);
  if (wantarray) { return @l ; }
  else { return join('', @l) ; }
}
