class Audio < ActiveRecord::Base

  has_attached_file :source

  validates_attachment_presence :source
#  validates_attachment_content_type :source, :content_type => [ 'application/mp3', 'application/x-mp3', 'audio/mpeg', 'audio/mp3' ]
  validates_attachment_size :source, :less_than => 100.megabytes



  include AASM

  aasm do
    state :pending, :initial => true
    state :converting
    state :converted, :enter => :update_attributes
    state :error
    
    event :convert do
      transitions :from => :pending, :to => :converting
    end
    
    event :converted do
      transitions :from => :converting, :to => :converted
    end
    
    event :failed do
      transitions :from => :converting, :to => :error
    end
  end


  protected
 
  def update_attributes
    stripped_name = source.original_filename.chomp(File.extname(source.original_filename))

    update_attribute(:source_file_name, "#{ stripped_name }.mp3")
    update_attribute(:source_content_type, "audio/mp3")
    update_attribute(:source_file_size, File.size(source.path))
  end
end
