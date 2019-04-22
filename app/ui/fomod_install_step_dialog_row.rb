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

			optionalFileGroup.print(box)
		end
	end
end
