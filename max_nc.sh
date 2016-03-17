#!/bin/bash
# max_nc.sh version 1.01

  #********************************************************************#
  #                                                                    #
  # Program to compute maximum for each monthly file.nc.               #
  # Check variables and files before use.                              #
  #                                                                    #
  #                                              Author: Dario Pelli   #
  # Last update: 23-Feb-2016                                           #
  #                                                                    #
  #********************************************************************#

  echo -n "Write the initial date (yyyy mm): "
  # The option -n kill the option newline 

  # Read the input from screen
  read syear smonth

  echo -n "Write the end date (yyyy mm): "
  read eyear emonth

  # Define variables and direcories
  var1="cge"
  main_dir="/mnt/STORAGE/WEA_WW3/work/"     # work directory
  monthly_dir="${main_dir}monthly_series/"  # monthly files directory
  mean_dir="${main_dir}averages/"           # mean files directory

  cd ${monthly_dir}

 ## LOOP

  for ((year=syear; year <= eyear; year++))  # year counter
   do
     for month in $(seq -f "%02g" 01 12)    # month counter
     do

       # Define the file name of each simulation
       yyyymm=$year$month
       fileIn=ww3.${yyyymm}_${var1}.nc
       file_Out=ww3.${yyyymm}_max_${var1}.nc

       # start if the date is equal to the initial date
       if [ $year -eq $syear ] && [ $month -ge $smonth ] || [ $year -gt $syear ]   
       then

         # compute the max with NCO
         ncwa -y max -v ${var1} -a time ${fileIn} ${file_Out}

         echo -e "file ${fileIn} processed"

       fi

       # break the loop if the ending year and month are reached
       if [ "$year" -eq "$eyear" ] && [ "$month" -eq "$emonth" ]
       then
         break
       fi

     done
  done

         # delete file tmp
         # rm tmp.nc

  exit
