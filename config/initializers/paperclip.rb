Paperclip.interpolates(:s3_us_west_url) { |attachment, style|
  "#{attachment.s3_protocol}://s3-us-west-2.amazonaws.com/#{attachment.bucket_name}/#{attachment.path(style).gsub(%r{^/}, '')}"
}