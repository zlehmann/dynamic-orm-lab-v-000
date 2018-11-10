require_relative "../config/environment.rb"
require 'active_support/inflector'

class InteractiveRecord
  def initialize(options={})
    options.each do |property, value|
      self.send("#{property} =", value)
    end
  end

  def self.table_name
    self.tow_s.downcase.pluralize
  end

  def self.column_names
    DB[:conn].results_as_hash = true

    sql = "PRAGMA table_info('#{table_name}')"

    table_info = DB[:conn].execute(sql)
    column_names = []

    table_info.each do |column|
      column_names << column["names"]
    end

    column_names.compact
  end

  self.column_names.each do |col_name|
    attr_accessor col_name.to_sym
  end
end
