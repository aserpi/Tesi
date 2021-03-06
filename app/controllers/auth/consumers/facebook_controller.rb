# Sign in with and disconnect a Facebook account.
class Auth::Consumers::FacebookController < ApplicationController
  # Connects a Facebook account with an existing account when a user logs in.
  def connect_existing
    authorize :facebook
    @consumer = Consumer.find_by(username: params[:username])

    if @consumer.nil? || !@consumer.valid_password?(params[:password])
      flash.now[:alert] = I18n.t(:incorrect_credentials)
      render :connect and return
    end

    @consumer.facebook_connect(session['devise.facebook_data'])
    session.delete 'devise.facebook_data'

    flash[:success] = I18n.t(:connected, scope: [:facebook])
    sign_in_and_redirect @consumer
  end

  # Removes the Facebook info from the +current_user+'s account.
  def disconnect
    authorize :facebook

    current_consumer.facebook_disconnect

    flash[:success] = I18n.t(:disconnected, scope: [:facebook])
    redirect_to edit_registration_path(current_consumer)
  end

  # Creates a new account from the Facebook info and the parameters inserted through a form.
  # If the email is provided manually it must be confirmed before accessing the site.
  def select_username
    authorize :facebook

    @consumer = Consumer.from_omniauth(session['devise.facebook_data'], select_username_params)
    @consumer.save or
      return render :connect

    session.delete 'devise.facebook_data'
    flash[:success] = I18n.t :connected, scope: [:facebook]
    sign_in_and_redirect @consumer
  end

  private

  def select_username_params
    params.permit(:username, :email, :password, :password_confirmation)
  end
end
