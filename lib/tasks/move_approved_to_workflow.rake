namespace :util do
  desc 'move approved to workflow state'
  task to_workflow: :environment do
    Sample.all.each do |sample|
      sample.save
      if sample.approved
        sample.approve!
      end
    end
  end
end
