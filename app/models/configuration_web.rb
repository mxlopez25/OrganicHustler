class ConfigurationWeb < ApplicationRecord
  has_attached_file :picture, styles: {medium: "500x500>", thumb: "300x300>"}, default_url: "/images/no-logo.jpg"
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
