class ConfigurationWeb < ApplicationRecord
  has_attached_file :picture,
                    styles: {
                      big_safari: ['1080x1080>', :jp2],
                      big_chrome: ['1080x1080>', :webp],
                      large_safari: ['900x900>', :jp2],
                      large_chrome: ['900x900>', :webp],
                      medium_safari: ['500x500>', :jp2],
                      medium_chrome: ['500x500>', :webp],
                      thumb_safari: ['300x300>', :jp2],
                      thumb_chrome: ['300x300>', :webp],
                      s_thumb_safari: ['120x120>', :jp2],
                      s_thumb_chrome: ['120x120>', :webp]
                    },
                    convert_options: {
                      big_safari: '-quality 85',
                      big_chrome: '-quality 85',
                      large_safari: '-quality 85',
                      large_chrome: '-quality 85',
                      medium_safari: '-quality 85',
                      medium_chrome: '-quality 85',
                      thumb_safari: '-quality 85',
                      thumb_chrome: '-quality 85',
                      s_thumb_safari: '-quality 85',
                      s_thumb_chrome: '-quality 85'
                    }
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
