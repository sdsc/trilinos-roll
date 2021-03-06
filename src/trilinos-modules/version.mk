PACKAGE     = trilinos
CATEGORY    = applications

NAME        = sdsc-$(PACKAGE)-modules
RELEASE     = 11
PKGROOT     = /opt/modulefiles/$(CATEGORY)/$(PACKAGE)

VERSION_SRC = $(REDHAT.ROOT)/src/$(PACKAGE)/version.mk
VERSION_INC = version.inc
include $(VERSION_INC)

RPM.EXTRAS  = AutoReq:No\nAutoProv:No\nObsoletes:sdsc-trilinos_gnu-modules,sdsc-trilinos_intel-modules,sdsc-trilinos_pgi-modules
RPM.PREFIX  = $(PKGROOT)
