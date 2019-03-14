#!/usr/bin/perl

BEGIN {
  push(@INC, "/home/chet/Hack/Ocaml-Hacking/src/Parse-CommandLine-0.02/lib") ;
}

use strict ;
use IPC::System::Simple qw(system systemx capture capturex);
use Parse::CommandLine;
use File::Basename;

our $verbose = 1 ;

{
  our @cmd = @ARGV ;

  die "unexpected command <<$cmd[1]>>" unless $cmd[1] eq 'ocamlc' ;

  our @newcmd ;
  push(@newcmd, shift @cmd) ;
  push(@newcmd, shift @cmd) ;
  push(@newcmd, "-only-show") ;
  push(@newcmd, @cmd) ;
  print join(' ', @newcmd)."\n" ;

  my $showcmd = capturex(@newcmd) ;

  systemx(@ARGV) ;

  my @show = parse_command_line($showcmd);
  my $ppxcmd ;
  my $ppcmd ;
  my $ofile ;
  for (my $i = 0 ; $i < int(@show) ; $i++) {
    if ($show[$i] eq '-pp') { $ppcmd = $show[$i+1] ; }
    if ($show[$i] eq '-ppx') { $ppxcmd = $show[$i+1] ; }
    if ($show[$i] eq '-o') { $ofile = $show[$i+1] ; }
  }

  my $ifile = $show[-1] ;

  print "PP: $ppcmd\n" if defined $ppcmd ;
  print "PPX: $ppxcmd\n" if defined $ppxcmd ;
  print "IFILE: $ifile\n" if defined $ifile ;
  print "OFILE: $ofile\n" if defined $ofile ;

  my $obase = basename($ofile, '.cmo') ;
  print "OBASE: $obase\n";

  my $newppcmd = $ppcmd ;
  $newppcmd =~ s,pr_dump.cmo,pr_o.cmo, ;
  v_system("$newppcmd $ifile > $obase.ppo") ;
}

sub v_system {
  print "'".join("' '", @_)."'\n" if $main::verbose ;
  system(@_) ;
}
