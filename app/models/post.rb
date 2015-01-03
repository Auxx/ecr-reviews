class Post < ActiveRecord::Base

  def self.fetch_posts
    response = Faraday.get('http://www.reddit.com/r/ecr_eu/search.json', {:q => 'flair:review', :restrict_sr => 'on', :sort => 'new', :t => 'all'})
    response.body
  end

end
