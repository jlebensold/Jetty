require 'grit'
include Grit
module ApplicationHelper
  def build
    repo = Repo.new(Rails.root.to_s)
    "c." + repo.commits('HEAD',1).first.id.slice(0, 5).to_s
  end

end
