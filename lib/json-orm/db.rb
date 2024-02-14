# frozen_string_literal: true

require 'json'
require 'fileutils'
require 'logger'
module JSONORM
  class DB
    attr_reader :file_path, :backup_path, :logger

    def initialize(file_path, log_file)
      @file_path = file_path
      @backup_path = "#{file_path}.backup"
      @logger = Logger.new(log_file)
      initialize_file unless File.exist?(file_path)
    end

    def read
      with_lock do
        JSON.parse(File.read(file_path), symbolize_names: true)
      rescue JSON::ParserError
        raise "Error parsing JSON data in #{file_path}"
      end
    end

    def write(data)
      with_lock do
        create_backup
        File.open(file_path, 'w') { |f| f.write(JSON.pretty_generate(data)) }
        logger.info('Data written successfully')
      rescue IOError => e
        restore_backup
        logger.error("Error writing to file: #{e.message}")
        raise "Error writing to file: #{e.message}"
      end
    end

    private

    def initialize_file
      with_lock { File.open(file_path, 'w') { |f| f.write('[]') } }
    end

    def create_backup
      logger.info('Creating backup')
      FileUtils.cp(file_path, backup_path)
    rescue StandardError => e
      logger.error("Failed to create backup: #{e.message}")
      raise "Failed to create backup: #{e.message}"
    end

    def restore_backup
      logger.info('Restoring from backup')
      FileUtils.cp(backup_path, file_path)
    rescue StandardError => e
      logger.error("Failed to restore backup: #{e.message}")
      raise "Failed to restore backup: #{e.message}"
    end

    def with_lock
      File.open("#{file_path}.lock", 'w') do |f|
        f.flock(File::LOCK_EX)
        yield
      ensure
        f.flock(File::LOCK_UN)
      end
    end
  end
end
