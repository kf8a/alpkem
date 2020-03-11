m_study = Study.find_or_create_by(name: 'Main Site', prefix: 'T')

1.upto(8) do |i|
  m_study.treatments.find_or_create_by(name: "T#{i}")
end
m_study.treatments.find_or_create_by(name: 'TDF')
m_study.treatments.find_or_create_by(name: 'TSF')
m_study.treatments.find_or_create_by(name: 'TCF')
m_study.treatments.find_or_create_by(name: 'T21')

1.upto(6) do |i|
  m_study.replicates.find_or_create_by(name: "R#{i}")
end

g_study = Study.find_or_create_by(name: 'glbrc', prefix: 'G')

1.upto(10) do |i|
  g_study.treatments.find_or_create_by(name: "G#{i}")
end

1.upto(5) do |i|
  g_study.replicates.find_or_create_by(name: "R#{i}")
end

l_study = Study.find_or_create_by(name: 'Lux Arbor', prefix: 'L')

1.upto(3) do |i|
  l_study.treatments.find_or_create_by(name: "L0#{i}")
end

1.upto(10) do |i|
  l_study.replicates.find_or_create_by(name: "S#{i}")
end

studies = Study.all
studies.each do |study|
  study.treatments.each do |treatment|
    replicates = Replicate.where(study_id: study.id)
    replicates.each do |replicate|
      Plot.where(name: "#{treatment.name}#{replicate.name}", study_id: study)
          .first_or_create(name: "#{treatment.name}#{replicate.name}",
                           study: study,
                           treatment: treatment,
                           replicate: replicate)
    end
  end
end

m_study.reload
m_study.treatments.each do |treatment|
  replicates = Replicate.where(study_id: m_study.id)
  replicates.each do |replicate|
    Plot.where(name: "#{treatment.name}#{replicate.name}-25", study_id: m_study)
        .first_or_create(name: "#{treatment.name}#{replicate.name}-25",
                         study: m_study,
                         treatment: treatment,
                         replicate: replicate)
  end
end

m_study.reload
m_study.treatments.each do |treatment|
  replicates = Replicate.where(study_id: m_study.id)
  replicates.each do |replicate|
    1.upto(5) do |f|
      Plot.where(name: "#{treatment.name}#{replicate.name}F#{f}",
                 study_id: m_study)
          .first_or_create(name: "#{treatment.name}#{replicate.name}F#{f}",
                           study: m_study,
                           treatment: treatment,
                           replicate: replicate)
    end
  end
end

g_study.reload
g_study.treatments.each do |treatment|
  replicates = Replicate.where(study_id: g_study.id)
  replicates.each do |replicate|
    1.upto(3) do |station|
      [10, 25].each do |depth|
        Plot.where(name: "#{treatment.name}#{replicate.name}S#{station}#{depth}",
                   study_id: g_study)
            .first_or_create(name: "#{treatment.name}#{replicate.name}S#{station}#{depth}",
                             study: g_study,
                             treatment: treatment,
                             replicate: replicate)
      end
    end
  end
end

g_study.reload
g_study = Study.where(prefix: 'G').first
g_study.treatments.each do |treatment|
  replicates = Replicate.where(study_id: g_study.id)
  replicates.each do |replicate|
    Plot.create(name: "#{treatment.name}#{replicate.name}micro-25",
                study: g_study,
                treatment: treatment,
                replicate: replicate)
  end
end

Analyte.find_or_create_by(name: 'NO3', unit: 'ppm')
Analyte.find_or_create_by(name: 'NH4', unit: 'ppm')
Analyte.find_or_create_by(name: 'N', unit: 'ppm')
Analyte.find_or_create_by(name: 'C', unit: 'ppm')

cn_deep_study = Study.find_or_create_by(name: 'CN Deep Core', prefix: 'D')

%w[01 02 03 04 05 06 07 08 09 10].each do |plot|
  1.upto(5) do |replicate|
    1.upto(3) do |station|
      %w[010 025 050 100].each do |depth|
        Plot.where(name: "G#{plot}R#{replicate}S#{station}#{depth}",
                   study_id: cn_deep_study)
            .first_or_create(name: "G#{plot}R#{replicate}S#{station}#{depth}",
                             study: cn_deep_study)
      end
    end
  end
end

cn_soil_study = Study.find_or_create_by(name: 'CN Soil Sample', prefix: 'C')

1.upto(5) do |station|
  %w[SUR MID DEE].each do |depth|
    Plot.where(name: "CFR1S#{station}C1#{depth}",
               study_id: cn_soil_study)
        .first_or_create(name: "CFR1S#{station}C1#{depth}",
                         study: cn_soil_study)
    Plot.where(name: "DFR1S#{station}C1#{depth}",
               study_id: cn_soil_study)
        .first_or_create(name: "DFR1S#{station}C1#{depth}",
                         study: cn_soil_study)
  end
end

cn_glbrc_study = Study.find_or_create_by(name: 'CN GLBRC', prefix: 'L')

%w[01 02 03 04 05 06 07 08 09 10].each do |station|
  %w[010 025 050 100].each do |depth|
    %w[01 02 03 04].each do |field|
      Plot.where(name: "L#{field}S#{station}#{depth}",
                 study_id: cn_glbrc_study)
          .first_or_create(name: "L#{field}S#{station}#{depth}",
                           study: cn_glbrc_study)
      Plot.where(name: "M#{field}S#{station}#{depth}",
                 study_id: cn_glbrc_study)
          .first_or_create(name: "M#{field}S#{station}#{depth}",
                           study: cn_glbrc_study)
    end
  end
end

SampleType.find_or_create_by(name: 'Lysimeter')
SampleType.find_or_create_by(name: 'Soil Sample')
SampleType.find_or_create_by(name: 'GLBRC Soil Sample')
SampleType.find_or_create_by(name: 'GLBRC Deep Core Nitrogen')
SampleType.find_or_create_by(name: 'GLBRC Resin Strips')
SampleType.find_or_create_by(name: 'CN Soil Sample')
SampleType.find_or_create_by(name: 'CN Deep Core')
SampleType.find_or_create_by(name: 'GLBRC Soil Sample (New)')
SampleType.find_or_create_by(name: 'GLBRC CN')
SampleType.find_or_create_by(name: 'Lysimeter NO3')
SampleType.find_or_create_by(name: 'Lysimeter NH4')
