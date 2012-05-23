require 'ostruct'
require 'rubygems'

class InvalidFileNameError < StandardError; end
class MissingVariableError < StandardError; end
class MissingFileError < StandardError; end

module Confit

  @@app_config = nil
  @@strict = false
  @@files = Array.new
  @@current_file_name = nil
  @@debug = false
  @@default_opts = lambda { return {:strict => @@strict, :force => false} }

  def self.debug(msg)
    puts "\nDebug:\t#{msg}" if @@debug
  end

  def self.strict
    @@strict
  end

  def self.confit(*args, &block)
    file = args.shift
    opts = (args.last and args.last.is_a? Hash) ? args.pop : @@default_opts.call
    env = (args && args.compact) || []

    self.debug("self.confit(file=#{file}, env=#{env}, strict=#{opts[:strict]}, force=#{opts[:force]})")

    @@app_config ||= OpenStruct.new

    if not @@files.include?(file) and not file.nil?
      self.debug "New file: #{file}"
      self.prep_config(file)
    else
      self.debug "File exists: (#{opts[:force]}) #{file}"
      return @@app_config unless opts[:force]
      self.debug "Forcing reload of file"
    end

    @@strict = opts[:strict] ? true : false

    self.process_file(file, env, &block)

    @@app_config
  end

  def self.prep_config(file)
    file =~ /([^\/]+)\.yml$/i
    raise InvalidFileNameError, "Filename is not valid: #{file}" if not $1

    @@current_file_name = $1
    self.debug "Current file #{@@current_file_name}"
    @@files << file
    @@app_config.send("#{@@current_file_name}=", OpenStruct.new)
  end

  def self.process_file(file, env=nil)
    if not file.nil?
      if File.exist?(file)
        #yaml = env ? YAML.load_file(file)[env] : YAML.load_file(file)
        yaml = YAML.load_file(file)
        env.each {|key| yaml = yaml[key.to_s]}
        yield yaml if block_given?
        self.parse_hash(yaml, @@app_config.send(@@current_file_name))
      else
        raise MissingFileError, "File #{file} does not exist!"
      end
    end
  end

  def self.load_pair(key, val, parent)
    _key = key.gsub /\s+/, '_'
    self.debug "load_pair: #{parent}.send(#{_key}=, #{val})"
    parent.send("#{_key}=", val)
  end

  def self.parse_hash(zee_hash, parent)
    zee_hash.each do |key, val|
      if val.is_a?(Hash)
        self.debug "is a Hash #{key},#{val}"
        self.load_pair(key, OpenStruct.new, parent)
        self.parse_hash(val, parent.send(key))
      else
        self.debug "Not a Hash #{key},#{val}"
        self.load_pair(key, val, parent)
      end

    end
  end

  def self.reset!
    @@app_config = nil
    @@strict = false
    @@files = Array.new
    @@current_file_name = nil
  end

end

class OpenStruct

  def method_missing(mid, *args)
    mname = mid.id2name
    if mname !~ /=/
      raise MissingVariableError, "Confit variable not defined! #{mname}" if Confit.strict
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
