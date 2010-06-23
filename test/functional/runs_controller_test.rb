require 'test_helper'

class RunsControllerTest < ActionController::TestCase
  
  def setup
    #TODO make these factories work with the models as they are now
#    4.times {Factory.create :run}
#    @run = Factory.create :run

    @attr = {
      :sample_type_id => 2,
      :sample_date    => Date.today.to_s
    }
    file_name = File.dirname(__FILE__) + '/../data/test.TXT'
    File.open(file_name, 'r') do |f|
      @good_data = StringIO.new(f.read)
    end
    @run = Run.new(@attr)
    @run.load(@good_data)
    @run.save
  end
    
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:runs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should not create run with invalid sample type" do
    assert_no_difference 'Run.count' do
      file_name = '/../data/test.TXT'
      post :create, :run => {:sample_date => Date.today, :sample_type_id => 1},
                    :data => {:file => fixture_file_upload(file_name)}
    end
  end

  test "should create run" do
    old_count = Run.count
    file_name = '/../data/test.TXT'
    
    post :create, :run => {:sample_date => Date.today, :sample_type_id => 2},
                  :data => {:file => fixture_file_upload(file_name)}

    assert old_count + 1, Run.count
    
    plot = Plot.find_by_treatment_and_replicate('T7', 'R1')
    sample = Sample.find_by_plot_id_and_sample_date(plot.id, Date.today.to_s)
    assert_not_nil sample
    assert sample.valid?
    no3 = Analyte.find_by_name('NO3')
    nh4 = Analyte.find_by_name('NH4')
    assert_equal 0.053056531, sample.measurements_by_analyte(no3)[0].amount
    assert_equal 0.295276523, sample.measurements_by_analyte(nh4)[0].amount
    
    assert assigns(:run)
    assert_redirected_to run_path(assigns(:run))
  end
  
  test "should show run" do
    get :show, :id => @run.id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @run.id
    assert_response :success
  end

  test "should update run" do
    #Right now this test just tests whether the update action works at all, not whether it actually updates anything.
    put :update, :id => @run.id
    assert assigns(:run)
    assert_redirected_to run_path(@run)
  end

  test "should destroy run" do
    old_count = Run.count
    delete :destroy, :id => @run.id
    
    assert old_count -1, Run.count
    assert_redirected_to runs_path
  end
  
  context 'creating runs' do
    should 'throw an itelligent error message when uploading a file with the wrong sample_type'
  end
end
