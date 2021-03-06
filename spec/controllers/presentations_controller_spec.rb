require 'spec_helper'
require 'lib/image_searcher'

describe PresentationsController do
  it "new action should have new presentation assigned" do
    get :new
    assigns(:presentation).should_not be_nil
  end
  
  it "new action should render new template" do
    get :new
    response.should render_template(:new)
  end
  
  it "create action should redirect to show" do
    searcher = mock(ImageSearcher)
    searcher.should_receive(:get_image).and_return("http://www.image.com/image.png")
    ImageSearcher.should_receive(:engine).and_return(searcher)
    presentation = Presentation.new(:content => "silver bullet")
    Presentation.should_receive(:new).and_return(presentation)
    post :create, :presentation  => { :content => "silver bullet" }
    response.should redirect_to(presentation_path(presentation))
  end
  
  it "show action should have presentation with id assigned" do
    presentation = Presentation.new(:content => "silver bullet")
    presentation.stub(:get_image).and_return("http://image.com/image.png")
    Presentation.should_receive(:find).with(1).and_return(presentation)
    get :show, :id  => 1
    assigns(:presentation).should_not be_nil
    assigns(:presentation).slides.should_not be_nil
  end
  
  it "show action should render show template" do
    presentation = Presentation.new(:content => "silver bullet")
    Presentation.should_receive(:find).with(1).and_return(presentation)
    get :show, :id => 1
    response.should render_template(:show)
  end
end
