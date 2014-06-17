module TestApp
	class App < Padrino::Application
		register Padrino::Rendering
		register Padrino::Mailer
		register Padrino::Helpers
		disable :show_exceptions, :dump_errors, :raise_errors, :flash, :protection, :x_cascade

		error do
			proj_dir = File.expand_path(File.dirname(__FILE__) + "/../") + '/'
			puts $!.message.to_s + ': ' + $!.backtrace[0..8].map{ |line| line.gsub(/^#{proj_dir}/, '') }.join("\n")
		end
	end
end
