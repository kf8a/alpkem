Factory.sequence :analyte_name do |a|
  "analyte#{a}#{rand(a).to_i}#{rand(4)}"
end

Factory.define :analyte do |a|
  a.name                 { Factory.next :analyte_name }
end

Factory.sequence :plot_name do |n|
  "plot#{n}#{rand(n).to_i}#{rand(4)}#{Time.now}"
end

Factory.define :plot do |p|
  p.name                 { Factory.next :plot_name }
end

Factory.define :replicate do |r|
end

Factory.define :study do |s|
end

Factory.define :treatment do |t|
end

Factory.define :user do |u|
end

Factory.define :sample do |s|
  s.association   :plot
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

Factory.define :cnm, :class => :measurement do |m|
  m.association   :sample
  m.association   :analyte, :name => "N"
  m.amount        0.5
end

Factory.define :cn_run, :class => :run do |r|
  r.sample_type_id    6
  r.measurements   [Factory.create(:cnm)]
end
