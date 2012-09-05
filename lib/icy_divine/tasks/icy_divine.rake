namespace :icy_divine do

	desc "Generate ICD codes into your model"
	task :seed, [:model, :code_attr, :description_attr, :specification, :explanation_attr, :version_attr, :reset] => :environment do |t, args|

		#Seed subliminal message
		puts "Icy Divine will now populate your model with ICD codes."
		puts "(If you are rewriting these values over a previously-seeded model, it is recommended that you quit and run '$rake icy_divine:eradicate' before re-seeding.)"
		puts "This will take a while--maybe a good opportunity to re-watch 'Pink Flamingos'?"

		puts "Reading the parameters you passed..."
		#Define model and attribute names (and defaults)
		version_name = args[:specification] || 'ICD9-CM-2011'
		puts "You asked to see specification #{version_name}"
		model_name = args[:model] || 'Icd'
		puts "...into the model '#{model_name}' under the following attributes:"
		code_number = args[:code_attr].blank? ? 'code=' : (args[:code_attr].to_s + '=')
		puts "=> :#{code_number.chomp('=')} will contain the code number"
		code_title = args[:description_attr].blank? ? 'title=' : (args[:description_attr].to_s + '=')
		puts "=> :#{code_title.chomp('=')} will contain the code title/name"

		#Define explanation attribute name (no default value)
		if !args[:explanation_attr].blank?			
			code_explanation = (args[:explanation_attr].to_s + '=')
			puts "=> :#{args[:explanation_attr]} will contain the code explanation/description (if applicable)"
		else
			puts "=> You are not seeding the code explanations/descriptions (this is the default setting)."
		end

		#Define version attribute name (no default value)
		if !args[:version_attr].blank?
			code_version = (args[:version_attr].to_s + '=')
			puts "=> :#{args[:version_attr]} will contain the code version name (as #{version_name})"
		else
			puts "=> You are not seeding the code version name (this is the default setting)."
		end

		if !(args[:reset] == ("no" or "false"))
			puts "=> You have elected to reset the primary keys for the model (default value)"
		else
			puts "=> You have elected not to reset the primary keys for this model."
		end

		puts "Now reading the ICD code file..."
		file = File.read(Rails.root.to_s + '/vendor/icy_divine/' + code_version(version_name))
		puts "Done."

		puts "And parsing out the ICD codes..."
		code_and_name = file.scan(/(?<icd9code>^[E|V|[0-9]]\d{2,3}(\.\d{1,3}|))\t(?<code_name>.*\n)/)
		puts "Bingo."
		
		puts "Seeding your model with the parsed data..."
		code_and_name.length.times do |i|
			@entry = code_and_name[i]
			@icd = model_name.constantize.new
			@icd.send(code_number, @entry[0])
			@icd.send(code_title, @entry[1].chomp)

			#Reset model ids for new entries, unless :reset param set to "no"
			if !(args[:reset] == ("no" or "false"))
				@icd.id = i
			end

			#Skip seeding explanation attribute if param is empty
			if !args[:explanation_attr].blank?
				@expl = file.scan(/(?<explanation>((?<=^#{@icd.code}\t).*?(?=((^E\d{2,3})|(^V\d{2,3})|(^[0-9]\d{2,3}(\.|\s))))))/m)
				if @expl.blank?
					@mod_expl = ''
				else
					@mod_expl = @expl[0][0].sub(@icd.title, "").strip
				end
				@icd.send(code_explanation, @mod_expl)
			end
			
			#Skip seeding version attribute if param is empty
			if !args[:version_attr].blank?
				@icd.send(code_version, version_name)
			end

			@icd.save
		end

		puts "Success! The ICD codes should now be in your model!"
	end

	desc "Clear ICD codes from model"
	task :eradicate, [:model] => :environment do |t, args|
		puts "Icy Divine will need a few moments to clear the ICD codes from your database. If you need a bathroom break, now's the time."
		model_name = args[:model] || 'Icd'
		puts "Removing all records from the model '#{model_name}'..."
		model_name.constantize.find(:all).each do |o|
			o.destroy
		end
		puts "All done! All tables in '#{model_name}' are now empty."
	end

	desc "How to use the Icy Divine gem"
	task :help do
		puts ""
		puts "************************************"
		puts "Icy Divine is the first ICD9-code-seeding-cum-Harris-Glenn-Milstead-aka-'Divine'-tribute Ruby gem. This help task is meant to provide a basic guideline to its use. Find the more information, along with the source code, at http://github.com/mikecarroll/icy_divine"
		puts "************************************"
		puts ""
		puts "RAKE TASKS:"
		puts ""
		puts "$ rake icy_divine:seed [:model, :code_attr, :description_attr, :specification, :explanation_attr, :version_attr, :reset]"
		puts "Run this rake task to seed your model with the ICD9 code specification of your choosing. This task takes in a few parameters:"
		puts "------------------------------------"
		puts ""
		puts "$ rake icy_divine:eradicate [:model]"
		puts "A helper task for purging all ICD codes from your model, so that you can re-seed it with a new set of values. The following parameters are required for this task to function properly:"
		puts ":model #=> The name of the model containing the ICD codes you want to purge. ex: ['Icd']"
		puts ""
	end

	def code_version(name)
		if name == 'ICD9-CM-2011'
			'Dtab12.txt'
		elsif name == 'ICD9-CM-2010'
			'Dtab11.txt'
		elsif name == 'ICD9-CM-2009'
			'Dtab10.txt'
		elsif name == 'ICD9-CM-2008'
			'Dtab09.txt'
		elsif name == 'ICD9-CM-2007'
			'Dtab08.txt'
		elsif name == 'ICD9-CM-2006'
			'Dtab07.txt'
		elsif name == 'ICD9-CM-2005'
			'Dtab06.txt'
		elsif name == 'ICD9-CM-2004'
			'Dtab05.txt'
		elsif name == 'ICD9-CM-2003'
			'Dtab04.txt'
		elsif name == 'ICD9-CM-2002'
			'Dtab03.txt'
		elsif name == 'ICD9-CM-2001'
			'Dtab02.txt'
		elsif name == 'ICD9-CM-2000'
			'Dtab01.txt'
		elsif name == 'ICD9-CM-1998'
			'Dtab99.txt'
		elsif name == 'ICD9-CM-1997'
			'Dtab98.txt'
		else
			'Dtab12.txt'
		end
	end

end