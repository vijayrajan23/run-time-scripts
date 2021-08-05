#!/usr/bin/env bash

DIR=$(date -dmonday +%Y_%b_%d)

if [[ -d "${DIR}" ]]; then
	echo "Directory ${DIR} exists"
else
	echo "Directory ${DIR} does not exist, creating...."
	mkdir "${DIR}"
fi

cd ${DIR}

from_date=$(date -d "yesterday" '+%Y-%m-%d 00:00:00')
end_date=$(date '+%Y-%m-%d 00:00:00')

echo "Pulling LogDNA data from ${from_date} to ${end_date}"

/opt/ops-report/export_report_data.py -s "${from_date}" -e "${end_date}" --stats -r us-south

python combine_data.py -d $DIR/ -t _5-1_5-31 -f 'may_2020_23/_5-1_5-23,may_2020_31/_5-23_5-31' -r ALL

# folder directory dates

week_start_date=$(date -dlast-sunday +_%-m-%-d)
echo $week_start_date

week_end_date=$(date -dnext-saturday +_%-m-%-d)
echo "${week_end_date}"_"${week_start_date}"


# week wise execution

date_in_letters=$(date +'%a')

if [ "${date_in_letters}" == "Sat" ]; then
	echo "${date_in_letters}"
else 
	echo "${date_in_letters}"
	echo "non sat"
fi


# Month wise execution

last_date_current_month=$(date -d "-$(date +%d) days +1 month" +%d)
today_date=$(date +%d)

if [ "${today_date}" == "${last_date_current_month}" ]; then
	echo "${last_date_current_month}"
else 
	echo "${today_date}"
fi
