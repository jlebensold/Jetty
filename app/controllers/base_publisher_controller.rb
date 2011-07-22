class BasePublisherController < ApplicationController
  before_filter :authenticate_user!, :except => ['show']
  layout "publishers"

end
