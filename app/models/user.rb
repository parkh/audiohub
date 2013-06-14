class User < ActiveRecord::Base
  has_many :audios, dependent: :destroy
  has_many :friendships
  has_many :friends, :through => :friendships
  has_many :inverse_friendships, :class_name => "Friendship", :foreign_key => "friend_id"
  has_many :inverse_friends, :through => :inverse_friendships, :source => :user

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def self.search(search)
    if search
      where('email LIKE ?', "%#{search}%") ||
      where('name LIKE ?', "%#{search}%")
    else
      all
    end
  end
end
