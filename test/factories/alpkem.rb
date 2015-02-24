FactoryGirl.define do
  sequence :analyte_name do |a|
    "analyte#{a}#{rand(a).to_i}#{rand(4)}"
  end
  sequence :plot_name do |n|
    "plot#{n}#{rand(n).to_i}#{rand(4)}#{Time.now}"
  end
  factory :analyte do
    name                 { FactoryGirl.generate :analyte_name }
  end
  factory :plot do
    name                 { FactoryGirl.generate :plot_name }
  end
  factory :replicate do
  end
  factory :study do
  end
  factory :treatment do
  end
  factory :user do
  end
  factory :sample do
    association :plot
  end
  factory :measurement do
    association     :sample
    association     :analyte
    amount          0.5
  end
  factory :run do
    sample_type_id    1
    measurements      [FactoryGirl.create(:measurement)]
  end
  factory :cnm, :class => :measurement do
    association   :sample
    association   :analyte, :name => "N"
    amount        0.5
  end
  factory :cn_run, :class => :run do
    sample_type_id    6
    measurements   [FactoryGirl.create(:cnm)]
  end
end
