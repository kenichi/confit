require 'ostruct'

module Confit
  
  @@app_config = nil
  @@verbose = nil
  
  def self.verbose
    @@verbose
  end

  def self.confit(file=nil, env=nil, verbose=false)

    @@app_config ? (return @@app_config) : @@app_config = OpenStruct.new

    @@verbose = verbose ? true : false
      
    if File.exist?(file)
      yaml = env ? YAML.load_file(file)[env] : YAML.load_file(file)
      yaml.each do |key, val|
        @@app_config.send("#{key}=", val)
      end
    end

    @@app_config
  end

end

module Kernel
  
  def confit(file=nil, env=nil, verbose=false)
    Confit::confit(file, env, verbose)
  end

end

class OpenStruct
  
  def method_missing(mid, *args)
    mname = mid.id2name
    if mname !~ /=/
      raise NoMethodError, "Confit variable not defined! #{mname}" if Confit.verbose
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