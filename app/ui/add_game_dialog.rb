module Skymod
	class AddGameDialog < Gtk::Dialog
		type_register

		attr_accessor	:name
		attr_accessor	:path

		class << self
			def init
				set_template resource: '/org/shamoka/skymod/ui/AddGameDialog.ui'

				bind_template_child 'gamePathText'
				bind_template_child 'gameNameText'
				bind_template_child 'buttonAdd'
				bind_template_child 'buttonCancel'
			end
		end

		def initialize
			super()

			buttonAdd.signal_connect :clicked do |widget|
				@name = gameNameText.buffer.text
				@path = gamePathText.buffer.text
				self.response(Gtk::ResponseType::OK)
			end

			buttonCancel.signal_connect :clicked do |widget|
				@name = nil
				@path = nil
				self.response(Gtk::ResponseType::CANCEL)
			end
		end
	end
end
