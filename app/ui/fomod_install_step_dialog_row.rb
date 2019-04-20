module Skymod
	class FomodInstallStepDialogRow < Gtk::ListBoxRow
		type_register

		class << self
			def init
				set_template resource: '/org/shamoka/skymod/ui/FomodInstallStepDialogRow.ui'

				bind_template_child 'fomodTestText'
			end
		end

		def initialize(group)
			super()
			fomodTestText.buffer.text = group.plugins.first.name
		end
	end
end
