# Start w/sample Twitter client code by Steve Ross, http://sxross-blog.herokuapp.com/
class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    window.makeKeyAndVisible
    true
  end
  
  def window
    @window ||= begin
      w = UIWindow.alloc.initWithFrame UIScreen.mainScreen.bounds
      @controller = TweetViewController.new
      w.rootViewController = @controller
      w
    end
  end
end

class TweetViewController < UITableViewController
  @@cell_identifier = nil
  
  def viewWillAppear(animated)
    super
    self.view.backgroundColor = UIColor.whiteColor
    @feed = []
    timer_fired(self)
    @timer = NSTimer.scheduledTimerWithTimeInterval(2, 
          target:self, 
          selector:'timer_fired:', 
          userInfo:nil, repeats:true)
  end
  
  def viewWillDisappear(animated)
    @timer.valid = false
    @timer = nil
  end

  def timer_fired(sender)
    @twitter_accounts = %w(dhh google)
    query = @twitter_accounts.map{ |account| "from:#{account}" }.join(" OR ")
    url_string = "http://search.twitter.com/search.json?q=#{query}"
    
    error_ptr = Pointer.new(:object)
    BW::HTTP.get(url_string) do |response|
      parsed = response.body.to_str.objectFromJSONStringWithParseOptions(
        JKParseOptionValidFlags, 
        error: error_ptr
        )
      if parsed.nil?
        error = error_ptr[0]
        puts error.userInfo[NSLocalizedDescriptionKey]
        @timer.valid = false
      else
        parsed.each do |item|
          puts item.inspect
        end
      end
    end
  end

  def tableView(tableView, numberOfSectionsInTableView:section)
    1
  end
  
  def tableView(tableView, numberOfRowsInSection:section)
    1
  end
  
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier(cell_identifier)
    
    if not cell
      cell = UITableViewCell.alloc.initWithStyle UITableViewCellStyleValue2, 
                                    reuseIdentifier:cell_identifier
      cell.textLabel.text = 'hello'
    end

    cell
  end
  
  def cell_identifier
    @@cell_identifier ||= 'TwitterTableViewCell'
  end
end
