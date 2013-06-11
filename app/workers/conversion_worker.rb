class ConversionWorker
  include Sidekiq::Worker

  def perform(audio_id)
  	audio = Audio.find(audio_id)

  	stripped_path = audio.source.path.chomp(File.extname(audio.source.path))
   
    command = <<-end_command
      ffmpeg -i #{ audio.source.path } -ac 1 -ab 64k #{ stripped_path }_converted.mp3
      rm #{ audio.source.path }
      mv #{ stripped_path }_converted.mp3 #{ stripped_path }.mp3
    end_command

    audio.convert!
    success = system(command)
    if success && $?.exitstatus == 0
      audio.converted!
    else
      audio.failure!
    end
  end
end