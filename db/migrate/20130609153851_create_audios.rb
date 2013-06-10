class CreateAudios < ActiveRecord::Migration
  def up
    create_table :audios do |t|
      t.string :aasm_state

      t.timestamps
    end
  end

  def down
    drop_table :audios
  end
end
