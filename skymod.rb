#!/usr/bin/env ruby

require 'gtk3'
require 'fileutils'
require 'sqlite3'

$app_root = Dir.pwd
Dir.glob(File.join($app_root, "app", "{ui,models,libs}", "*.rb")).each do |file|
	require file
end

resource_xml = File.join($app_root, 'resources', 'gresources.xml')
resource_bin = File.join($app_root, 'gresource.bin')

system("glib-compile-resources",
	   "--target", resource_bin,
	   "--sourcedir", File.dirname(resource_xml),
	   resource_xml)

resource = Gio::Resource.load(resource_bin)
Gio::Resources.register(resource)

at_exit do
	FileUtils.rm_f(resource_bin)
end

app = Skymod::Application.new

app.run
