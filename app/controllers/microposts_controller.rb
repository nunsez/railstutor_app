class MicropostsController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy]
  before_action :correct_user, only: :destroy

  def create
    @micropost = current_user.microposts.build(micropost_params)

    if @micropost.save
      flash[:success] = 'Micropost created!'
      redirect_to root_path, status: :see_other
    else
      @feed_items = current_user.feed.page(params[:page])
      render 'static_pages/home'
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = 'Micropost has been deleted.'
    redirect_to request.referrer || root_path, status: :see_other
  end

  private

  def micropost_params
    params.require(:micropost).permit(:content, :picture)
  end

  def correct_user
    @micropost = current_user.microposts.find_by_id params[:id]
    redirect_to root_path, status: :see_other unless @micropost
  end
end
