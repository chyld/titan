#!/usr/bin/env ruby

# TITAN
# VERSION 1.0
# CHYLD MEDFORD

require 'pry'
require 'aws-sdk'

AWS.config(:access_key_id => ENV['AWSKEY'], :secret_access_key => ENV['AWSSEC'])
$s3 = AWS::S3.new

def create_bucket(name)
  begin
    $s3.buckets.create(name)
  rescue AWS::S3::Errors::BucketAlreadyExists
  end
end

def show_menu
  print "(titan) "
  $stdout.flush

  response = gets.chomp

  case response
  when 'v'
    puts `ruby -v`
  when 'l'
    puts 'CMD:L'
    $s3.buckets.each {|bucket| puts bucket.name}
  when 'c'
    print 'bucket name: '
    name = gets.chomp
    puts 'error with bucket name, please try again' if !create_bucket(name)
  when 'u'
    print 'bucket name: '
    name = gets.chomp
    bucket = $s3.buckets[name]
    print 'file name: '
    file = gets.chomp
    bucket.objects[file].write(Pathname.new(file))
  when 'd'
    print 'bucket name: '
    name = gets.chomp
    bucket = $s3.buckets[name]
    print 'file name: '
    file = gets.chomp
    obj = bucket.objects[file]
    File.open(file, 'wb') do |f|
      obj.read do |chunk|
        f.write(chunk)
      end
    end
  end

  response
end

while show_menu != 'q'; end
