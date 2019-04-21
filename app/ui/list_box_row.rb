module Skymod
	class ListBoxRow < Gtk::ListBoxRow
		type_register

		class << self
			def init
				set_template resource: '/org/shamoka/skymod/ui/ListBoxRow.ui'

				bind_template_child 'modListBoxRowText'
				bind_template_child 'modListBoxRowInstall'
			end
		end

		def initialize(mod)
			super()

			modListBoxRowText.buffer.text = mod.name
			modListBoxRowInstall.set_active(mod.installed == "true")
			modListBoxRowInstall.signal_connect :toggled do |widget|
			end
		end

		private

		def application
			parent = self.parent
			parent = parent.parent while not parent.is_a?(Gtk::Window)
			parent.application
		end
	end
end
