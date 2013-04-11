class CustomersController < ApplicationController
  def new
    @customer = Customer.new
    render :layout => false
  end

  def index
    @customers = Customer.page(params[:page]).order('created_at DESC')
  end

  def edit
    @customer = Customer.find(params[:id])
    render :layout => false
  end

  def show
    @customer = Customer.find(params[:id])
    render :layout => false
  end

  def update
    @customer = Customer.find(params[:id])

    if @customer.blank?
      flash[:error]  = "Invalid edit record"
      redirect_to customers_path
    end
    success = @customer.update_attributes(params[:customer])
    SFactory.all_customers(true)  #update the locally maintained customers list from db

    if success && @customer.errors.empty?
      flash[:notice] = "Customer edited successfully..."
      redirect_to customers_path
    else
      flash[:error]  = "We couldn't set up that account, sorry.  Please try again."
      render :edit
    end
  end

  def create
    @customer = Customer.new(params[:customer])
    success = @customer && @customer.save
    SFactory.all_customers(true)  #update the locally maintained customers list from db

    if success && @customer.errors.empty?
      redirect_to customers_path
      flash[:notice] = "Customer added successfully..."
    else
      flash[:error]  = "We couldn't set up that account, sorry.  Please try again."
      render :action => 'new'
    end
  end

  def search
    @customers = Customer.where("company_name LIKE ? OR first_name LIKE ? OR last_name LIKE ?", *["%#{params[:q]}%"]*3).page(params[:page]).order('created_at DESC')
  end
end
