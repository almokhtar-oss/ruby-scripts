#!/usr/bin/env ruby
# frozen_string_literal: true

require 'mail'
# require 'pg'
require 'colorize'

module Backup

  def self.connect_and_send(database, host, db_name, username, password)
    backup_file = "#{db_name}_#{Time.now.utc.strftime('%Y%m%d')}.sql"

    case database
    when 'mysql'
      mysql_dump = "mysqldump -h #{host} -u #{username} -p #{password} #{database}"
      `#{mysql_dump} > #{backup_file}.sql`
      `gzip #{backup_file}`
    when 'postgresql'
      if system("pg_dump -h #{host} -p 5432 #{db_name} > #{backup_file}")
        `gzip #{backup_file}`
        puts "#{db_name} exported".green
        # send_email(backup_file, db_name)
      end
    else
      puts 'Database not Exported, something went wrong'.red
  end
  end

  def self.send_email(backup_file, db_name)
    options = {
        :address              => "smtp.gmail.com",
        :port                 => 587,
        :domain               => 'gmail.com',
        :user_name            => 'x@gmail.com',
        :to_user              => 'x@gmail.com',
        :password             => 'x',
        :authentication       => 'plain',
        :enable_starttls_auto => true
    }

    Mail.defaults do
      delivery_method :smtp, options
    end

    Mail.deliver do
      from     options[:user_name]
      to       options[:to_user]
      subject  "Database #{db_name} backup #{Time.new}"
      body     "Database #{db_name} backup #{Time.new}"
      add_file backup_file
    end
  end
end

puts "
+================================================+
|            DB Backup with ruby                 |
+================================================+
|    Supported Databases: Mysql, Postgresql      |
+================================================+
".light_blue

puts '[+] Enter database (example: mysql, postgresql ...)'.green
database = gets.chomp
puts '[+] Enter host (example: localhost, 128.189.2...)'.green
host = gets.chomp
puts '[+] Enter database name (example: blog_db, my_database ...)'.green
database_name = gets.chomp
puts '[+] Enter User name for database (example: sarah, ahmed ...)'.green
username = gets.chomp
puts '[+] Enter Password'.green
password = gets.chomp

Backup.connect_and_send(database, host, database_name, username, password)
