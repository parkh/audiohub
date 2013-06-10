class AddAttachmentSourceToAudios < ActiveRecord::Migration
  def self.up
    change_table :audios do |t|
      t.attachment :source
    end
  end

  def self.down
    drop_attached_file :audios, :source
  end
end
