require 'spec_helper'

describe Admin::QuestionsController do

  let(:user) { User.make! }
  before { sign_in user }

  def valid_attributes
    {title: 'Test?', body: 'test test test'}
  end

  describe "GET index" do
    it "assigns all questions grouped by status" do
      question = Question.make!

      get :index, {}
      assigns(:questions_by_status).should eq({'pending' => [question]})
    end
  end

  describe "PUT approve" do
    it "updates the requested question" do
      question = Question.make!

      put :approve, {:id => question.to_param}
      question.reload.should be_approved
    end

    it "redirects to questions#index" do
      question = Question.make!

      put :approve, {:id => question.to_param}
      response.should redirect_to(admin_questions_path)
    end

    it "informs the user if save fails" do
      question = Question.make!
      Question.any_instance.should_receive(:save).and_return false

      put :reject, {:id => question.to_param}
      response.should redirect_to(admin_questions_path)
      flash.should_not be_empty
    end
  end

  describe "PUT reject" do
    it "updates the requested question" do
      question = Question.make!

      put :reject, {:id => question.to_param}
      question.reload.should be_rejected
    end

    it "redirects to questions#index" do
      question = Question.make!

      put :reject, {:id => question.to_param}
      response.should redirect_to(admin_questions_path)
    end

    it "informs the user if save fails" do
      question = Question.make!
      Question.any_instance.should_receive(:save).and_return false

      put :reject, {:id => question.to_param}
      response.should redirect_to(admin_questions_path)
      flash.should_not be_empty
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested question" do
      question = Question.create! valid_attributes
      expect {
        delete :destroy, {:id => question.to_param}
      }.to change(Question, :count).by(-1)
    end

    it "redirects to the questions list" do
      question = Question.create! valid_attributes

      delete :destroy, {:id => question.to_param}
      response.should redirect_to(admin_questions_path)
    end
  end

end
