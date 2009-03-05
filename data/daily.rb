#!/usr/bin/env ruby
#
#  Created by  on 2007-10-15.
#  Copyright (c) 2007. All rights reserved.

require 'fileutils'
require 'rubygems'
require  'dbi'
require 'fastercsv'

FILE = 'LTER_final_storage_2'
# try to rename the file
file_name = FILE + ".dat"
backup_file_name = FILE + '-' + Date.today.to_s + ".backup"
#include FileUtils
FileUtils.mv(file_name, backup_file_name)

#  load it into the database
errors = 0
db = DBI.connect('dbi:Pg:weather', '')
stmt = db.prepare('insert into lter_day_d (array_id,program_version,year_rtm,day_rtm,hour_minute_rtm,air_temp_107_max, air_temp_107_hour_max, air_temp_107_min, air_temp_107_hour_min, wind_speed_s_wvt,wind_direction_d1_wvt,wind_direction_sd1_wvt,wind_speed_max,  wind_speed_hour_max,rh_max, rh_hour_max,rh_min,  rh_hour_min,sol_rad_max, sol_rad_hour_max,soil_moisture_5_cm_max, soil_moisture_5_cm_hour_max, soil_moisture_5_cm_min, soil_moisture_5_cm_hour_min,  soil_moisture_20_cm_max, soil_moisture_20_cm_hour_max, soil_moisture_20_cm_min, soil_moisture_20_cm_hour_min) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)')
FasterCSV.open(backup_file_name,'r').each do |row|
  begin
    stmt.execute(row[0],row[1],row[2],row[3],row[4],row[5],row[6],row[7],row[8],row[9],row[10],row[11],row[12],row[13],row[14],row[15],row[16],row[17],row[18],row[19],row[20],row[21],row[22],row[23],row[24],row[25],row[26],row[27])
  rescue Exception => e
    errors = errors + 1
  end
end

if errors == 0
  rm(backup_file_name)
end
