# app/controllers/customers_controller.rb
class CustomersController < ApplicationController
  def index
    params[:filters] ||= {} # Ensure filters exist in params
    params[:filters][:user_id] = current_user.id
    list_customers = ListCustomers.run(params) # Run ListCustomers with provided params
    if list_customers.valid?
      @customers = list_customers.result[:list] # Access the list of customers
    else
      flash.now[:alert] = 'Error fetching customers' # Set a flash alert in case of an error
      @customers = [] # Set an empty array or handle errors as per your requirement
    end
  end

  def create
    params[:user_id] = current_user.id
    puts params
    customer = CreateCustomer.run(params) # Run ListCustomers with provided params
    if customer.valid?
      @customer = customer.result # Access the list of customers
    else
      flash.now[:alert] = 'Invalid input' # Set a flash alert in case of an error
      render json: { errors: customer.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    customer = UpdateCustomer.run(params)
    if customer.valid?
      @customer = customer.result # Access the list of customers
    else
      flash.now[:alert] = customer.errors.full_messages # Set a flash alert in case of an error
      @customer = [] # Set an empty array or handle errors as per your requirement
    end
  end

  def edit
    @customer = Customer.find(params[:id])
  end

  def show
    # Logic to fetch and display a single customer by ID
    @customer = Customer.find(params[:id])
    render json: {result: @customer}, status: :ok
  end

  def proposals
    @customer = Customer.find(params[:id])
    @proposals = @customer.proposals
  end
end
