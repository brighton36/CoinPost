class ItemsController < ApplicationController
  NEW_STEPS = [:new, :add_images, :preview]

  filter_access_to :show, :edit, :update, :destroy, :disable, :edit_images, 
    :update_images, :relist, :submit_to_reddit, :view_created, :attribute_check => true
  filter_access_to :all

  respond_to :html

  before_filter :item_from_params, :only => (NEW_STEPS + [:create])

  # This is a very weird new action, and it's composed of three 'steps'
  # depending on how many mistakes the user makes, we end up rendering
  # views that don't correspond to the requested action.
  def new
    respond_with @item do |format|
      flash.clear
      @render_action = case
        when !params.has_key?(:item) then :new
        when !@item.valid?
          render_action = ( @item.errors[:images].try(:length) > 0 ) ? 
            :add_images : :new
          flash[:error] = t('flash.items.%s.alert' % render_action.to_s)
          render_action
        else
          action_name 
      end

      format.html{ render :action => @render_action }
    end
  end

  NEW_STEPS.each{|new_step| alias_method new_step, :new if new_step != :new}

  def relist
    original_categories = @item.categories
    original_images = @item.images

    @item = @item.dup
    @item.set_default_values(true)
    @item.categories = original_categories
 
    # Get rid of any lingering images that aren't committed to an object: 
    ItemImage.in_item_for_user(current_user, nil).each{|image| image.destroy}

    # Now create the new ones:
    original_images.each do |oimg|
      new_img = ItemImage.new(
        :image => File.open([Rails.root,'/public',oimg.image.to_s].join) )

      new_img.creator = current_user
      new_img.save
    end

    respond_with @item do |format|
      format.html{ render :action => :new }
    end
  end

  def create
    if !@item.save
      respond_with @item do |format|
        flash[:error] = t('flash.items.create.alert')
        format.html { render :action => :new }
      end
    else
      redirect_to created_item_url(@item)
    end
  end

  def view_created
    respond_with @item do |format|
      format.html{render}
    end
  end

  def edit
    respond_with @item do |format|
      format.html
    end
  end

  def update
    respond_with @item do |format|
      if @item.update_attributes(sanitized_item_params(params))
        flash[:notice] = t('flash.items.update.notice')
        format.html { redirect_to dashboard_index_path }
      else
        flash[:error] = t('flash.items.update.alert')
        format.html { render :action => :edit }
      end
    end
  end

  def destroy
    respond_with @item do |format|
      if @item.destroy
        flash[:notice] = t('flash.items.destroy.notice')
      else
        flash[:error] = t('flash.items.destroy.alert')
      end
      
      format.html { redirect_to dashboard_index_path }
    end
  end
  
  def disable
    @item.enabled = false

    respond_with @item do |format|
      if @item.save
        flash[:notice] = t('flash.items.disable.notice')
      else
        flash[:error] = t('flash.items.disable.alert')
      end
      
      format.html { redirect_to dashboard_index_path }
    end
  end

  def show
    @user = current_user
    respond_with @item do |format|
      format.html{ render }
    end
  end
  
  def edit_images
    respond_with @item do |format|
      format.html{ render }
    end
  end
  
  def update_images
    respond_with @item do |format|
      flash[:notice] = t('flash.items.update_images.notice')
      format.html { redirect_to dashboard_index_path }
    end
  end

  # This really isn't the best code. But I'm not sure if this will even last, 
  # so I'm just fleshing it out quickly for now. Plus, the Snoo library is a 
  # little unspectacular and buggy for submissions.
  def submit_to_reddit
    t_scope = [:items, :submit_to_reddit]
    ret = {}

    @errors = {}
    [:username, :password].each do |attr|
      @errors[attr] = [t('%s.is_missing' % attr, :scope => t_scope)] if (
        params.try(:[],:reddit).try(:[],attr).blank? )
    end

    if @errors.length == 0
      begin
        reddit = Snoo::Client.new :useragent => 'Coinpost WTB poster v1.0 by /u/cptest', 
          :cookies => nil, :modhash => nil, :username => nil, :password => nil

        reddit.set_cookies ''
        login_resp = reddit.log_in params[:reddit][:username], params[:reddit][:password]

        submit_errors = login_resp['json']['errors']
        unless submit_errors.try(:length) > 0
          submit_url = if Rails.env.production?
            item_url @item, :only_path => false
          else
            r = Net::HTTP.get_response(URI::parse('http://www.randomwebsite.com/cgi-bin/random.pl'))
            r.header['location']
          end

          submit_opts = { :url => submit_url }
          unless params[:reddit][:iden].empty? and params[:reddit][:captcha].empty?
            submit_opts.merge!({:iden => params[:reddit][:iden], 
              :captcha => params[:reddit][:captcha] })
          end

          submit_resp = reddit.submit '[WTS] %s' % @item.title, 
            (Rails.env.production?) ? 'bitmarket' : 'test' , submit_opts

          submit_errors = submit_resp['json']['errors']

          submit_errors.reject!{|err| err[0] == 'BAD_CAPTCHA'}

          ret[:captcha_iden]= submit_resp.try(:[],'json').try(:[],'captcha')
          if ret[:captcha_iden]
            ret[:error_banner] = t('general.attribute_errors', :scope => t_scope)
            @errors[:captcha] = [t('captcha.needs_solving', :scope => t_scope)]
          end

          if submit_resp['json'].try(:[],'data').try(:[],'url')
            @item.reddit_url = submit_resp['json']['data']['url']
            @item.save!

            if params[:reddit][:remember_password] == '1'
              current_user.reddit_username = params[:reddit][:username]
              current_user.reddit_password = params[:reddit][:password]
              current_user.save!
            elsif params[:reddit][:remember_password].nil?
              current_user.reddit_username = nil
              current_user.reddit_password = nil
              current_user.save!
            end
          end
        end

        if submit_errors.try(:length) > 0
          raise StandardError, submit_errors.collect{|err| err.join(': ')}.join(',')
        end

        RedditSubmission.activity(current_user, @item, params[:reddit][:username], 
          login_resp, submit_resp).deliver

      rescue => e
        logger.error "Reddit Submission Error:" + e.inspect
        RedditSubmission.fail(current_user, @item, e.message.to_s).deliver

        if e.message == 'invalid password'
          ret[:error_banner] = t 'general.invalid_credentials', :scope => t_scope
        else
          ret[:error_banner] = t 'general.unhandled_exception', :scope => t_scope, 
            :message => e.message
        end
      end
    end

    if @errors.length > 0
      ret[:error_banner] = t('general.attribute_errors', :scope => t_scope)
      ret[:errors] = @errors
    end

    respond_with @item do |format|
      format.js do
        if ret[:error_banner]
          render :json => ret, :status => 422
        else
          render :json => true
        end
      end
    end
  end

  private

  # All we really do here (for now?) is figure out which currency is going to be
  # pulled from the params
  def sanitized_item_params(p)
    item = p[:item].dup if p.has_key? :item

    if item
      # This ensures that we only set either a (currency) price, or a btc price. 
      # Not both:
      choosen_currency = %w(item price_in_currency currency).inject(params){|ret, k| 
        ret.try(:[], k.to_sym) } 
      
      {'USD' => :price_in_btc, 'BTC' => :price_in_currency}.each_pair do |cur, del_attr|
        item.delete del_attr if choosen_currency == cur && item.try(:has_key?,del_attr)
      end if choosen_currency
    end

    item
  end

  def item_from_params
    @item = Item.new sanitized_item_params(params)

    @item.creator = current_user
    %w(location btc_receive_address).each do |attr|
      @item.send '%s=' % attr, current_user.send(attr) unless (
        params[:item].try :has_key?, attr )
    end
    
    @item.images = ItemImage.in_item_for_user current_user, nil
  end

end
