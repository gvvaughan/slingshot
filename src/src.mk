# Project make rules.
#
# Copyright (c) 2013-2014 Gary V. Vaughan
# Written by Gary V. Vaughan, 2013
#
# This program is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3, or (at your option)
# any later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.


## ------ ##
## Build. ##
## ------ ##

bin_SCRIPTS += build-aux/mkrockspecs

man_MANS += docs/mkrockspecs.1

docs/mkrockspecs.1: build-aux/mkrockspecs Makefile
	@test -d docs || mkdir docs
## Exit gracefully if mkrockspecs.1 is not writeable, such as during distcheck!
	$(AM_V_GEN)if ( touch $@.w && rm -f $@.w; ) >/dev/null 2>&1; \
	then						\
	  builddir='$(builddir)'			\
	  $(HELP2MAN)					\
	    '--output=$@'				\
	    '--no-info'					\
	    '--name=Slingshot'				\
	    build-aux/mkrockspecs;			\
	fi


## ------------- ##
## Distribution. ##
## ------------- ##

EXTRA_DIST +=						\
	build-aux/merge-sections			\
	build-aux/mkrockspecs				\
	docs/mkrockspecs.1				\
	$(NOTHING_ELSE)


## ------------ ##
## Maintenance. ##
## ------------ ##

CLEANFILES +=						\
	docs/mkrockspecs.1				\
	$(NOTHING_ELSE)
