#!/usr/bin/env ruby
# encoding: utf-8
require 'nokogiri'
require 'date'
require 'yaml'

LINE = "FutureCon + MaelströM"

class Programme
  attr_accessor :date, :time, :title, :author, :length, :description
  attr_reader :start, :end, :day

  def self.from_xml(e)
    p = self.new
    mapping = {
      'title' => :title,
      'start-time' => :start,
      'end-time' => :end,
      'author' => :author,
      'annotation' => :description,
      'length' => :length
    }
    e.children.each do |child|
      name = child.name
      next unless mapping.key?(name)
      p.send("#{mapping[name]}=", child.text)
    end
    p
  end

  def initialize
  end

  def start=(datetime)
    @start = parse_datetime(datetime)
    @day = @start.to_date
  end

  def end=(datetime)
    @end = parse_datetime(datetime)
  end

  def to_hash
    ret = {}
    self.instance_variables.each do |var|
      ret[var.to_s.delete("@").to_sym] = self.instance_variable_get(var)
    end
    ret
  end

  # def to_yaml(opts = {})
  #   puts "to_yaml"
  #   to_hash.to_yaml(opts)
  # end

  private
  def parse_datetime(dt)
    DateTime.xmlschema(dt)
  end
end

doc = Nokogiri::XML(File.open(ARGV[0], 'r:bom|utf-8'))
programmes = []
prog_by_date = {}
doc.search("[text()*='#{LINE}']").each do |element|
  prog = Programme.from_xml(element.parent)
  programmes << prog
  prog_by_date[prog.day] ||= []
  prog_by_date[prog.day] << prog
end

sorted = prog_by_date.sort.each do |day, array|
  array.sort_by!(&:start).map!(&:to_hash)
end

# Hash[sorted].each do |key, value|
#   puts key, value.map(&:start)
# end

# Hash[sorted].each do |k, v|
  # puts v.map {|prog| prog.to_hash}
# end
puts Hash[sorted].to_yaml
