module Skymod
	module Fomod
		class InstallStep
			attr_reader	:optional_file_groups
			attr_reader :visible

			def initialize(xml)
				@optional_file_groups = Array.new

				if xml.elements['visible']
					v = xml.elements['visible'].elements.first
					@visble = Flag.new(v)
				end

				xml.each_element('optionalFileGroups') do |opt|
					@optional_file_groups << Group.new(opt)
				end
			end

			class Flag
				attr_reader	:name
				attr_reader :value

				def initialize(xml)
					@name = xml.attributes['name']
					@value = xml.attributes['value']
				end
			end

			class Group
				attr_reader :plugins
				attr_reader :order

				def initialize(xml)
					@plugins = Array.new
					plugins = xml.elements['group'].elements['plugins']
					@order = plugins.attributes['order']
					plugins.each_element('plugin') do |plugin|
						@plugins << Plugin.new(plugin)
					end
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
