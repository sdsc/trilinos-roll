ifndef ROLLCOMPILER
  ROLLCOMPILER = gnu
endif
COMPILERNAME := $(firstword $(subst /, ,$(ROLLCOMPILER)))

ifndef ROLLMPI
  ROLLMPI = rocks-openmpi
endif
MPINAME := $(firstword $(subst /, ,$(ROLLMPI)))

ifndef ROLLPY
  ROLLPY = python
endif

NAME           = sdsc-trilinos_$(COMPILERNAME)_$(MPINAME)
VERSION        = 12.12.1
RELEASE        = 0
PKGROOT        = /opt/trilinos/$(COMPILERNAME)/$(MPINAME)

SRC_SUBDIR     = trilinos

SOURCE_NAME    = trilinos
SOURCE_SUFFIX  = tar.gz
SOURCE_VERSION = $(VERSION)
SOURCE_PKG     = $(SOURCE_NAME)-$(SOURCE_VERSION)-Source.$(SOURCE_SUFFIX)
SOURCE_DIR     = $(SOURCE_PKG:%.$(SOURCE_SUFFIX)=%)

SWIG_NAME      = swig
SWIG_SUFFIX    = tar.gz
SWIG_VERSION   = 3.0.12
SWIG_PKG       = $(SWIG_NAME)-$(SWIG_VERSION).$(SWIG_SUFFIX)
SWIG_DIR       = $(SWIG_PKG:%.$(SWIG_SUFFIX)=%)

MATIO_NAME     = matio
MATIO_SUFFIX   = tar.gz
MATIO_VERSION  = 1.5.11
MATIO_PKG      = $(MATIO_NAME)-$(MATIO_VERSION).$(MATIO_SUFFIX)
MATIO_DIR      = $(MATIO_PKG:%.$(MATIO_SUFFIX)=%)

TAR_GZ_PKGS    = $(SOURCE_PKG) $(SWIG_PKG) $(MATIO_PKG)

RPM.EXTRAS     = AutoReq:No
