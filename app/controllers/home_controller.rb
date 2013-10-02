class HomeController < ApplicationController
  filter_access_to :all
  
  JSON_ACTIONS = [:ask_question]

  respond_to :html, :except => JSON_ACTIONS
  respond_to :json, :only   => JSON_ACTIONS

  caches_action :index, :expires_in => 5.minutes, :layout => false

  def index
    @items_ending_soon = Item.purchaseable.order('items.expires_at ASC').includes(:images).limit 6
  end

  def get_coins
  end

  def about_us
  end

  def help
    @coinpost_admin = User.site_admin if current_user
  end

  # This isn't too great an implementation, but it's something for now. The logged
  # in users have a better interface.
  def ask_question
    @errors = {} 
    %w(subject body).each{ |attr|
      @errors[attr] = ["can't be blank"] if params[:message][attr].empty? }

    @errors['from_email'] = ['is an invalid email address'] unless ( 
      /^([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})$/i.match params[:message][:from_email] )

    respond_to do |format|
      if @errors.empty?
        ContactMailer.contact_us( 
          *[:from_email, :subject,:body].collect{|attr| params[:message][attr]}+
          [ request.env['HTTP_USER_AGENT'], request.env['REMOTE_ADDR'] ] 
        ).deliver

        format.json { render :json => true }
      else
        format.json { render :json => {:errors => @errors}, :status => 422 }
      end
    end
  end
end
