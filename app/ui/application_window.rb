module Skymod
	class ApplicationWindow < Gtk::ApplicationWindow
		type_register

		class << self
			def init
				set_template resource: "/org/shamoka/skymod/ui/ApplicationWindow.ui"

				bind_template_child 'modListBox'
			end
		end

		def initialize(application)
			super application: application

			set_title 'Skymod'
			load_modules(application)
		end

		private

		def load_modules(application)
			modListBox.children.each do |child|
				modListBox.remove child
			end
			application.db.execute("SELECT * FROM mods").each do |mod|
				modListBox.add(Skymod::ListBoxRow.new(mod))
			end
		end
	end
end
