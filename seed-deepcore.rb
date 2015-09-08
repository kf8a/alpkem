def top_depth(bottom)
  case bottom
  when 10 then 0
  when 25 then 10
  when 50 then 25
  when 122 then 50
  end
end
def seed
  [1,2,3,4,5,6,7,8,"8nt"].each do |trt|
    1.upto(6) do |rep|
      1.upto(5) do |stn|
        1.upto(2) do |core|
          [10,25,50,122].each do |depth|
            plot = "T#{trt.to_s.rjust(2,'0')}R#{rep}S#{stn}C#{core}-#{depth}"
            p Plot.where(name: plot, study_id: 1).first_or_create(name: plot, study_id: 1, bottom_depth: depth, top_depth: top_depth(depth))
          end
        end
      end
    end
  end
  ["SF","CF","DF"].each do |trt|
    1.upto(3) do |rep|
      1.upto(5) do |stn|
        1.upto(2) do |core|
          [10,25,50,122].each do |depth|
            plot = "T#{trt.to_s.rjust(2,'0')}R#{rep}S#{stn}C#{core}-#{depth}"
            p Plot.where(name: plot, study_id: 1).first_or_create(name: plot, study_id: 1, bottom_depth: depth, top_depth: top_depth(depth))
          end
        end
      end
    end
  end
end
