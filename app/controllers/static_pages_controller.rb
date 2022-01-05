class StaticPagesController < ApplicationController
  def about
  end

  def contact
  end

  def help
  end

  def home
    if logged_in?
      page = params[:page]
      @micropost = current_user.microposts.build
      @feed_items = current_user.feed.page(page)
    end
  end
end
