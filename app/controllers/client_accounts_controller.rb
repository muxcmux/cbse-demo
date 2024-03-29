
class ClientAccountsController < ApplicationController
  
  layout 'user'
  
  
  before_filter :authenticate_user!
  
  
  # GET /accounts
  # GET /accounts.json
  def index
    @accounts = current_user.accounts.order(:created_at).page(params[:page] || 1)
    if params[:q].present?
      filtered = @accounts.where('name LIKE ? OR number LIKE ?', "%#{params[:q]}%", "%#{params[:q]}%")
      if filtered.blank?
        filtered = @accounts.joins(:user).where('firstname LIKE ? OR lastname LIKE ? OR email LIKE ? OR country LIKE ? OR city LIKE ? OR address LIKE ?', "%#{params[:q]}%", "%#{params[:q]}%", "%#{params[:q]}%", "%#{params[:q]}%", "%#{params[:q]}%", "%#{params[:q]}%")
      end
      @accounts = filtered
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @accounts }
    end
  end

  # GET /accounts/1
  # GET /accounts/1.json
  def show
    @account = Account.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @account }
    end
  end

  # GET /accounts/new
  # GET /accounts/new.json
  def new
    @account = Account.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @account }
    end
  end

  # GET /accounts/1/edit
  def edit
    @account = Account.find(params[:id])
  end

  # POST /accounts
  # POST /accounts.json
  def create
    @account = Account.new(params[:account])
    @account.user = current_user

    respond_to do |format|
      if @account.save
        format.html { redirect_to @account, notice: 'Account was successfully created.' }
        format.json { render json: @account, status: :created, location: @account }
      else
        format.html { render action: "new" }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /accounts/1
  # PUT /accounts/1.json
  def update
    @account = Account.find(params[:id])

    respond_to do |format|
      if @account.update_attributes(params[:account])
        format.html { redirect_to @account, notice: 'Account was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /accounts/1
  # DELETE /accounts/1.json
  def destroy
    @account = Account.find(params[:id])
    @account.destroy

    respond_to do |format|
      format.html { redirect_to accounts_url }
      format.json { head :no_content }
    end
  end
  
  def statement
    @account = Account.find params[:id]
    @transactions = @account.transactions.where('created_at BETWEEN ? AND ?', "#{params[:statement][:from]} 00:00:00", "#{params[:statement][:to]} 23:59:59").order('created_at desc')
    render 'accounts/statement', layout: 'statement'
  end
  
  
end
