require 'ostruct'

module Confit
  
  @@app_config = nil
  @@strict = nil
  
  def self.strict
    @@strict
  end

  def self.prep_key(key)
    key.gsub(/\s/, "_")
  end
  
  def self.confit(file=nil, env=nil, strict=false)

    @@app_config ? (return @@app_config) : @@app_config = OpenStruct.new

    @@strict = strict ? true : false
    
    if not file.nil?
      if File.exist?(file)
        yaml = env ? YAML.load_file(file)[env] : YAML.load_file(file)
        yaml.each do |key, val|
          @@app_config.send("#{self.prep_key(key)}=", val)
        end
      else
        raise IOError, "File #{file} does not exist!"
      end
    end

    @@app_config
  end

end

module Kernel
  
  def confit(file=nil, env=nil, strict=false)
    Confit::confit(file, env, strict)
  end

end

class OpenStruct
  
  def method_missing(mid, *args)
    mname = mid.id2name
    if mname !~ /=/
      raise NoMethodError, "Confit variable not defined! confit.#{mname}" if Confit.strict
    else
      len = args.length
      if mname.chomp!('=')
        if len != 1
          raise ArgumentError, "wrong number of arguments (#{len} for 1)", caller(1)
        end
        modifiable[new_ostruct_member(mname)] = args[0]
      elsif len == 0
        @table[mid]
      else
        raise NoMethodError, "undefined method `#{mname}' for #{self}", caller(1)
      end
    end
  end
  
end