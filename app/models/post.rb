class Post < ActiveRecord::Base

  def self.fetch_posts
    Post.fetch_batch(nil, nil)
  end

  def self.process_entry(entry)
    if entry['kind'] === 't3'
      data = entry['data']
      found = Post.find_by_reddit_id(data['id'])
      if found.nil?
        post = Post.new({:title => data['title'],
            :author => data['author'],
            :posted_at => Time.at(data['created']).to_datetime,
            :reddit_id => data['id'],
            :url => data['url']})
        post.save
      end
    end
  end

  def self.fetch_batch(before, after)
    params = {:q => 'flair:review', :restrict_sr => 'on', :sort => 'new', :t => 'all'}
    params[:before] = before unless before.nil?
    params[:after] = after unless after.nil?

    response = Faraday.get('http://www.reddit.com/r/ecr_eu/search.json', params)
    json = ActiveSupport::JSON.decode(response.body)

    if json['kind'] === 'Listing'
      json['data']['children'].each {|entry|
        Post.process_entry(entry)
      }

      if !json['data']['after'].nil?
        sleep(1)
        Post.fetch_batch(json['data']['before'], json['data']['after'])
      end
    end
  end

end
