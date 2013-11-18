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
