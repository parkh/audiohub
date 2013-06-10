class Audio < ActiveRecord::Base

  has_attached_file :source

  validates_attachment_presence :source
#  validates_attachment_content_type :source, :content_type => [ 'application/mp3', 'application/x-mp3', 'audio/mpeg', 'audio/mp3' ]
  validates_attachment_size :source, :less_than => 60.megabytes


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


  def convert
    self.convert!
    success = system(convert_command)
    if success && $?.exitstatus == 0
      self.converted!
    else
      self.failure!
    end
  end
 
  protected
 
  def convert_command
    stripped_path = source.path.chomp(File.extname(source.path))
   
    command = <<-end_command
      ffmpeg -i #{ source.path } -ac 1 -ab 64k #{ stripped_path }_converted.mp3
      rm #{ source.path }
      mv #{ stripped_path }_converted.mp3 #{ stripped_path }.mp3
    end_command
    command
  end
 
  def update_attributes
    stripped_name = source.original_filename.chomp(File.extname(source.original_filename))

    update_attribute(:source_file_name, "#{ stripped_name }.mp3")
    update_attribute(:source_content_type, "audio/mp3")
    update_attribute(:source_file_size, File.size(source.path))
  end
end