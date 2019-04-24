module Skymod
	module Fomod
		class InstallStep
			attr_reader	:optional_file_groups
			attr_reader	:name

			def initialize(xml)
				@optional_file_groups = Array.new
				@visible = Array.new
				@flags = Array.new
				@visible = Array.new

				@name = xml.attributes['name']

				if xml.elements['visible']
					xml.elements['visible'].elements do |flag|
						@visble << FlagDependency.new(flag)
					end
				end

				xml.each_element('optionalFileGroups') do |opt|
					@optional_file_groups << OptionalFileGroup.new(opt)
				end
			end

			def print(box)
				return false if checkDependency == false
				@optional_file_groups.each do |opt|
					opt.print(box)
				end
				return true
			end

			def checkDependency
				@visible.each do |v|
					@flags.each do |f|
						if v.flag == f.name and v.value == f.value
							return false
						end
					end
				end
				return true
			end

			class FlagDependency
				attr_reader :flag
				attr_reader :value

				def initialize(xml)
					@flag = xml.attributes['flag']
					@value = xml.attributes['value']
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
				attr_reader :name
				attr_reader :order

				def initialize(xml)
					@plugins = Array.new
					@name = xml.attributes['name']
					@type = xml.attributes['type']
					xml.each_element('plugins') do |plugins_iter|
						@plugins << Plugins.new(plugins_iter)
					end
				end

				def print(box)
					@plugins.each do |plugins|
						label = Gtk::TextView.new
						label.buffer.text = @name
						label.visible = true
						box.add(label)
						plugin_list = plugins.print(box, @type)
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

				def print(box, type)
					plugin_list = Array.new
					button = nil
					if type == "SelectAll"
						build_checkbox(plugin_list)
						plugin_list.each do |plugin|
							plugin.active = true
							plugin.signal_connect :toggled do |p|
								p.active = true
							end
						end
					elsif type == "SelectAtMostOne" 
						build_radio(plugin_list)
						hidden_radio = Gtk::RadioButton.new
						hidden_radio.group = plugin_list.last.group
						hidden_radio.active = true
						plugin_list << hidden_radio
						button = Gtk::Button.new
						button.label = "Clear selection"
						button.visible = true
						button.signal_connect :clicked do |w|
							hidden_radio.active = true
						end
					elsif type == "SelectAny"
						build_checkbox(plugin_list)
					elsif type == "SelectExactlyOne"
						build_radio(plugin_list)
					end
					if @order == "Ascending"
						plugin_list.sort! { |a, b| a.label <=> b.label }
					elsif @order == "Descending"
						plugin_list.sort! { |a, b| b.label <=> a.label }
					end
					plugin_list.each do |plugin|
						box.add(create_row(plugin))
					end
					sep = Gtk::Separator.new(Gtk::Orientation::HORIZONTAL)
					sep.visible = true
					box.add(create_row(sep))
					box.add(create_row(button)) if button
				end

				private

				def build_radio(plugin_list)
					radio_group = nil
					@plugin.each do |plugin|
						radio = Skymod::FomodInstallStepRadioButton.new(plugin.files)
						if not radio_group.nil?
							radio.group = radio_group
						end
						radio_group = radio.group
						radio.label = plugin.name
						radio.visible = true
						plugin_list << radio
					end
				end

				def build_checkbox(plugin_list)
					@plugin.each do |plugin|
						plugin_box = Skymod::FomodInstallStepCheckButton.new(plugin.files)
						plugin_box.label = plugin.name
						plugin_box.visible = true
						plugin_list << plugin_box
					end
				end

				def create_row(elem)
					row = Gtk::ListBoxRow.new
					row.visible = true
					row.add(elem)
					row
				end
			end

			class Plugin
				attr_reader :name
				attr_reader :description
				attr_reader :files

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
						@files << Skymod::ModFile.new(file)
					end
				end
			end

			class Flag
				attr_reader	:name
				attr_accessor :value

				def initialize(xml)
					@name = xml.attributes['name']
					@value = xml.attributes['value']
				end
			end

		end
	end
end
