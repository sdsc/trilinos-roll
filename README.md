# SDSC "trilinos" roll

## Overview

This roll bundles the Trilinos scientific software framework.

For more information about trilinos please visit the official web page:

- <a href="http://trilinos.org" target="_blank">Trilinos</a> is an effort to develop algorithms and enabling technologies within an object-oriented software framework for the solution of large-scale, complex multi-physics engineering and scientific problems.


## Requirements

To build/install this roll you must have root access to a Rocks development
machine (e.g., a frontend or development appliance).

If your Rocks development machine does *not* have Internet access you must
download the appropriate trilinos source file(s) using a machine that does
have Internet access and copy them into the `src/<package>` directories on your
Rocks development machine.


## Dependencies

The sdsc-roll must be installed on the build machine, since the build process
depends on make include files provided by that roll.

The roll sources assume that modulefiles provided by SDSC compiler, python, and mpi
rolls are available, but it will build without them as long as the environment
variables they provide are otherwise defined.

The build process requires cmake and the MKL libraries and assumes that the
modulefiles provided by the SDSC cmake-roll and intel-roll are
available.  It will build without
the modulefiles as long as the environment variables they provide are otherwise
defined.

The roll supports specifying building with/for python versions other than
the one included with the o/s.  To use this feature, specify a `ROLLPY` make
variable that includes a python modulefile, e.g.,

```shell
% make ROLLPY=opt-python 2>&1 | tee build.log
```


## Building

To build the trilinos-roll, execute this on a Rocks development
machine (e.g., a frontend or development appliance):

```shell
% make 2>&1 | tee build.log
```

A successful build will create the file `trilinos-*.disk1.iso`.  If you built the
roll on a Rocks frontend, proceed to the installation step. If you built the
roll on a Rocks development appliance, you need to copy the roll to your Rocks
frontend before continuing with installation.

This roll source supports building with different compilers and for different
MPI flavors and python installations.  The `ROLLCOMPILER`, `ROLLMPI`, and
`ROLLPY` make variables can be used to specify the names of compiler, MPI, and
python modulefiles to use for building the software, e.g.,

```shell
make ROLLCOMPILER=intel ROLLMPI=mvapich2_ib ROLLPY=opt-python 2>&1 | tee build.log
```

The build process recognizes "gnu", "intel" or "pgi" as the value for the
`ROLLCOMPILER` variable; any MPI modulefile name may be used as the value of
the `ROLLMPI` variable, and any python modulefile name for the ROLLPY variable.
The default values are "gnu", "rocks-openmpi", and "python".


## Installation

To install, execute these instructions on a Rocks frontend:

```shell
% rocks add roll *.iso
% rocks enable roll trilinos
% cd /export/rocks/install
% rocks create distro
```

Subsequent installs of compute and login nodes will then include the contents
of the trilinos-roll.  To avoid cluttering the cluster frontend with unused
software, the trilinos-roll is configured to install only on compute and
login nodes. To force installation on your frontend, run this command after
adding the trilinos-roll to your distro

```shell
% rocks run roll trilinos host=NAME | bash
```

where NAME is the DNS name of a compute or login node in your cluster.

In addition to the software itself, the roll installs individual environment
module files for each tool in:

```shell
/opt/modulefiles/applications
```


## Testing

The trilinos-roll includes a test script which can be run to verify proper
installation of the roll documentation, binaries and module files. To
run the test scripts execute the following command(s):

```shell
% /root/rolltests/trilinos.t 
```
