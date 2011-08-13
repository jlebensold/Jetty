class Administrator < User
  def default_values
    self.type = "Administrator"
  end
end
