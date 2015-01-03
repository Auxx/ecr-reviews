class WelcomeController < ApplicationController

  def index
    Post.fetch_posts
    @body = 'OK'
  end

end
