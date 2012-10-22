FactoryGirl.define do
  sequence :analyte_name do |a|
    "analyte#{a}#{rand(a).to_i}#{rand(4)}"
  end
  sequence :plot_name do |n|
    "plot#{n}#{rand(n).to_i}#{rand(4)}#{Time.now}"
  end
  factory :analyte do |a|
    a.name                 { FactoryGirl.generate :analyte_name }
  end
  factory :plot do |p|
    p.name                 { FactoryGirl.generate :plot_name }
  end
  factory :replicate do |r|
  end
  factory :study do |s|
  end
  factory :treatment do |t|
  end
  factory :user do |u|
  end
  factory :sample do |s|
    s.association :plot
  end
  factory :measurement do |m|
    m.association     :sample
    m.association     :analyte
    m.amount          0.5
  end
  factory :run do  |r|
    r.sample_type_id    1
    r.measurements      [FactoryGirl.create(:measurement)]
  end
  factory :cnm, :class => :measurement do |m|
    m.association   :sample
    m.association   :analyte, :name => "N"
    m.amount        0.5
  end
  factory :cn_run, :class => :run do |r|
    r.sample_type_id    6
    r.measurements   [FactoryGirl.create(:cnm)]
  end
end




