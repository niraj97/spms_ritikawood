class ProposalsController < ApplicationController
  # ...
  before_action :set_customer

  def show
    # Logic to fetch and display a single customer by ID
    @customer = Customer.find(params[:id])
    @proposals = @customer.proposals
    render json: {result: @proposals}, status: :ok
  end

  def index
    params[:filters] ||= {} # Ensure filters exist in params
    
    list_customers = ListProposals.run(params) # Run ListCustomers with provided params
    if list_customers.valid?
      @customers = list_customers.result[:list] # Access the list of customers
    else
      flash.now[:alert] = 'Error fetching customers' # Set a flash alert in case of an error
      @customers = [] # Set an empty array or handle errors as per your requirement
    end
  end

  def create
    @proposal = @customer.proposals.build(proposal_params) # Create a new proposal associated with the customer

    # Attach the uploaded file to the proposal
    @proposal.pdf_file.attach(params[:proposal][:pdf_file])

    if @proposal.save
      redirect_to proposals_customer_path(@customer), notice: 'Proposal was successfully created.'
    else
      render :new
    end
  end

  # Ensure strong params for uploading PDF file
  private

  def set_customer
    @customer = Customer.find(params[:proposal][:customer_id])
  end

  def proposal_params
    params.require(:proposal).permit(:other_attributes, :pdf_file)
  end
end