require 'grit'
include Grit
module ApplicationHelper
  def build
    repo = Repo.new(Rails.root.to_s)
    "c." + repo.commits('HEAD',1).first.id.slice(0, 5).to_s
  end
  def user_for_embed
    if(user_signed_in?)
      {:logouturl => destroy_user_session_path, :email => current_user.email.to_s , :name => current_user.name.to_s }.as_json.to_json
    else
      {:logouturl => destroy_user_session_path, :email => '', :name => '' }.as_json.to_json
    end
  end
end
