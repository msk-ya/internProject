class Customer::BasketsController < ApplicationController
  before_action :setUser, only: [ :create, :edit, :update, :destroy ]

  def show
    @product = Product.find_by(id: params[:product_id])
    @item = Item.find_by(name: @product.name)
    @process = Processing.where(item_id: @item.id)
  end

  def create
    product = Product.find_by(name: params[:name])
    already_basket = Basket.find_by(user_id: params[:id], name: params[:name], process: params[:process])

    if already_basket.present?
      already_basket.num += 1
      already_basket.save
    else
      basket = Basket.new
      basket.name = product.name
      basket.price = product.price
      basket.process = params[:process]
      basket.user_id = params[:id]
      basket.in_basket_at = DateTime.now
      basket.num = 1
      basket.save
    end
    redirect_to edit_customer_basket_path(@user)
  end

  def edit
    @baskets = Basket.in_basket_order(@user.id)
  end

  def update
    @user = User.find(params[:id])
    @baskets = Basket.all
    if params[:page_next_update].present?
      basket_parameters.each do |key, item|
        basket = Basket.find_by(id: key)
        unless basket.num == item[:num]
          basket.num = item[:num]
          basket.save
        end
      end
      flash[:success] = "数量変更を保存しました。"
      redirect_to edit_customer_basket_url(@user)
    else
      basket_parameters.each do |key, item|
        basket = Basket.find_by(id: key)
        unless basket.num == item[:num]
          basket.num = item[:num]
          basket.save
        end
      end
      flash[:success] = "数量変更を保存しました。"
      redirect_to edit_customer_basket_url(@user)
    end

  end

  def destroy
    Basket.find_by(id: params[:basket_id]).destroy
    redirect_to edit_customer_basket_url(@user)
  end

  private

  def basket_parameters
    params.require(:basket).permit(basket: [:num, :name, :b_id, :page_next_update,:page_save_update])[:basket]
  end

  def setUser
    @user = User.find(params[:id])
  end
end
