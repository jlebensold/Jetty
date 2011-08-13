class Customer < User
  def default_values
    self.type = "Customer"
  end
end
