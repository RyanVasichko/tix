require 'aws-sdk-s3'
require 'open3'

class DatabaseBackupJob < ApplicationJob
  queue_as :default

  BACKUPS_DIRECTORY = "tmp/database_backups"
  BACKUPS_BUCKET = "dosey-doe-tickets-db-backups"
  BACKUPS_TO_KEEP = 7

  def perform
    ensure_backups_directory_exists
    create_backup
    upload_backup
    cleanup_local_backups
    cleanup_remote_backups
  end

  private

  def ensure_backups_directory_exists
    Dir.mkdir(BACKUPS_DIRECTORY) unless Dir.exist?(BACKUPS_DIRECTORY)
  end

  def create_backup
    backup_date = Time.now.strftime("%Y-%m-%d")
    @backup_file_name = "backup_#{backup_date}.sql"
    @backup_file_path = "#{BACKUPS_DIRECTORY}/#{@backup_file_name}"

    db_config = ActiveRecord::Base.connection_db_config.configuration_hash
    command = "pg_dump -h #{db_config[:host]} -U #{db_config[:username]} -d #{db_config[:database]} > #{@backup_file_path}"

    ENV['PGPASSWORD'] = db_config[:password]
    stdout, stderr, status = Open3.capture3(command)
    ENV['PGPASSWORD'] = nil

    raise "Command failed with error: #{stderr}" unless status.success?
  end

  def upload_backup
    obj = s3_resource.bucket(BACKUPS_BUCKET).object(@backup_file_name)
    obj.upload_file(@backup_file_path)
  end

  def cleanup_local_backups
    Dir.glob("#{BACKUPS_DIRECTORY}").each do |file|
      File.delete(file) if File.file?(file)
    end
  end

  def cleanup_remote_backups
    backup_objects = s3_resource.bucket(BACKUPS_BUCKET).objects(prefix: 'backup_').collect(&:key)
    sorted_backup_objects = backup_objects.sort_by { |obj| obj.split('_').last }.reverse

    backups_to_delete = sorted_backup_objects.drop(BACKUPS_TO_KEEP)
    backups_to_delete.each { |backup| s3_resource.bucket(BACKUPS_BUCKET).object(backup).delete }
  end

  def s3_resource
    @s3_resource ||= Aws::S3::Resource.new(client: s3_client)
  end

  def s3_client
    @s3_client ||= Aws::S3::Client.new(region: "us-east-1",
                                       access_key_id: Rails.application.credentials.dig(:aws, :access_key_id),
                                       secret_access_key: Rails.application.credentials.dig(:aws, :secret_access_key))
  end
end
