
class ChatController < ApplicationController
  protect_from_forgery :except => :auth

  def send_message
    Pusher['presence-chat-room'].trigger('message-recieved', params)
    head :ok
  end

  def get_gravatar_url(eml)
    #eml = params[:email]
    puts "\n\n#{eml}\n\n"
    hsh = Digest::MD5.hexdigest(eml)
    url = "http://www.gravatar.com/avatar/#{hsh}.jpg"
    #render :json => {gravatarUrl: url}
  end

  def login
    session[:name] = params[:name]
    session[:email] = params[:email]
    session[:gravatar_url] = get_gravatar_url(params[:email])
    render :json => {gravatarUrl: session[:gravatar_url]}
  end

  def auth
    puts "\n\n\n#{session[:name]}::#{session[:email]}::#{session[:gravatar_url]}"
    _response = Pusher[params[:channel_name]].authenticate(params[:socket_id], {
      :user_id => rand(Time.now.to_i),
      :user_info => {
        name:         session[:name],
        email:        session[:email],
        gravatar: session[:gravatar_url]
      }
    })
    render :json => _response
  end

end
