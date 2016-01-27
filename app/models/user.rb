class User < ActiveRecord::Base
  
  has_many :products,   dependent: :destroy

  before_save { self.login_id = login_id.downcase }
  validates :login_id, presence: true, length: { maximum: 30 },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: {minimum: 4}, allow_nil: true
  
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
end
