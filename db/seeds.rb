l_study = Study.find_or_create_by_name(:name => 'Lux Arbor', :prefix => 'M')

1.upto(3) do |i|
  Treatment.find_or_create_by_name(:name => "L0#{i}", :study_id => l_study.id)
end

1.upto(10) do |i|
  Replicate.find_or_create_by_name(:name => "S#{i}", :study_id => l_study.id)
end

l_study.treatments.each do |treatment|
  replicates = Replicate.find_all_by_study_id(l_study)
  replicates.each do |replicate|
    p = Plot.find_or_create_by_name(:name => "#{treatment.name}#{replicate.name}", :study => l_study, :treatment => treatment, :replicate => replicate).save
  end
end