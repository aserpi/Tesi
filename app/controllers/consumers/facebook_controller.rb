class Consumers::FacebookController < ApplicationController
  include Accessible
  # before_action :configure_permitted_parameters

  def connect
  end

  def connect_existing
    @consumer = Consumer.find_by username: params[:username]
    if @consumer.nil? or not @consumer.valid_password? params[:password]
      flash.now[:error] = 'Incorrect username or password'
      render 'connect'
    else
      @consumer.provider = session['devise.facebook_data']['provider']
      @consumer.uid = session['devise.facebook_data']['uid']
      @consumer.save!
      sign_in_and_redirect @consumer
    end
  end

  def select_username
    username = params[:username]
    begin
      @consumer = Consumer.from_omniauth session['devise.facebook_data'], username
      sign_in_and_redirect @consumer
    rescue
      flash.now[:error] = 'Username already taken'
      render 'connect'
    end
  end
end