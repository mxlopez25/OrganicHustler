Paperclip.interpolates(:s3_us_west_url) { |attachment, style|
  "https://s3.us-west-2.amazonaws.com/#{attachment.bucket_name}/#{attachment.path(style).gsub(%r{^/}, '')}"
}