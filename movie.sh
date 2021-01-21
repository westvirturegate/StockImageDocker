#!/bin/bash -eu

#
# YYYY-MM-DD
#
readonly start_date=2020-02-12
readonly end_date=2020-06-11

# For mac OS
#
# You need before run this script
# $ brew install coreutils
#
# shopt -s expand_aliases
# alias date=gdate

current_date="$start_date"
while true; do

		      cat /out/$current_date.csv | Rscript /r/scat.R 

			        if [ "$current_date" = "$end_date" ] ; then
					                break
							        fi

								        current_date=$(date -d "$current_date 1day" "+%Y-%m-%d")
								done
