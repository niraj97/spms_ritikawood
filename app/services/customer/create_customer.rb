class CreateCustomer < ActiveInteraction::Base
  # Logic for creating customers
  string :name
  string :contact
  string :address
  integer :user_id

  def execute
    customer = Customer.new(name: name, contact: contact, address: address, user_id: user_id)
    unless customer.save
      self.errors.merge!(customer.errors)
      return
    end
    { id: customer.id }
  end
end
