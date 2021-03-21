class Customer::OrdersController < ApplicationController
  add_flash_types :success, :info, :warning, :danger
  before_action :set_order, only: %i[ index  edit update destroy  ]

  def index
  end

  def confirm
    @user = User.find(params[:user_id])
    @order = Order.new
    @orders = Order.all
    @items = Item.all.descendingOrder
   
    confirm_data(params)
  end

  def create
    
    confirm_data(params)

    @user = User.find(params[:user_id])
    params[:orders].each do |param|
      @user.orders.create(
        name: param[:name],
        process: param[:process],
        price: param[:price],
        num: param[:num],
        order_date: params[:order_date],
        order_time: params[:order_time].in_time_zone,
        order_date_details: DateTime.now
      )
    end     

    if params[:order_time] == ""
      flash[:danger] = "受け取り時間を選択してください。"
      render :confirm   
      else
      redirect_to customer_user_orders_url(@user.id), success: '商品を確定しました。' 
  
    end
      
  end

   def update
   end

  def show
    @user = User.find(params[:user_id])
    @order = Order.find(params[:user_id])
    @orders = Order.all
 
    @sOrder = Order.where(user_id: @user.id).where('order_date >=?', Date.current).where('order_time >=?', Date.current).where(status: 1).last
    @smOrder = Order.where(user_id: @user.id).where('order_date >=?', Date.current).where('order_time >=?', Date.current).where(status: 1)
  end


  private

  def set_order
    @order = Order.find(params[:id])
  end

  def confirm_data(params)
    @user = User.find(params[:user_id])
    buy_cart_page_parameter=[
      {name: "さんま",
        process: "切り身",
        price: 150,
        num: 5
      },
      {
        name: "いか",
        process: "切り身",
        price: 120,
        num: 2
      }
    ]
    @buyings = @user.user_buyings(buy_cart_page_parameter)
    @allTotal = Order.sumPrises(@buyings)
  end

end
