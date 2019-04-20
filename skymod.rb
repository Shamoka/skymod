#!/usr/bin/env ruby

require 'gtk3'
require 'fileutils'

root = File.expand_path(__dir__)
Dir.glob(File.join(root, "app", "{ui,models,libs}", "*.rb")).each do |file|
	require file
end

resource_xml = File.join(root, 'resources', 'gresources.xml')
resource_bin = File.join(root, 'gresource.bin')

system("glib-compile-resources",
	   "--target", resource_bin,
	   "--sourcedir", File.dirname(resource_xml),
	   resource_xml)

resource = Gio::Resource.load(resource_bin)
Gio::Resources.register(resource)

at_exit do
	FileUtils.rm_f(resource_bin)
end

app = Skymod::Application.new(root)

app.run
