class User < ApplicationRecord
  attr_accessor :remember_token
  before_save { self.email = email.downcase }
  
  has_many :orders, dependent: :destroy
  validates :name, presence: true
  validates :name_kana, presence: true

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: true 
  
  VALID_PHONE_NUMBER_REGEX = /\A0(\d{1}[-(]?\d{4}|\d{2}[-(]?\d{3}|\d{3}[-(]?\d{2}|\d{4}[-(]?\d{1})[-)]?\d{4}\z|\A0[5789]0[-]?\d{4}[-]?\d{4}\z/
                            
  validates :tellnumber, presence: true, format: { with: VALID_PHONE_NUMBER_REGEX }

  has_secure_password
  validates :password, presence: true, length: { minimum: 8 }, allow_nil: true

  def User.digest(string)
    cost = 
      if ActiveModel::SecurePassword.min_cost
        BCrypt::Engine::MIN_COST
      else
        BCrypt::Engine.cost
      end
    BCrypt::Password.create(string, cost: cost)
  end

  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def authenticated?(remember_token)
    # ダイジェストが存在しない場合はfalseを返して終了します。
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  scope :customerUsers, -> { where(employee: false).order(id: :asc)}
  scope :employeeUsesrs, -> { where(employee: true).order(id: :asc)}

 
  #本日のデータ全体
  def todayOrder
    orders.where(order_date: Date.today)
  end

  #本日のデータ依頼中のデータ
  def todayInOrders
    orders.where(order_date: Date.today).where(status: :in_order)
  end

   #本日のデータ加工済みのデータ
   def todayInProcesss
    orders.where(order_date: Date.today).where(status: :processed)
  end

   #本日の渡済み済みのデータ
   def todayDeliveryOrders
    orders.where(order_date: Date.today).where(status: :delivery)
  end
  
  #買い物かごに入れたものを抽出
  def user_buyings(buys)
    buyings = []

    buys.each do |buy|
      buyInstance = self.orders.new(
        name: buy[:name],
        process: buy[:process],
        price: buy[:price],
        num: buy[:num]
      )
      buyings.push(buyInstance)
    end
    return buyings
  end

end

