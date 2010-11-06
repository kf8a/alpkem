m_study = Study.find_or_create_by_name(:name => 'Main Site', :prefix => 'T')

1.upto(8) do |i|
  Treatment.find_or_create_by_name_and_study_id("T#{i}", m_study)
end
Treatment.find_or_create_by_name_and_study_id('TDF', m_study)
Treatment.find_or_create_by_name_and_study_id('TSF', m_study)
Treatment.find_or_create_by_name_and_study_id('TCF', m_study)
Treatment.find_or_create_by_name_and_study_id('T21', m_study)

1.upto(6) do |i|
  Replicate.find_or_create_by_name_and_study_id("R#{i}", m_study)
end


g_study = Study.find_or_create_by_name({:name => 'glbrc', :prefix => 'G'})

1.upto(10) do |i|
  Treatment.find_or_create_by_name_and_study_id("G#{i}", g_study)
end

1.upto(5) do |i|
  Replicate.find_or_create_by_name_and_study_id("R#{i}", g_study)
end


l_study = Study.find_or_create_by_name(:name => 'Lux Arbor', :prefix => 'M')
 
1.upto(3) do |i|
  Treatment.find_or_create_by_name_and_study_id("L0#{i}", l_study)
end
 
1.upto(10) do |i|
  Replicate.find_or_create_by_name_and_study_id("S#{i}", l_study)
end
 

studies = Study.all
studies.each do |study|
  study.treatments.each do |treatment|
    replicates = Replicate.find_all_by_study_id(study)
    replicates.each do |replicate|
      p = Plot.find_or_create_by_name_and_study_id({:name => "#{treatment.name}#{replicate.name}", :study => study, :treatment => treatment, :replicate => replicate})
    end
  end
end

m_study.treatments.each do |treatment|
  replicates = Replicate.find_all_by_study_id(m_study)
  replicates.each do |replicate|
    1.upto(3) do |f|
      p = Plot.find_or_create_by_name_and_study_id(:name => "#{treatment.name}#{replicate.name}F#{f}", :study => m_study, :treatment => treatment, :replicate => replicate)
    end
  end
end


g_study.treatments.each do |treatment|
  replicates = Replicate.find_all_by_study_id(g_study)
  replicates.each do |replicate|
    1.upto(3) do |station|
      [10,25].each do |depth|
        Plot.find_or_create_by_name_and_study_id({:name => "#{treatment.name}#{replicate.name}S#{station}#{depth}", :study => g_study,
            :treatment => treatment, :replicate => replicate})
      end
    end
  end
end

Analyte.find_or_create_by_name({:name => 'NO3', :unit => 'ppm'})
Analyte.find_or_create_by_name({:name => 'NH4', :unit => 'ppm'})
Analyte.find_or_create_by_name({:name => 'N',   :unit => 'ppm'})
Analyte.find_or_create_by_name({:name => 'C',   :unit => 'ppm'})

cn_deep_study = Study.find_or_create_by_name(:name => 'CN Deep Core', :prefix => 'D')

1.upto(6) do |station|
  ['010', '025', '050', '100'].each do |depth|
    Plot.find_or_create_by_name_and_study_id({:name => "DCL01S0#{station}#{depth}", :study => cn_deep_study})
  end
end

cn_soil_study = Study.find_or_create_by_name(:name => 'CN Soil Sample', :prefix => 'C')

1.upto(5) do |station|
  ['SUR', 'MID', 'DEE'].each do |depth|
    Plot.find_or_create_by_name_and_study_id({:name => "CFR1S#{station}C1#{depth}", :study => cn_soil_study})
    Plot.find_or_create_by_name_and_study_id({:name => "DFR1S#{station}C1#{depth}", :study => cn_soil_study})
  end
end

cn_glbrc_study = Study.find_or_create_by_name(:name => 'CN GLBRC', :prefix => 'L')

['01', '02', '03', '04', '05', '06', '07', '08', '09', '10'].each do |station|
  ['010', '025'].each do |depth|
    Plot.find_or_create_by_name_and_study_id({:name => "L01S#{station}#{depth}", :study => cn_glbrc_study})
    Plot.find_or_create_by_name_and_study_id({:name => "L02S#{station}#{depth}", :study => cn_glbrc_study})
  end
end