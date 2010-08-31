Factory.define :user do |u|
end

Factory.define :analyte do |a|
  a.name  "NO3"
  a.unit  "ppm"
end

Factory.define :sample do |s|
  s.sample_type_id  1
  s.plot_id         1
  s.sample_date     Date.today
end

Factory.define :cn_sample do |s|
  s.cn_plot         "Testplot"
  s.sample_date     Date.today
end  

Factory.define :measurement do |m|
#    m.association     :run
#    m.sample          Factory.create :sample       
  m.association     :sample
#    m.analyte         Factory.create :analyte
  m.association     :analyte
  m.amount          0.5
end

Factory.define :cn_measurement do |m|
  m.run_id          2
  m.cn_sample       Factory.create :cn_sample       
  m.analyte         Factory.create :analyte
  m.amount          0.5
end

Factory.define :run do  |r|
  r.run_date          Date.today
  r.sample_date       Date.today
  r.sample_type_id    1
  r.measurements      [Factory.create(:measurement, :run_id => r.object_id)]
end
