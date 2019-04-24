# $Id$
#
# @Copyright@
#
# 				Rocks(r)
# 		         www.rocksclusters.org
# 		         version 7.0 (Manzanita)
#
# Copyright (c) 2000 - 2017 The Regents of the University of California.
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#
# 1. Redistributions of source code must retain the above copyright
# notice, this list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright
# notice unmodified and in its entirety, this list of conditions and the
# following disclaimer in the documentation and/or other materials provided
# with the distribution.
#
# 3. All advertising and press materials, printed or electronic, mentioning
# features or use of this software must display the following acknowledgement:
#
# 	"This product includes software developed by the Rocks(r)
# 	Cluster Group at the San Diego Supercomputer Center at the
# 	University of California, San Diego and its contributors."
#
# 4. Except as permitted for the purposes of acknowledgment in paragraph 3,
# neither the name or logo of this software nor the names of its
# authors may be used to endorse or promote products derived from this
# software without specific prior written permission.  The name of the
# software includes the following terms, and any derivatives thereof:
# "Rocks", "Rocks Clusters", and "Avalanche Installer".  For licensing of
# the associated name, interested parties should contact Technology
# Transfer & Intellectual Property Services, University of California,
# San Diego, 9500 Gilman Drive, Mail Code 0910, La Jolla, CA 92093-0910,
# Ph: (858) 534-5815, FAX: (858) 534-7345, E-MAIL:invent@ucsd.edu
#
# THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS''
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
# THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS
# BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
# BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
# OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
# IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# @Copyright@
#
# $Log$

REDHAT.ROOT = $(CURDIR)/../../
RPM.EXTRAS=%define __os_install_post /usr/lib/rpm/brp-compress

-include $(ROCKSROOT)/etc/Rules.mk
include Rules.mk
include $(SDSCDEVEL)/Pull.mk
include $(SDSCDEVEL)/Rules.mk

COMPILERLDFLAGS=
PGICOMPILE=
ifeq ("$(COMPILERNAME)", "intel")
  COMPILERLDFLAGS = -lirc
else ("$(COMPILERNAME)", "pgi")
  PGICOMPILE = -DTPL_ENABLE_BoostLib=OFF
endif

# The Intel compilers use the C++ libraries that are packaged with the first
# gnu compiler found in PATH. Since the default system gnu doesn't support
# C++11, for Intel we have to load /opt/gnu to get the updated library.
MODULE_LOAD_CXX11_LIB = $(call MODULE_LOAD_COMPILER, gnu, gcc)

SWIG_CACHE = $(REDHAT.ROOT)/cache/build-swig
MATIO_CACHE = $(REDHAT.ROOT)/cache/build-matio
SWIG_LICENSE_FILES = COPYRIGHT LICENSE LICENSE-GPL README
MATIO_LICENSE_FILES = COPYING README

$(NAME).spec: DESCRIPTION LICENSE

DESCRIPTION:
	$(MODULE_LOAD_CC); \
	$(MODULE_LOAD_PYTHON); \
	( \
	  $(DESCRIBE_PKG); \
	  $(DESCRIBE_CC); \
	  $(DESCRIBE_MKL); \
	  $(DESCRIBE_MPI); \
	  $(DESCRIBE_PYTHON) \
	  $(DESCRIBE_NETCDF) \
	  $(DESCRIBE_BOOST) \
	) > $@

LICENSE: $(SRC_DIRS)
	for F in $(SWIG_LICENSE_FILES); do \
	  cp swig*/$$F $(SOURCE_DIR)/swig-$$F; \
	done
	for F in $(MATIO_LICENSE_FILES); do \
	  cp matio*/$$F $(SOURCE_DIR)/matio-$$F; \
	done
	$(CHECK_LICENSE_FILES)
	echo BSD and LPGL and GPL and others > $@

build: $(SRC_DIRS)
	patch $(SOURCE_DIR)/packages/PyTrilinos/src/Tpetra.i patch-files/Tpetra.i.patch
	patch $(SOURCE_DIR)/packages/kokkos-kernels/src/impl/tpls/KokkosBlas1_axpby_tpl_spec_decl.hpp patch-files/KokkosBlas1_axpby_tpl_spec_decl.hpp.patch
	patch $(SOURCE_DIR)/packages/seacas/libraries/aprepro_lib/apr_aprepro.cc patch-files/apr_aprepro.cc
	( \
	  $(MODULE_LOAD_CC); \
	  $(MODULE_LOAD_CMAKE); \
	  $(MODULE_LOAD_MKL); \
	  export MKLLIB=$${MKLHOME}/lib/intel64; \
	  $(MODULE_LOAD_MPI); \
	  $(MODULE_LOAD_NETCDF); \
	  $(MODULE_LOAD_BOOST); \
	  $(MODULE_LOAD_PYTHON); \
	  if test "$(COMPILERNAME)" = "intel"; then \
	    $(MODULE_LOAD_CXX11_LIB); \
	  fi; \
	  if test ! -e $(SWIG_CACHE); then \
	    cd $(SWIG_DIR); \
	    ./configure CC=$(CC) CXX=$(CXX) --prefix=$(SWIG_CACHE); \
	    $(MAKE) -j 16 ; \
	    $(MAKE)  -j 16 install; \
	    cd ..; \
	  fi; \
          cd $(MATIO_DIR); \
          bash configure CC=$(CC) CXX=$(CXX) --prefix=$(MATIO_CACHE); \
          make; \
          make install; \
	  cd ../$(SOURCE_DIR); \
          mkdir /tmp/build; \
          cd /tmp/build; \
	  MKLLINK="-L$${MKLLIB} -lmkl_intel_lp64 -lmkl_sequential -lmkl_core \
	           -lpthread"; \
	  export PATH=$(SWIG_CACHE)/bin:$${PATH}; \
          export LDFLAGS="-lrt $(COMPILERLDFLAGS) -L$${NETCDFHOME}/lib -lnetcdf -L$(MATIO_CACHE)/lib -lmatio"; \
	  cmake -DCMAKE_INSTALL_PREFIX:PATH=$(PKGROOT) \
	        -DCMAKE_BUILD_TYPE:STRING=DEBUG \
                -DTrilinos_CXX11_FLAGS="-std=c++11" \
	        -DCMAKE_Fortran_COMPILER:FILEPATH=$${MPIHOME}/bin/mpif90 \
	        -DCMAKE_CXX_COMPILER:FILEPATH=$${MPIHOME}/bin/mpicxx \
	        -DCMAKE_C_COMPILER:FILEPATH=$${MPIHOME}/bin/mpicc \
	        -DTrilinos_ENABLE_DEFAULT_PACKAGES:BOOL=ON \
	        -DTrilinos_ENABLE_Epetra:BOOL=ON \
	        -DTrilinos_ENABLE_Teuchos:BOOL=ON \
	        -DTrilinos_ENABLE_CTrilinos:BOOL=ON \
	        -DTrilinos_ENABLE_ForTrilinos:BOOL=OFF \
	        -DTrilinos_ENABLE_TESTS:BOOL=ON \
	        -DTrilinos_ENABLE_PyTrilinos:BOOL=ON \
                -DTrilinos_ENABLE_SEACAS:BOOL=ON \
	        -DTPL_BLAS_LIBRARIES:STRING="$${MKLLINK}" \
	        -DTPL_LAPACK_LIBRARIES:STRING="$${MKLLINK}" \
	        -DDART_TESTING_TIMEOUT:STRING=600 \
	        -DTPL_ENABLE_MPI:BOOL=ON \
	        -DMPI_BASE_DIR:PATH=$${MPIHOME} \
	        -DMPI_USE_COMPILER_WRAPPERS=ON \
	        -DTrilinos_EXTRA_LINK_FLAGS:STRING="" \
	        -DMPI_EXEC_MAX_NUMPROCS:STRING=8 \
	        -DMPI_EXEC:FILEPATH="$${MPIHOME}/bin/mpirun" \
	        -DTPL_MPI_INCLUDE_DIRS:INTERNAL="$${MPIHOME}/include" \
	        -DTPL_MPI_LIBRARIES:INTERNAL="$${MPIHOME}/lib" \
	        -DCMAKE_VERBOSE_MAKEFILE=TRUE \
	        -DTrilinos_VERBOSE_CONFIGURE:BOOL=TRUE \
	        -DBUILD_SHARED_LIBS:BOOL=ON \
                -DTPL_Netcdf_PARALLEL=ON \
                -DTPL_Netcdf_INCLUDE_DIRS=$${NETCDFHOME}/include \
                -DTPL_Netcdf_LIBRARIES=$${NETCDFHOME}/lib \
                -DTPL_Netcdf_Enables_Netcdf4=ON \
                -DTPL_Netcdf_Enables_PNetcdf=ON \
                -DTPL_Boost_INCLUDE_DIRS=$${BOOSTHOME}/include \
                -DBoostLib_INCLUDE_DIRS=$${BOOSTHOME}/include \
                -DBoostLib_LIBRARY_DIRS=$${BOOSTHOME}/lib \
                -DTPL_Matio_INCLUDE_DIRS=$(MATIO_CACHE)/include \
                -DTPL_Matio_LIBRARIES=$(MATIO_CACHE)/include \
                -DHAVE_GNUMAKE=YES $(PGICOMPILE) \
	        $(CURDIR)/$(SOURCE_DIR) ; \
	  $(MAKE) -f $(PWD)/Makefile unique-opts; \
	  $(MAKE) -j 16; \
	)
	@echo "::: Package $(NAME) build complete :::"

# The trilinos cmake process produces build lines with dozens of duplicate -I
# and -L options, resulting in build failures with the shell error message
# "Argument list too long." This command removes these duplicate options from
# each .make file in the build tree.
unique-opts:
	perl -pi -e 'next if $$_ !~ / -[IL]/; foreach my $$word(split) { next if $$word !~ /^-[IL]/; $$_ =~ s!\Q$$word\E\s!AaBbCc !; $$_ =~ s!\Q$$word\E\s+!!g; $$_ =~ s!AaBbCc!$$word!;}' `find . -name \*.make`; \

install::
	# Using a bind mount appears to be the only way to prevent the build
	# from incorporating $(ROOT) in binary files.
	mkdir -p -m 755 $(ROOT)/$(PKGROOT)
	$(PKGROOT_BIND_MOUNT)
	( \
	  $(MODULE_LOAD_CC); \
	  $(MODULE_LOAD_CMAKE); \
	  $(MODULE_LOAD_MKL); \
	  export MKLLIB=$${MKLHOME}/lib/intel64; \
	  $(MODULE_LOAD_MPI); \
	  $(MODULE_LOAD_NETCDF); \
	  $(MODULE_LOAD_BOOST); \
	  $(MODULE_LOAD_PYTHON); \
	  cd /tmp/build; \
	  make install; \
          cp -r $(MATIO_CACHE)/lib/* $(PKGROOT)/lib; \
	)
	$(PKGROOT_BIND_UMOUNT)
	rm -rf /tmp/build
	$(INSTALL_LICENSE_FILES)
	@echo "::: Package $(NAME) install complete :::"

clean::
	rm -rf $(SRC_DIRS) DESCRIPTION LICENSE
