require 'grit'
include Grit
module ApplicationHelper
  def build
    repo = Repo.new(Rails.root.to_s)
    "c." + repo.commits('HEAD',1).first.id.slice(0, 5).to_s
  end
  def user_for_embed
    if(user_signed_in?)
      {:email => current_user.email, :logouturl => destroy_user_session_path}.as_json.to_json
    else
      {:email => '', :logouturl => destroy_user_session_path}.as_json.to_json
    end
  end
end
