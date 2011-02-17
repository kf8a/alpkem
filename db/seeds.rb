m_study = Study.find_or_create_by_name(:name => 'Main Site', :prefix => 'T')

1.upto(8) do |i|
  m_study.treatments.find_or_create_by_name("T#{i}")
end
m_study.treatments.find_or_create_by_name('TDF')
m_study.treatments.find_or_create_by_name('TSF')
m_study.treatments.find_or_create_by_name('TCF')
m_study.treatments.find_or_create_by_name('T21')

1.upto(6) do |i|
  m_study.replicates.find_or_create_by_name("R#{i}")
end


g_study = Study.find_or_create_by_name({:name => 'glbrc', :prefix => 'G'})

1.upto(10) do |i|
  g_study.treatments.find_or_create_by_name("G#{i}")
end

1.upto(5) do |i|
  g_study.replicates.find_or_create_by_name("R#{i}")
end


l_study = Study.find_or_create_by_name(:name => 'Lux Arbor', :prefix => 'M')
 
1.upto(3) do |i|
  l_study.treatments.find_or_create_by_name("L0#{i}")
end
 
1.upto(10) do |i|
  l_study.replicates.find_or_create_by_name("S#{i}")
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

m_study.reload
m_study.treatments.each do |treatment|
  replicates = Replicate.find_all_by_study_id(m_study.id)
  replicates.each do |replicate|
    1.upto(5) do |f|
      p = Plot.find_or_create_by_name_and_study_id(:name => "#{treatment.name}#{replicate.name}F#{f}", :study => m_study, :treatment => treatment, :replicate => replicate)
    end
  end
end

g_study.reload
g_study.treatments.each do |treatment|
  replicates = Replicate.find_all_by_study_id(g_study.id)
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

1.upto(6) do |replicate|
  1.upto(3) do |station|
  ['010', '025', '050', '100'].each do |depth|
    Plot.find_or_create_by_name_and_study_id({:name => "G01R#{replicate}S#{station}#{depth}", :study => cn_deep_study})
  end
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
  ['010', '025','050','100'].each do |depth|
    ['01','02','03'].each do |field|
    Plot.find_or_create_by_name_and_study_id({:name => "L#{field}S#{station}#{depth}", :study => cn_glbrc_study})
    Plot.find_or_create_by_name_and_study_id({:name => "M#{field}S#{station}#{depth}", :study => cn_glbrc_study})
  end
end
end
