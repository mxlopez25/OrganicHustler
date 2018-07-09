class ConfigurationWeb < ApplicationRecord
  has_attached_file :picture, processors: [:web_p], styles: {
    big: {format: :webp, size: 1080},
    normal: {format: :webp, size: 900},
    medium: {format: :webp, size: 500},
    thumb: {format: :webp, size: 300}
  }, default_url: "/images/no-logo.jpg"
  validates_attachment_content_type :picture, content_type: /\Aimage\/.*\z/

  has_attached_file :video,
                    :styles => {
                      :mp4video => {:geometry => '1280x720', :format => 'mp4',
                                    :convert_options => {:output => {:vcodec => 'libx264',
                                                                     :acodec => 'libfaac', :ab => '56k', :ac => 2}}},
                      :preview => {:geometry => '1280x720', :format => 'jpg', :time => 5}
                    },
                    processors: [:ffmpeg]

  validates_attachment_content_type :video, :content_type => /\Avideo\/.*\Z/
end
