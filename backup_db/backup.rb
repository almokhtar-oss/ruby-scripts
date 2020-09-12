#!/usr/bin/env ruby
# frozen_string_literal: true

require 'mail'
# require 'pg'

module Backup

  def self.connect_and_send
      psql_database = 'mello_test'
      system("pg_dump -h localhost -p 5432 #{psql_database} > backup.sql")
      send_email(psql_database)
      # Delete the file after sending
      File.delete 'backup.sql'
  end

  def self.send_email(psql_database)
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
      subject  "Database #{psql_database} backup #{Time.new}"
      body     "Database #{psql_database} backup #{Time.new}"
      add_file 'backup.sql'
    end
  end
end

Backup.connect_and_send
