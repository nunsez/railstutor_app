class RelationshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    user = User.find_by_id params[:followed_id]
    current_user.follow user
    redirect_to user, status: :see_other
  end

  def destroy
    user = Relationship.find_by_id(params[:id]).followed
    current_user.unfollow user
    redirect_to user, status: :see_other
  end
end
