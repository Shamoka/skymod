module Skymod
	class FomodInstallStepDialogRow < Gtk::ListBoxRow
		type_register

		class << self
			def init
				set_template resource: '/org/shamoka/skymod/ui/FomodInstallStepDialogRow.ui'

				bind_template_child 'box'
			end
		end

		def initialize(optionalFileGroup)
			super()

			optionalFileGroup.groups.each do |group|

				group.plugins.each do |plugins|
					plugin_list = Array.new
					plugins.plugin.each do |plugin|
						plugin_box = Gtk::CheckButton.new
						plugin_box.label = plugin.name
						plugin_box.visible = true
						plugin_list << plugin_box
					end
					if plugins.order == "Ascending"
						plugin_list.sort! { |a, b| a.label <=> b.label }
					elsif plugins.order == "Descending"
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
		end
	end
end
