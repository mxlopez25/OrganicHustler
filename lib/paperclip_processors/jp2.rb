module Paperclip
  class Jp2 < Processor
    def make
      options[:format].each do |dst_format|
        p dst_format
        basename = File.basename(file.path, File.extname(file.path))

        dst = Tempfile.new([basename, dst_format])
        dst.binmode

        convert("-geometry #{options[:size]}x :src -quality 0 :dst",
                src: File.expand_path(file.path),
                dst: File.expand_path(dst.path),
                size: options[:height])
      end
    end
  end
end