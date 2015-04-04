class User < ActiveRecord::Base
  attr_reader :password
  
  validates :username, :email, :password_digest, presence: true
  validates :username, :email, :session_token, uniqueness: true
  validates :password, length: { minimum: 6 }

  after_initialize :ensure_session_token
  
  def ensure_session_token
    self.session_token ||= generate_session_token
  end

  def reset_session_token!
    self.session_token = generate_session_token
    
    until User.where(session_token: self.session_token).blank? do
      self.session_token = generate_session_token
    end
    
    self.save!
    self.session_token
  end

  def generate_session_token
    SecureRandom::urlsafe_base64
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
