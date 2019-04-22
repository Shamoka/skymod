module Skymod
	module Fomod
		class InstallStep
			attr_reader	:optional_file_groups
			attr_reader :visible
			attr_reader	:name

			def initialize(xml)
				@optional_file_groups = Array.new

				@name = xml.attributes['name']

				if xml.elements['visible']
					v = xml.elements['visible'].elements.first
					@visble = Flag.new(v)
				end

				xml.each_element('optionalFileGroups') do |opt|
					@optional_file_groups << OptionalFileGroup.new(opt)
				end
			end

			class Flag
				attr_reader	:name
				attr_reader :value

				def initialize(xml)
					@name = xml.attributes['name']
					@value = xml.attributes['value'] || xml.text
				end
			end

			class OptionalFileGroup
				attr_reader :groups

				def initialize(xml)
					@groups = Array.new

					xml.each_element('group') do |group|
						@groups << Group.new(group)
					end
				end

				def print(box)
					@groups.each do |group|
						group.print(box)
					end
				end
			end

			class Group
				attr_reader :plugins
				attr_reader :order

				def initialize(xml)
					@plugins = Array.new
					@type = xml.attributes['type']
					xml.each_element('plugins') do |plugins_iter|
						@plugins << Plugins.new(plugins_iter)
					end
				end

				def print(box)
					@plugins.each do |plugins|
						plugin_list = plugins.print(box)
					end
				end

			end

			class Plugins
				attr_reader :order
				attr_reader	:plugin

				def initialize(xml)
					@plugin = Array.new
					@order = xml.attributes['order']

					xml.each_element('plugin') do |plugin_iter|
						@plugin <<  Plugin.new(plugin_iter)
					end
				end

				def print(box)
					plugin_list = Array.new
					@plugin.each do |plugin|
						plugin_box = Gtk::CheckButton.new
						plugin_box.label = plugin.name
						plugin_box.visible = true
						plugin_list << plugin_box
					end
					if @order == "Ascending"
						plugin_list.sort! { |a, b| a.label <=> b.label }
					elsif @order == "Descending"
						plugin_list.sort! { |a, b| b.label <=> a.label }
					end
					plugin_list.each do |plugin|
						box.add(plugin)
					end
					sep = Gtk::Separator.new(Gtk::Orientation::HORIZONTAL)
					sep.visible = true
					box.add(sep)
				end
			end

			class Plugin
				attr_reader :name
				attr_reader :description

				def initialize(xml)
					@name = xml.attributes['name']
					@flags = Array.new
					@files = Array.new

					@description = xml.elements['description']

					if (xml.elements['conditionFlags'])
						xml.elements['conditionFlags'].each_element('flag') do |flag|
							@flags << Flag.new(flag)
						end
					end

					xml.elements['files'].elements.each do |file|
						@files << File.new(file)
					end
				end

			end

			class File
				attr_reader	:type
				attr_reader	:source
				attr_reader	:destination
				attr_reader	:priority

				def initialize(xml)
					if xml.name == "folder"
						@type = :folder
					elsif xml.name == "file"
						@type = :file
					end

					@source = xml.attributes['source']
					@destination = xml.attributes['destination']
					@priority = xml.attributes['priority']
				end
			end
		end
	end
end
