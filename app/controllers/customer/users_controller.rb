class Customer::UsersController < Customer::MainController
	# before_action :logged_in_user, only: [:show, :edit, :update]
 	
  def show
    @user = User.find(params[:id])
    redirect_to employee_user(@user) if @user.employee?

    # 受け取り時間基準/受け取り未の注文の表示のためのグループ化と並べ替え
    unfinished_order = Order.unfinished_order(@user.id)
    @in_unfinished_order = unfinished_order.sort

    # 注文日基準/ご注文履歴の表示のためのグループ化と並べ替え
    finieshed_order = Order.finieshed_order(@user.id)
    @in_finished_order = finieshed_order.sort
	end

	def new
    @user = User.new
	end

	def edit
    @user = User.find(params[:id])
    
	end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to top_show_url, success: '新規登録に成功しました。'
    else
      render :new
    end
  end

	def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      redirect_to customer_user_url(@user), success: "お客様情報を更新しました。"
    else
      render :edit      
    end
	end

  

  private

    def user_params
      params.require(:user).permit(:name, :name_kana, :tellnumber, :email, :password, :password_confirmation, :employee)
    end
    
end