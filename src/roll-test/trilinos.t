#!/usr/bin/perl -w
# trilinos roll installation test.  Usage:
# trilinos.t [nodetype]
#   where nodetype is one of "Compute", "Dbnode", "Frontend" or "Login"
#   if not specified, the test assumes either Compute or Frontend

use Test::More qw(no_plan);

my $appliance = $#ARGV >= 0 ? $ARGV[0] :
                -d '/export/rocks/install' ? 'Frontend' : 'Compute';
my $installedOnAppliancesPattern = '.';
my $output;
my @COMPILERS = split(/\s+/, 'ROLLCOMPILER');
my @MPIS = split(/\s+/, 'ROLLMPI');
my $TESTFILE = 'tmptrilinos';
my %CXX = ('gnu' => 'g++', 'intel' => 'icpc', 'pgi' => 'pgCC');

# trilinos-install.xml
my @compilerNames = map {(split('/', $_))[0]} @COMPILERS;
if($appliance =~ /$installedOnAppliancesPattern/) {
  ok(-d "/opt/trilinos", "trilinos installed");
} else {
  ok(! -d "/opt/trilinos", "trilinos not installed");
}

SKIP: {

  skip "trilinos not installed", 3 if ! -d "/opt/trilinos";
  foreach my $compiler(@COMPILERS) {
    my $compilername = (split('/', $compiler))[0];
    my $path = "/opt/modulefiles/applications/.$compilername/trilinos";
    `/bin/ls $path/[0-9]* 2>&1`;
    ok($? == 0, "trilinos/$compilername module installed");
    `/bin/ls $path/.version.[0-9]* 2>&1`;
    ok($? == 0, "trilinos/$compilername version module installed");
    ok(-l "$path/.version",
       "trilinos/$compilername version module link created");
  }

}

open(OUT, ">$TESTFILE.cxx");
print OUT <<END;
#include "Teuchos_Version.hpp"
using namespace Teuchos;
int main(int argc, char* argv[]) {
  std::cout << Teuchos::Teuchos_Version() << std::endl;
  return 0;
}
END
close(OUT);
foreach my $compiler(@COMPILERS) {
  my $compilername = (split('/', $compiler))[0];
  foreach my $mpi(@MPIS) {
    my $packageHome = "/opt/trilinos/$compilername";
    SKIP: {
      skip "trilinos/$compilername not installed", 2 if ! -d $packageHome;
      open(OUT, ">$TESTFILE.sh");
      print OUT <<END;
#!/bin/bash
module load $compiler $mpi trilinos
export LD_LIBRARY_PATH=/opt/intel/composer_xe_2013.1.117/mkl/lib/intel64:\${LD_LIBRARY_PATH}
mpicxx -I\${TRILINOSHOME}/include -o $TESTFILE.exe $TESTFILE.cxx -L\${TRILINOSHOME}/lib -lteuchoscore
ls -l *.exe
./$TESTFILE.exe
rm -f $TESTFILE.exe
END
      close(OUT);
      $output = `/bin/bash $TESTFILE.sh 2>&1`;
      like($output, qr/$TESTFILE.exe/,
           "Trilinos/$compilername/$mpi compilation");
      like($output, qr/Teuchos in Trilinos [\d\.]+/,
           "Trilinos/$compilername/$mpi run");
    }
  }
}

`rm -fr $TESTFILE*`;
