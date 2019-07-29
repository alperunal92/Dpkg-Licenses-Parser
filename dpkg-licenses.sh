#!/bin/bash
#
#    Copyright 2019 Alper Unal
#
#    This file is part of dpkg-licenses.
#
#    dpkg-licenses was written by Alper Unal
#
#    dpkg-licenses is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    dpkg-licenses is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with dpkg-licenses.  If not, see <http://www.gnu.org/licenses/>.

set -e

case "$1" in
  --help|-h)
    cat >&2 <<.e
Lists all installed packages (dpkg -l similar format) and prints their licenses

Usage: $0
.e
    exit 1
esac

SCRIPTLIB=$(dirname $(readlink -f "$0"))/lib/
test -d "$SCRIPTLIB"

format='%-2s  %-30s %-30s %-6s %-60s %s\n'
printf "$format" "St" "Name" "Version" "Arch" "Description" "Licenses"
printf "$format" "--" "----" "-------" "----" "-----------" "--------"

COLUMNS=2000 dpkg -l | grep '^.[iufhwt]' | while read pState package pVer pArch pDesc; do
  license=
  for method in "$SCRIPTLIB"/reader*; do
    [ -f "$method" ] || continue
    license=$("$method" "$package")
    [ $? -eq 0 ] || exit 1
    [ -n "$license" ] || continue
    # remove line breaks and spaces
    license=$(echo "$license" | tr '\n' ' ' | sed -r -e 's/ +/ /g' -e 's/^ +//' -e 's/ +$//')
    [ -z "$license" ] || break
  done
  [ -n "$license" ] || license='unknown'

  printf "$format" "$pState" "${package:0:30}" "${pVer:0:30}" "${pArch:0:6}" "${pDesc:0:60}" "$license"
done

