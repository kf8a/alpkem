Factory.define :user do |u|
end

Factory.define :analyte do |a|
end

Factory.define :plot do |p|
end

Factory.define :sample do |s|
end

Factory.define :cn_sample do |s|
end  

Factory.define :measurement do |m|
  m.association     :sample
  m.association     :analyte
  m.amount          0.5
end

Factory.define :cn_measurement do |m|
  m.association     :cn_sample
  m.association     :analyte
  m.amount          0.5
end

Factory.define :run do  |r|
  r.sample_type_id    1
  r.measurements      [Factory.create(:measurement)]
end

Factory.define :cn_run, :class => :run do |r|
  r.sample_type_id    6
  r.cn_measurements   [Factory.create(:cn_measurement)]
end
