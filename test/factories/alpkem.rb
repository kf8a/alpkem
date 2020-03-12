FactoryBot.define do
  sequence :analyte_name do |a|
    "analyte#{a}#{rand(a).to_i}#{rand(4)}"
  end
  sequence :plot_name do |n|
    "plot#{n}#{rand(n).to_i}#{rand(4)}#{Time.now}"
  end
  factory :replicate do
  end
  factory :sample_type do
  end
  factory :study do
  end
  factory :treatment do
  end
  factory :user do
  end
  factory :analyte do
    name { FactoryBot.generate :analyte_name }
  end
  factory :plot do
    name { FactoryBot.generate :plot_name }
  end
  factory :sample do
    association :plot
    sample_type { FactoryBot.build :sample_type }
  end
  factory :measurement do
    sample { FactoryBot.build :sample }
    analyte { FactoryBot.build :analyte }
    amount { 0.5 }
  end
  factory :run do
    sample_type_id { 1 }
    factory :run_with_measurements do
      transient do
        measurements_count { 5 }
      end

      after(:build) do |run, evaluator|
        run.measurements = create_list(:measurement, evaluator.measurements_count, run: run)
      end
    end
    # measurements      [FactoryBot.create(:measurement)]
  end
  factory :cnm, class: :measurement do
    sample
    analyte
    amount { 0.5 }
  end
  factory :cn_run, class: :run do
    sample_type_id { 6 }
    # measurements   [FactoryBot.create(:cnm)]
    factory :cn_run_with_measurements do
      transient do
        measurements_count { 5 }
      end

      after(:build) do |cn_run, evaluator|
        cn_run.measurements = create_list(:measurement, evaluator.measurements_count, run: cn_run)
      end
    end
  end
end
