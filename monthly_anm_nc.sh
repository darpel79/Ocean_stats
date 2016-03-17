#!/bin/bash
# monthly_anm_nc.sh version 1.01

  #********************************************************************#
  #                                                                    #
  # Program to compute time-anomalies (x_i-mu_x) for each monthly      #
  # file.nc. Check variariables and directories before use.            #
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
       fileIn=ww3.${yyyymm}.nc
       file_tmp=${yyyymm}_amn_tmp.nc

       # start if the date is equal to the initial date
       if [ $year -eq $syear ] && [ $month -ge $smonth ] || [ $year -gt $syear ]   
       then

         # extract the selected variable with NCO
         ncbo -v ${var1} ${fileIn} ${syear}${smonth}_${eyear}${emonth}_${var1}_avg_bis.nc ${file_tmp}

         echo -e "file ${fileIn} processed"

       fi

       # break the loop if the ending year and month are reached
       if [ "$year" -eq "$eyear" ] && [ "$month" -eq "$emonth" ]
       then
         break
       fi

     done
  done

  ncrcat *amn_tmp.nc ${syear}${smonth}_${eyear}${emonth}_${var1}_anm.nc

         # delete file tmp
         # rm tmp.nc

  exit
