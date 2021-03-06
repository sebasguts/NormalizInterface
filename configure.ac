dnl ##
dnl ## Process this file with autoconf to produce a configure script.
dnl ## 

dnl ##
dnl ## Setup autoconf
dnl ##
AC_PREREQ([2.68])
AC_INIT([NormalizInterface], m4_esyscmd([tr -d '\n' < VERSION]), [https://github.com/gap-packages/NormalizInterface/issues], [NormalizInterface], [http://gap-packages.github.io/NormalizInterface/])
AC_CONFIG_SRCDIR([src/normaliz.cc])
AC_CONFIG_HEADER([src/pkgconfig.h:cnf/pkgconfig.h.in])
AC_CONFIG_MACRO_DIR([m4])
AC_CONFIG_AUX_DIR([cnf])

dnl ##
dnl ## Get canonical host info
dnl ##
AC_CANONICAL_HOST

dnl ##
dnl ## Setup automake
dnl ##
AM_INIT_AUTOMAKE([1.11 -Wall foreign subdir-objects])
AM_SILENT_RULES([yes])
AM_PROG_AR

dnl ##
dnl ## C++ is the language
dnl ##
AC_PROG_CXX
AC_LANG([C++])

dnl ##
dnl ## Setup libtool (for building the GAP kernel extension)
dnl ##
LT_PREREQ([2.4.2])
LT_INIT([disable-static dlopen win32-dll])

dnl ##
dnl ## Locate the GAP root dir
dnl ##
AC_FIND_GAP

AC_ARG_WITH([hpcgap],
    [AC_HELP_STRING([--with-hpcgap], [compile for HPCGap])],
    [
    for f in $GAPROOT/*hpc; do
        if test -e "$f"; then
            TOADDCFLAGS="../../build/cflags"
            TOADDLDFLAGS="../../build/ldflags"
        else
            echo "Cannot find HPCGap flags, are you sure this is HPCGap?"
        fi;
        break
    done
    ],[])

if test "x$TOADDCFLAGS" != "x"; then
    if test -e "$TOADDCFLAGS" && test -e "$TOADDLDFLAGS"; then
        CFLAGS="$CFLAGS `cat $TOADDCFLAGS`"
        CXXFLAGS="$CXXFLAGS `cat $TOADDCFLAGS`"
        LDFLAGS="$LDFLAGS `cat $TOADDLDFLAGS`"
    else
        AC_MSG_WARN(Could not find the some config files for compilation)
    fi
fi;

dnl ##
dnl ## Locate Normaliz
dnl ##

AC_ARG_WITH([normaliz],
    [AC_HELP_STRING([--with-normaliz=<path>], [specify root of Normaliz installation])],
    [NORMALIZ="$with_normaliz"],
    [NORMALIZ="$PWD/Normaliz.git/DST"]
)
NORMALIZ_CPPFLAGS="-I$NORMALIZ/include"
NORMALIZ_LDPATH="$NORMALIZ/lib"
NORMALIZ_LDFLAGS="-L$NORMALIZ_LDPATH"
AC_SUBST(NORMALIZ_LDPATH)
AC_SUBST(NORMALIZ_LDFLAGS)
AC_SUBST(NORMALIZ_CPPFLAGS)

dnl ## Make sure Normaliz can be used and its version is at least >= 3.0.0

old_CPPFLAGS="$CPPFLAGS"
old_LDFLAGS="$LDFLAGS"
CPPFLAGS="$CPPFLAGS $NORMALIZ_CPPFLAGS"
LDFLAGS="$LDFLAGS $NORMALIZ_LDFLAGS"
AC_CHECK_HEADER([libnormaliz/cone.h], [], [AC_MSG_ERROR([could not use libnormaliz/cone.h])], [])

AC_MSG_CHECKING([for Normaliz >= 3.0.0])
AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[@%:@include "libnormaliz/cone.h"]],
               [[#if !defined(NMZ_RELEASE) || NMZ_RELEASE < 30000
               #error Normaliz too old
               #endif
               return 0;]])],
       ac_normaliz=yes,ac_normaliz=no)

AC_MSG_RESULT($ac_normaliz)
if test "x$ac_normaliz" != "xyes"; then
    AC_MSG_ERROR([Normaliz >= 3.0.0 is required])
fi
CPPFLAGS="$old_CPPFLAGS"
LDFLAGS="$old_LDFLAGS"

dnl ##
dnl ## Check for C++11 support
dnl ##
AX_CXX_COMPILE_STDCXX(11,noext,mandatory)


dnl ##
dnl ## Detect pointer size to distinguish 32 and 64 bit builds
dnl ##
AC_CHECK_SIZEOF([void **])

dnl ##
dnl ## Detect Windows resp. Cygwin
dnl ##
case $host_os in
  *cygwin* ) CYGWIN=yes;;
         * ) CYGWIN=no;;
esac
AM_CONDITIONAL([SYS_IS_CYGWIN], [test "$CYGWIN" = "yes"])
if test "$CYGWIN" = "yes"; then
  AC_DEFINE(SYS_IS_CYGWIN32, 1, are we on CYGWIN?)
else
  AC_DEFINE(SYS_IS_CYGWIN32, 0, are we on CYGWIN?)
fi

dnl ##
dnl ## Finally, generate the Makefiles and output everything
dnl ##
AC_CONFIG_FILES([Makefile])
AC_OUTPUT
