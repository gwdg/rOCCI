module Occi
  module Parser
    module Ova

      # @param [String] string
      # @return [Occi::Collection]
      def self.collection(string)
        tar = Gem::Package::TarReader.new(StringIO.new(string))
        ovf = mf = cert = nil
        files = {}
        tar.each do |entry|
          tempfile = Tempfile.new(entry.full_name)
          tempfile.write(entry.read)
          tempfile.close
          files[entry.full_name] = tempfile.path
          ovf = tempfile.path if entry.full_name.end_with? '.ovf'
          mf = tempfile.path if entry.full_name.end_with? '.mf'
          cert = tempfile.path if entry.full_name.end_with? '.cert'
        end

        File.read(mf).each_line do |line|
          name = line.scan(/SHA1\(([^\)]*)\)= (.*)/).flatten.first
          sha1 = line.scan(/SHA1\(([^\)]*)\)= (.*)/).flatten.last
          Occi::Log.debug "SHA1 hash #{Digest::SHA1.hexdigest(files[name])}"
          raise "SHA1 mismatch for file #{name}" if Digest::SHA1.hexdigest(File.read(files[name])) != sha1
        end if mf

        raise 'no ovf file found' if ovf.nil?

        Occi::Parser::Ovf.collection(File.read(ovf), files)
      end

    end
  end
end