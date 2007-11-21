dnl $Id$
dnl config.m4 for extension ibm_db2

dnl Comments in this file start with the string 'dnl'.
dnl Remove where necessary. This file will not work
dnl without editing.

dnl If your extension references something external, use with:

PHP_ARG_WITH(IBM_DB2, for IBM_DB2 support,
[  --with-IBM_DB2=[DIR]      Include IBM DB2 Univeral Database and Cloudscape support.
                          DIR is the location of the DB2 application development 
                          headers and libraries. Set the PHP_IBM_DB2_LIB
                          environment variable to set the specific location of
                          the DB2 libraries])

dnl PHP_ARG_ENABLE(IBM_DB2, whether to enable IBM_DB2 support,
dnl Make sure that the comment is aligned:
dnl [  --enable-IBM_DB2           Enable IBM_DB2 support])

if test "$PHP_IBM_DB2" != "no"; then
  dnl # --with-IBM_DB2 -> check with-path  	 
  SEARCH_PATH="$PHP_IBM_DB2_LIB $PHP_IBM_DB2 $DB2PATH $DB2DIR"

  AC_MSG_CHECKING(Looking for DB2 CLI libraries)
  for i in $SEARCH_PATH ; do
    AC_MSG_CHECKING([     in $i])
    if test -r $i/libdb2.so || test -r $i/libdb2.a || test -r $i/libdb400.a ; then
      LIB_DIR="$i/"
      AC_MSG_RESULT(found)
      break
    else
      AC_MSG_RESULT()
    fi
    AC_MSG_CHECKING([     in $i/lib64])
    if test -r $i/lib64/libdb2.so || test -r $i/lib64/libdb2.a || test -r $i/lib64/libdb400.a ; then
      LIB_DIR="$i/lib64/"
      AC_MSG_RESULT(found)
      break
    else
      AC_MSG_RESULT()
    fi
    AC_MSG_CHECKING([     in $i/lib32])
    if test -r $i/lib32/libdb2.so || test -r $i/lib32/libdb2.a || test -r $i/lib32/libdb400.a ; then
      LIB_DIR="$i/lib32/"
      AC_MSG_RESULT(found)
      break
    else
      AC_MSG_RESULT()
    fi
    AC_MSG_CHECKING([     in $i/lib])
    if test -r $i/lib/libdb2.so || test -r $i/lib/libdb2.a || test -r $i/lib/libdb400.a ; then
      LIB_DIR="$i/lib/"
      AC_MSG_RESULT(found)
      break
    else
      AC_MSG_RESULT()
    fi
  done

  if test -z "$LIB_DIR"; then
    AC_MSG_RESULT([not found])
    AC_MSG_ERROR([Please reinstall the DB2 CLI distribution])
  fi

  AC_MSG_CHECKING([for DB2 CLI include files in default path])
  for i in $SEARCH_PATH ; do
    AC_MSG_CHECKING([in $i])
    dnl this is for V8.1 and previous
    if test -r "$i/include/sqlcli1.h" ; then
      IBM_DB2_DIR=$i
      AC_MSG_RESULT(found in $i)
      break
    fi
  done

  if test -z "$IBM_DB2_DIR"; then
    AC_MSG_RESULT([not found])
    AC_MSG_ERROR([Please reinstall the DB2 CLI distribution])
  fi

  dnl # --with-IBM_DB2 -> add include path
  PHP_ADD_INCLUDE($IBM_DB2_DIR/include)

  dnl # --with-IBM_DB2 -> check for lib and symbol presence
  if test -r $LIB_DIR/libdb400.a ; then
    LIBNAME=db400
    PHP_NEW_EXTENSION(ibm_db2, ibm_db2.c, $ext_shared,,-DPASE)
  else
    LIBNAME=db2
    PHP_NEW_EXTENSION(ibm_db2, ibm_db2.c, $ext_shared)
  fi
  LIBSYMBOL=SQLConnect

dnl #  PHP_CHECK_LIBRARY($LIBNAME,$LIBSYMBOL,
dnl #  [
    PHP_ADD_LIBRARY_WITH_PATH($LIBNAME, $LIB_DIR , IBM_DB2_SHARED_LIBADD)
    AC_DEFINE(HAVE_DB2CLILIB,1,[ ])
dnl #  ],[
dnl #    AC_MSG_ERROR([wrong DB2 CLI lib version or lib not found])
dnl #  ],[
dnl #    -L$IBM_DB2_DIR/lib -lm -ldl
dnl #  ])

  PHP_SUBST(IBM_DB2_SHARED_LIBADD)
fi
