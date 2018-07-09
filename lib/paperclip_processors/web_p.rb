module Paperclip
  class WebP < Processor
    def make
      basename = File.basename(file.path, File.extname(file.path))
      dst_format = options[:format] ? ".#{options[:format]}" : ''

      dst = Tempfile.new([basename, dst_format])
      dst.binmode

      convert("-geometry #{options[:size]}x :src :dst",
              src: File.expand_path(file.path),
              dst: File.expand_path(dst.path),
              size: options[:height])
      dst
    end
  end
end