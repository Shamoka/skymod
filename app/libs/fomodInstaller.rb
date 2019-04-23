require './app/libs/installer.rb'

module Skymod
	class FomodInstaller < Installer
		def initialize(game, mod, db, doc)
			super(game, mod, db)
			@xml = doc.root
			@name = nil
			@dependecies = Array.new
			@required_files = Array.new
			@install_steps = Array.new
			@data_dir = nil
		end

		def prepare
			get_module_name
			get_required_files
			get_install_steps

			if not @data_dir = Skymod::Dir.no_case_find(@game.path,  "Data")
				@data_dir = File.join(@game.path, "Data")
				Dir.mkdir(@data_dir)
			end

			@install_steps.each do |is|
				dialog = FomodInstallStepDialog.new(is)
				if dialog.run == Gtk::ResponseType::OK
					dialog.files.each do |file|
						@files_list << file
					end
				end
				dialog.destroy
			end
			@files_list.each do |file|
				if file.type == :folder
					source = file.source.tr('\\', '/')
					add_folder_to_files(source, source, file.priority)
				else
					new_file = Skymod::ModFile.new(file.source)
					new_file.priority = file.priority
					@installed_files << new_file
				end
			end
			return self
		end

		def run
			copy_files(@data_dir)
		end

		private

		def get_module_name
			@name = @xml.elements['moduleName']
			if not @name
				puts "No moduleName found in ModuleConfig.xml"
			end
			return @name
		end
		
		def get_required_files
			if @xml.elements['requiredInstallFiles']
				@xml.elements['requiredInstallFiles'].each_element('file|folder') do |e|
					@required_files << Skymod::Fomod::File.new(e)
				end
			end
		end

		def get_install_steps
			@xml.elements['installSteps'].each_element('installStep') do |is|
				@install_steps << Skymod::Fomod::InstallStep.new(is)
			end
		end
	end
end
