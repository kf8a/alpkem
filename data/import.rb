require 'fileutils'
require 'rubygems'
require  'dbi'
require 'csv'

filename = ARGV[0]

db = DBI.connect('dbi:Pg:s_moisture','')
stmt  = db.prepare('insert into soil_moisture (date, treatment, replicate, bag_weight, cores, wet_weight, dry_weight_plus_bag, moisture, comments)  values (?,?,?,?,?,?,?,?,?)')
CSV.open(filename,'r').each do |row|
  begin
    stmt.execute(row[0],row[1],row[2],row[3],row[4],row[5],row[6],row[7],row[8])
  rescue Exception => e
    p e
  end
end