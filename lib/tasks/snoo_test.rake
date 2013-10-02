namespace :coinpost do
  desc 'Test the reddit/snoo library'
  task :test_snoo => :environment do
    @title = 'Testing snoo'
    @subreddit = 'test'
    @url = 'http://www.ebay.com/itm/CHINESE-HANDWORK-CARVING-FLOWER-OLD-RED-SAND-TEA-POT-/171005313124?pt=UK_Collectables_Kitchenalia_RL&hash=item27d0b60064'
    @text = 'Make yourself some damn tea'

    reddit = Snoo::Client.new :useragent => 'Coinpost WTB poster v1.0 by /u/cptest'

    puts "Login"
    # Log into reddit
    ret = reddit.log_in 'cptest', 'sn00!'
    puts "Errors:"+ret['json']['errors'].inspect

    puts "Submit"

    ret = reddit.submit @title, @subreddit, :url => @url, :text => @text
    # puts ret.inspect

    puts "Errors:"+ret['json']['errors'].inspect
    # The iden should be here: http://www.reddit.com/captcha/[captcha].png 
    
    # Captcha
    captcha_iden = ret['json']['captcha']

    puts 'Captcha : http://www.reddit.com/captcha/%s.png' % captcha_iden
    captcha_val = STDIN.gets.strip

    puts "Retrying submit with captcha:" + captcha_val.inspect
    ret = reddit.submit @title, @subreddit, :url => @url, :text => @text, 
      :iden => captcha_iden, :captcha => captcha_val
    puts "ret" + ret.inspect
    puts "Errors:"+ret['json']['errors'].inspect

    # Here's a success
    #<HTTParty::Response:0x4f709c8 parsed_response={"json"=>{"errors"=>[], "data"=>{"url"=>"http://www.reddit.com/r/test/comments/1ahc5i/testing_snoo/", "id"=>"1ahc5i", "name"=>"t3_1ahc5i"}}}, @response=#<Net::HTTPOK 200 OK readbody=true>, @headers={"content-type"=>["application/json; charset=UTF-8"], "cache-control"=>["no-cache"], "pragma"=>["no-cache"], "server"=>["'; DROP TABLE servertypes; --"], "date"=>["Sun, 17 Mar 2013 20:18:58 GMT"], "content-length"=>["140"], "connection"=>["close"]}>
    

    puts "Logout"
    # Log back out of reddit
    reddit.log_out
  end
end
