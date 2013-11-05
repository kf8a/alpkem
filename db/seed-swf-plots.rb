swf_glbrc_study = Study.find_or_create_by_name(:name => 'SWF', :prefix => 'SWF')

1.upto(8) do |treatment|
  [100,200,300,400] do |block|
      plot = treatment + block
      Plot.where(:name => "SWF#{plot}", :study_id => swf_glbrc_study).first_or_create({:name => "SWF#{plot}}", :study => swf_glbrc_study})
  end
end
