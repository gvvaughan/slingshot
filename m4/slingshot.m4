dnl slingshot.m4
dnl
dnl Copyright (c) 2013-2014 Free Software Foundation, Inc.
dnl Written by Gary V. Vaughan, 2013
dnl
dnl This program is free software; you can redistribute it and/or modify
dnl it under the terms of the GNU General Public License as published
dnl by the Free Software Foundation; either version 3, or (at your
dnl option) any later version.
dnl
dnl This program is distributed in the hope that it will be useful, but
dnl WITHOUT ANY WARRANTY; without even the implied warranty of
dnl MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
dnl General Public License for more details.
dnl
dnl You should have received a copy of the GNU General Public License
dnl along with this program.  If not, see <http://www.gnu.org/licenses/>.


# SS_CONFIG_TRAVIS(LUAROCKS)
# --------------------------
# Generate .travis.yml, ensuring LUAROCKS are installed.
AC_DEFUN([SS_CONFIG_TRAVIS], [
  EXTRA_ROCKS="$1"
  AC_SUBST([EXTRA_ROCKS])

  AC_CONFIG_FILES([.travis.yml:travis.yml.in], [
    # Swap files back to where we need them, after shuffling in INIT-CMDS.
    test -f .travis.yml && mv -f .travis.yml .travis.yml.new
    test -f .travis.yml.tmp && mv -f .travis.yml.tmp .travis.yml

    # Remove trailing blanks so as not to trip sc_trailing_blank in syntax check
    sed 's|  *$||' < .travis.yml.new > ss_tmp && {
      if test -f .slackid; then
        read slackid < .slackid
        printf '%s\n' '' 'notifications:' "  slack: $slackid" >> ss_tmp
      fi
      mv ss_tmp .travis.yml.new
      rm -f ss_tmp
    }], [
      # Remove unwritable new .travis.yml
      rm -f .travis.yml.new

      # Save incumbent .travis.yml from overwriting, so the configure
      # output can show 'creating .travis.yml'.
      test -f .travis.yml && mv -f .travis.yml .travis.yml.tmp
    ])

  AC_CONFIG_COMMANDS([travis-yml-up-to-date], [
    : ${CMP="cmp"}

    if test . = "$ac_top_srcdir"; then
      ss_travis_yml=.travis.yml
    else
      ss_travis_yml=$ac_top_srcdir/.travis.yml
    fi
    ss_travis_new=$ss_travis_yml.new

    test -t 1 && {
      # COLORTERM and USE_ANSI_COLORS environment variables take
      # precedence, because most terminfo databases neglect to describe
      # whether color sequences are supported.
      test -n "${COLORTERM+set}" && : ${USE_ANSI_COLORS="1"}

      if test 1 = "$USE_ANSI_COLORS"; then
        # Standard ANSI escape sequences
        tc_reset='@<:@0m'
        tc_red='@<:@31m'
      else
        # Otherwise trust the terminfo database after all.
        test -n "`tput sgr0 2>/dev/null`" && {
          tc_reset=`tput sgr0`
          test -n "`tput setaf 1 2>/dev/null`" && tc_red=`tput setaf 1`
        }
      fi
    }

    if test -f $ss_travis_yml; then
      if $CMP $ss_travis_yml $ss_travis_new >/dev/null 2>&1; then
        rm -f $ss_travis_new
      else
        printf "$as_me: ${tc_red}warning$tc_reset: %s"'\n'	\
          "An updated '$ss_travis_yml' control file has been"	\
          "generated for you in '$ss_travis_new'.  After you've" \
          "verified that you want the changes, you can update"	\
          "with:"						\
          "    mv -f $ss_travis_new $ss_travis_yml"		\
          ""							\
          "Or, remove the existing '$ss_travis_yml' file and"	\
          "rerun $as_me"
        chmod 444 $ss_travis_new
      fi
    else
      mv -f $ss_travis_new $ss_travis_yml
    fi
  ])
])
