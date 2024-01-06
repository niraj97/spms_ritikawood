class UpdateCustomer < ActiveInteraction::Base
  # Logic for creating customers
  integer :id
  string :name, default: nil
  string :contact, default: nil
  string :address, default: nil

  def execute
    customer = Customer.where(id: self.id).take
    if customer.blank?
      self.errors.add(:customer, 'not present')
      return
    end

    unless customer.update(get_update_params)
      self.errors.merge!(customer.errors)
      return
    end


    return { id: customer.id }
  end

  def get_update_params
    @_interaction_inputs.except(:id)
  end
end
