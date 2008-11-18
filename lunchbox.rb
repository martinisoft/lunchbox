#!/usr/bin/env ruby

require 'rubygems'
require 'sequel'
require 'base64'
require 'readline'

class Lunchbox
  def initialize(db = "lunchbox.db")
    @db = Sequel.sqlite(db)
    @files = @db[:files]
  end
  
  def schema
    @db.create_table :files do # Create a new table
      column :name, :text
      column :data, :blob
    end
  end
  
  # alias to Base64
  def encode(data)
    Base64.encode64(data)
  end
  
  # alias to Base64
  def decode(data)
    Base64.decode64(data)
  end
  
  # add file
  def add(filename)
    b = File.read(filename)
    @files << {:name => filename, :data => encode(b)}
    puts "Added file: #{filename}"
  end
  
  # save file
  def save(filename)
    pic = Base64.decode64(@files[:name => filename][:data])
    File.open("out-#{filename}", "w") do |file|
      file << pic
    end
    puts "Saved file: #{filename}"
  end
  
  # list files
  def list
    puts "File Listing: \n"
    @files.each do |r|
      puts r[:name]
    end
  end
  
  def delete(filename)
    @files.filter(:name => filename).delete
    puts "Deleted file: #{filename}"
  end
  
  def run
    loop do
      line = Readline::readline('lunchbox$ ')
      Readline::HISTORY.push(line)
      puts "#{line}"
    end
  end
  
end

