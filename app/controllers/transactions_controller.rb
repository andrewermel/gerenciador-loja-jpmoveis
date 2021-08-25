class TransactionsController < ApplicationController
  before_action :set_transaction, only: %i[ show edit update destroy ]

  # GET /transactions or /transactions.json
  def index
    @transactions = filter_transactions
  end

  # GET /transactions/1 or /transactions/1.json
  def show
  end

  # GET /transactions/new
  def new
    @transaction = Transaction.new
  end

  # GET /transactions/1/edit
  def edit
  end

  # POST /transactions or /transactions.json
  def create

    @transaction = Transaction.new(transaction_params)
   
    if params[:transaction_type] == "buy"
      @transaction.price_per_unity *= -1
    end

    respond_to do |format|
      if @transaction.save
        update_inventory
        format.html { redirect_to @transaction, notice: "Transaction was successfully created." }
        format.json { render :show, status: :created, location: @transaction }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /transactions/1 or /transactions/1.json
  def update
    respond_to do |format|
      if @transaction.update(transaction_params)
        format.html { redirect_to @transaction, notice: "Transaction was successfully updated." }
        format.json { render :show, status: :ok, location: @transaction }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /transactions/1 or /transactions/1.json
  def destroy
    @transaction.destroy
    respond_to do |format|
      format.html { redirect_to transactions_url, notice: "Transaction was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transaction
      @transaction = Transaction.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def transaction_params
      params.require(:transaction).permit(:quantity, :price_per_unity, :product_id, :user_id)
    end

    def update_inventory
      #procurando no inventario o intem vendido
      inventory = Inventory.find_by_product_id(@transaction.product_id)
      if inventory.nil?
        inventory = Inventory.new(product_id: @transaction.product_id, quantity:0)
      end

      if params[:transaction_type]=="buy"
        inventory.quantity += @transaction.quantity
      else
        inventory.quantity -= @transaction.quantity
      end
      inventory.save
    end

    def filter_transactions
      return Transaction.all unless params[:transaction_type].present?
      return Transaction.where('price_per_unity <= 0') if params[:transaction_type]=='buy'
      Transaction.where('price_per_unity > 0')
    end
end
