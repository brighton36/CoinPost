class UsersController < ApplicationController
  filter_access_to :all

  def show
    @user = User.find params[:id]
    @message = Message.new
    @feedback = Purchase.with_feedback_for @user
  end
end
