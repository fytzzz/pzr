# encoding: utf-8
# renfences Rm - project management software
class Setting < ActiveRecord::Base
  attr_accessible :name,:value
  DATE_FORMATS = [
      '%Y-%m-%d',
      '%d/%m/%Y',
      '%d.%m.%Y',
      '%d-%m-%Y',
      '%m/%d/%Y',
      '%d %b %Y',
      '%d %B %Y',
      '%b %d, %Y',
      '%B %d, %Y'
  ]

  TIME_FORMATS = [
      '%H:%M',
      '%I:%M %p'
  ]

  cattr_accessor :available_settings
  @@available_settings = YAML::load(File.open("#{Rails.root}/config/settings.yml"))

  validates_uniqueness_of :name
  validates_inclusion_of :name, :in => @@available_settings.keys
  validates_numericality_of :value, :only_integer => true, :if => Proc.new { |setting| @@available_settings[setting.name]['format'] == 'int' }

  # Hash used to cache setting values
  @cached_settings = {}
  @cached_cleared_on = Time.now

  def value
    v = read_attribute(:value)
    # Unserialize serialized settings
    v = YAML::load(v) if @@available_settings[name]['serialized'] && v.is_a?(String)
    v = v.to_sym if @@available_settings[name]['format'] == 'symbol' && !v.blank?
    v
  end

  def value=(v)
    v = v.to_yaml if v && @@available_settings[name] && @@available_settings[name]['serialized']
    write_attribute(:value, v.to_s)
  end

  # Returns the value of the setting named name
  def self.[](name)
    v = @cached_settings[name]
    v ? v : (@cached_settings[name] = find_or_default(name).value)
  end

  def self.[]=(name, v)
    setting = find_or_default(name)
    setting.value = (v ? v : "")
    @cached_settings[name] = nil
    setting.save
    setting.value
  end

  # Defines getter and setter for each setting
  # Then setting values can be read using: Setting.some_setting_name
  # or set using Setting.some_setting_name = "some value"
  @@available_settings.each do |name, params|
    src = <<-END_SRC
    def self.#{name}
      self[:#{name}]
    end

    def self.#{name}?
      self[:#{name}].to_i > 0
    end

    def self.#{name}=(value)
      self[:#{name}] = value
    end
    END_SRC
    class_eval src, __FILE__, __LINE__
  end

  # Helper that returns an array based on per_page_options setting
  def self.per_page_options_array
    per_page_options.split(%r{[\s,]}).collect(&:to_i).select { |n| n > 0 }.sort
  end

  def self.openid?
    Object.const_defined?(:OpenID) && self[:openid].to_i > 0
  end

  # Checks if settings have changed since the values were read
  # and clears the cache hash if it's the case
  # Called once per request
  def self.check_cache
    settings_updated_at = Setting.maximum(:updated_at)
    if settings_updated_at && @cached_cleared_on <= settings_updated_at
      @cached_settings.clear
      @cached_cleared_on = Time.now
      logger.info "Settings cache cleared." if logger
    end
  end

  private
  # Returns the Setting instance for the setting named name
  # (record found in database or new record with default value)
  def self.find_or_default(name)
    name = name.to_s
    raise "There's no setting named #{name}" unless @@available_settings.has_key?(name)
    setting = find_by_name(name)
    setting ||= new(:name => name, :value => @@available_settings[name]['default']) if @@available_settings.has_key? name
  end
end
