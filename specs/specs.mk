# Specl make rules.
#
# Copyright (c) 2013 Gary V. Vaughan
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
## Specs. ##
## ------ ##

SPECL = specl

specl_SPECS =						\
	$(srcdir)/specs/package_spec.yaml		\
	$(NOTHING_ELSE)

check_local += specs-check-local
specs-check-local: $(specl_SPECS) $(specl_LUASPECS)
	$(AM_V_at)$(SPECL) $(SPECL_OPTS) $(specl_SPECS)


## ------------- ##
## Distribution. ##
## ------------- ##

EXTRA_DIST +=						\
	$(specl_SPECS)					\
	$(NOTHING_ELSE)
