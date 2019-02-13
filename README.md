A script to schedule, record and process NOAA APT Satellite Passes on Raspberry Pi


Requires:

command line program "predict"

command line program "rtl_fm"

command line program "sox"

command line program "wxtoimg"

Download weather.txt TLE from celestrak.com (see crontab file)
If using for ISS (like for SSTV events), modify stations.txt TLE to first line only ISS, not (Z...)

Run "./noaa-scheduler.sh SATELLITE# FREQUENCY" for example, for NOAA-18 run ./noaa-scheduler.sh 18 137.9125
This should create a task file and schedule the task for the passes using linux at command
