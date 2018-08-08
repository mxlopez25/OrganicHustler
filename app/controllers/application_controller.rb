class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :get_browser

  def get_browser
    @browser = UserAgent.parse(request.env["HTTP_USER_AGENT"]).browser.eql?('Chrome') ? 'chrome' : 'safari'
  end
end
