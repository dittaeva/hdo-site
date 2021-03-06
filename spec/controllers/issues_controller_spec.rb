require 'spec_helper'

describe IssuesController do
  let(:issue) { Issue.make! }

  it 'should get :show if the issue is published' do
    issue.update_attributes! status: 'published'

    get :show, id: issue

    response.should have_rendered(:show)
    assigns(:issue).should be_decorated_with(IssueDecorator)
  end

  it 'should get :votes if the issue is published' do
    issue.update_attributes! status: 'published'

    get :votes, id: issue

    response.should have_rendered(:votes)
    assigns(:issue_votes).should be_kind_of(Enumerable)
  end

  it 'should redirect :show to the front page if the issue is not published' do
    get :show, id: issue
    response.should redirect_to(new_user_session_path)
  end

  it 'should redirect :votes to the front page if the issue is not published' do
    get :votes, id: issue
    response.should redirect_to(new_user_session_path)
  end

  context "with rendered views" do
    render_views

    it "should render :show" do
      get :show, id: Issue.make!(status: 'published', published_at: Time.now)
      response.should have_rendered(:show)
    end
  end

  it "should set variables for previous and next issue" do
    # TODO: move to model spec?

    t1 = Issue.make! title: 'aaaa1', status: 'published'
    t2 = Issue.make! title: 'aaaa2', status: 'published'
    t3 = Issue.make! title: 'aaaa3', status: 'published'

    get :show, id: t2

    assigns(:previous_issue).should eq t1
    assigns(:next_issue).should eq t3
  end

  it "ignores non-published issues for the next/previous links" do
    # TODO: move to model spec?

    t1 = Issue.make! title: 'aaaa1', status: 'published'
    t2 = Issue.make! title: 'aaaa2', status: 'published'
    t3 = Issue.make! title: 'aaaa3', status: 'in_progress'

    get :show, id: t2

    assigns(:previous_issue).should eq t1
    assigns(:next_issue).should be_nil
  end

  it 'does not include stats in JSON representation' do
    issue.update_attributes!(status: 'published')

    get :show, id: issue, format: :json

    JSON.parse(response.body).should_not include('stats', 'accountability')
  end

  context 'as a logged in user' do
    let(:user)    { User.make! }
    before(:each) { sign_in user }

    it 'should get :show for a logged in user' do
      get :show, id: issue

      assigns(:issue).should be_decorated_with(IssueDecorator)
      response.should have_rendered(:show)
    end

    it 'includes stats in JSON representation' do
      get :show, id: issue, format: :json

      JSON.parse(response.body).should include('stats', 'accountability')
    end

    it "shows also non-published issues for the next/previous links" do
      t1 = Issue.make! title: 'aaaa1', status: 'published'
      t2 = Issue.make! title: 'aaaa2', status: 'published'
      t3 = Issue.make! title: 'aaaa3', status: 'in_progress'
      t4 = Issue.make! title: 'aaaa4', status: 'shelved'

      get :show, id: t2

      assigns(:previous_issue).should eq t1
      assigns(:next_issue).should eq t3

      get :show, id: t3

      assigns(:previous_issue).should eq t2
      assigns(:next_issue).should eq t4
    end
  end

end
