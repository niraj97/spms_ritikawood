class CreateCustomer < ActiveInteraction::Base
  # Logic for creating customers
  string :email
  string :password
  string :password_confirmation

  def execute
    puts params.inspect
    if self.password != self.password_confirmation
      self.errors.add(:password, "does not match")
      return
    end

    user = User.new(email: email, password: password)
    unless user.save
      self.errors.merge!(user.errors)
      return
    end

    { id: user.id }
  end
end
