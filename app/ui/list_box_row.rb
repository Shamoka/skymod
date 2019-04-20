module Skymod
	class ListBoxRow < Gtk::ListBoxRow
		type_register

		class << self
			def init
				set_template resource: '/org/shamoka/skymod/ui/ListBoxRow.ui'

				bind_template_child 'modListBoxRowInfo'
				bind_template_child 'modListBoxRowText'
				bind_template_child 'modListBoxInstallButton'
			end
		end

		def initialize(item)
			super()
			modListBoxRowText.buffer.text = item[0]
			modListBoxRowInfo.buffer.text = "installed: " + item[1]

			modListBoxInstallButton.signal_connect :clicked do |widget|
			end
		end
	end
end
