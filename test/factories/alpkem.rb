Factory.define :analyte do |a|
end

Factory.define :cn_sample do |s|
  s.cn_plot     "Plot"
end

Factory.define :plot do |p|
end

Factory.define :study do |s|
end

Factory.define :user do |u|
end

Factory.define :sample do |s|
  s.association   :plot
end

Factory.define :sample_type do |sample_type|
end

Factory.define :measurement do |m|
  m.association     :sample
  m.association     :analyte
  m.amount          0.5
end

Factory.define :run do  |r|
  r.sample_type_id    1
  r.measurements      [Factory.create(:measurement)]
end

Factory.define :cn_measurement do |m|
  m.association     :cn_sample
  m.association     :analyte
  m.amount          0.5
end

Factory.define :cn_run, :class => :run do |r|
  r.sample_type_id    6
  r.cn_measurements   [Factory.create(:cn_measurement)]
end
