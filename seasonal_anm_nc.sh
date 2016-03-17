#!/bin/bash
# seasonal_anm_nc.sh version 1.03

  #********************************************************************#
  #                                                                    #
  # Program to compute time-anomalies for the chosen season.           #
  # Check variables and directories before use.                        #
  #                                                                    #
  #                                              Author: Dario Pelli   #
  # Last update: 17-Mar-2016                                           #
  #                                                                    #
  #********************************************************************#

  echo -n "Write the initial date (yyyy mm): "
  # The option -n kill the option newline 

  # Read the input from screen
  read syear smonth

  echo -n "Write the end date (yyyy mm): "
  read eyear emonth

  echo "Select the number of the season from the list:"
#  read season
#  season_name=${season}
  # Selection of the season
  select season in "winter" "spring" "summer" "autumn"; do
    season_name=${season}
  break
  done

  # Define variables and direcories
  var1="cge"
  main_dir="/mnt/STORAGE/WEA_WW3/work/"     # work directory
  monthly_dir="${main_dir}monthly_series/"  # monthly files directory
  mean_dir="${main_dir}averages/"           # mean files directory

  cd ${monthly_dir}

  # Define the season
  winter="12 01 02"
  spring="03 04 05"
  summer="06 07 08"
  autumn="09 10 11"

  eval season=\$$season
  
  echo
  echo ----------------------------------------------
  echo
  echo "  Computing time anomalies for the season:  "
  echo "  $season_name (months: ${season})          "
  echo
  echo ----------------------------------------------
  echo

 ## LOOP

  for ((year=syear; year <= eyear; year++))  # year counter
   do
     for month in $(seq -f "%02g" 01 12)    # month counter
     do

       # Define the file name of each simulation
       yyyymm=$year$month
       fileIn=ww3.${yyyymm}.nc
       file_tmp=${yyyymm}seas_amn_tmp.nc

       # start if the date is equal to the initial date
       if [ $year -eq $syear ] && [ $month -ge $smonth ] || [ $year -gt $syear ]   
       then
         case $month in   # write the right months
           ${season:0:2} | ${season:3:2} | ${season:6:2} )
             # extract the selected variable with NCO
             ncbo -v ${var1} ${fileIn} ${mean_dir}${season_name}_${var1}.nc ${file_tmp}

             echo -e "file ${fileIn} processed"
         ;;
         esac
       fi

       # break the loop if the ending year and month are reached
       if [ "$year" -eq "$eyear" ] && [ "$month" -eq "$emonth" ]
       then
         break
       fi

     done
  done

  if [ $? -eq 0 ]
  then
      echo
      echo "  program successfully executed!!"
  else
      echo
      echo "  program terminated with error $?"
  fi  

  exit
