require 'json'
require 'fileutils'

class JSONDB
  attr_reader :file_path, :backup_path

  def initialize(file_path)
    @file_path = file_path
    @backup_path = "#{file_path}.backup"
    initialize_file unless File.exist?(file_path)
  end

  def read
    with_lock do
      JSON.parse(File.read(file_path))
    rescue JSON::ParserError
      raise "Error parsing JSON data in #{file_path}"
    end
  end

  def write(data)
    with_lock do
      create_backup
      File.open(file_path, 'w') { |f| f.write(JSON.pretty_generate(data)) }
    rescue IOError => e
      restore_backup
      raise "Error writing to file: #{e.message}"
    end
  end

  private

  def initialize_file
    with_lock { File.open(file_path, 'w') { |f| f.write('[]') } }
  end

  def create_backup
    FileUtils.cp(file_path, backup_path)
  end

  def restore_backup
    FileUtils.cp(backup_path, file_path)
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


