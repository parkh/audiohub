class AddUserRefToAudios < ActiveRecord::Migration
  def change
    add_reference :audios, :user, index: true
  end
end
