class VideoShow < ApplicationRecord
  belongs_to :showcase
  has_attached_file :video,
                    :styles => {
                        :mp4video => {:geometry => '1280x720', :format => 'mp4',
                                      :convert_options => {:output => {:vcodec => 'libx264',
                                                                       :acodec => 'libfaac', :ab => '56k', :ac => 2}}},
                        :preview => {:geometry => '1280x720', :format => 'jpg', :time => 5}
                    },
                    processors: [:ffmpeg]

  validates_attachment_content_type :video, :content_type => /\Avideo\/.*\Z/
  validates_presence_of :video
end
