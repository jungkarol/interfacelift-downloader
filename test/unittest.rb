require 'test/unit'
require 'mechanize'
require 'awesome_print'
require 'fileutils'

require_relative('../lib/interfacelift-downloader/downloader')

class DownloaderTests < Test::Unit::TestCase

  def setup
    @downloader = InterfaceliftDownloader.new()
  end

  def test_directory_exists?
    assert_true(@downloader.directory_exists?("#{Dir.home}"), 'User home directory should exist')
    assert_false(@downloader.directory_exists?('example_directory_123'), 'Example directory shouldnt exist')
  end

  def test_download_images
    @downloader.download_images(1)
    assert_true(@downloader.directory_exists?("#{Dir.home}/download_images"), 'download_images directory should exist')

    assert_false(Dir["#{Dir.home}/download_images"].empty?, 'download_images directory shouldnt be empty')

    FileUtils.rm_rf("#{Dir.home}/download_images")
    assert_false(@downloader.directory_exists?("#{Dir.home}/download_images"), 'download_images directory should be deleted')
  end

end
