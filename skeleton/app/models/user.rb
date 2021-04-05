class User < ApplicationRecord

    validates :user_name, :session_token, presence: true, uniqueness: true 
    validates :password_digest, presence: true 
    validates :password, length: {minimum: 6, allow_nil: true}

    attr_reader :password

    def self.find_by_credentials(user_name, password)
        user = User.find_by(user_name: user_name)
        if user && user.is_password?(password)
            user 
        else
            nil 
        end
    end

    def reset_session_token!
        self.session_token = SecureRandom::urlsafe_base64(16)
        self.save!
        self.session_token
    end

    def password=(password)
        @password = password 
        self.password_digest = BCrypt::Password.create(password)
    end

    def is_password?(password)
        BCrypt::Password.new(self.password_digest).is_password?(password)
    end

end