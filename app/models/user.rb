class User < ActiveRecord::Base
  attr_reader :password
  
  validates :username, :email, :password_digest, presence: true
  validates :username, :email, :session_token, uniqueness: true
  validates :password, length: { minimum: 6, allow_nil: true }
  validates :password, confirmation: true

  after_initialize :ensure_session_token
  
  def User.find_by_credentials(email, password)
    user = User.find_by(email: email)
    user && user.is_password?(password) ? user : nil
  end
    
  def ensure_session_token
    self.session_token ||= generate_session_token
  end

  def reset_session_token!
    self.session_token = generate_session_token
    self.save!
    self.session_token
  end

  def generate_session_token
    token = SecureRandom::urlsafe_base64
    
    if User.where(session_token: token).blank?
      token
    else
      generate_session_token
    end
  end
  
  def password=(password)
    return nil if password.nil?
    self.password_digest = BCrypt::Password.create(password)
    @password = password
  end
  
  def is_password?(password)
    BCrypt::Password.new(password_digest).is_password?(password)
  end
end
