class RentsController < ApplicationController
  before_action :set_item, only: %i[new create]
  def index
    @rents = policy_scope(Rent)
  end

  # alugar
  # def new
  #   @rent = Rent.new
  # end

  def create
    @rent = Rent.new(item: @item, user: current_user)
    authorize @rent
    @rent.item.rented = true
    @rent.save
    redirect_to rents_path, notice: "#{@item.name} was rent"
    # @rent.item = @item
    # @rent.user = current_user
    if @rent.save
      @item.rented = true
      @item.save
      @rent.item.rented = true
      redirect_to item_path(@item), notice: "#{@item.name} was rent"
    else
      render :new
    end
  end

  # cancelar compra

  def destroy
    @rent = Rent.find(params[:id])
    authorize @rent
    @item.rented = false
    @item.save
    @rent.destroy
    redirect_to item_path(@rent.item), notice: "#{@rent.item.name} foi devolvido"
  end

  private

  def set_item
    @item = Item.find(params[:item_id])
  end
end
