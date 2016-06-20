module SettingsHelper

	def default_task_status
		check_default_settings
		get_setting('default_task_type_id')
	end


	def get_setting(setting)
		check_default_settings
		setting = Setting.find_by_name(setting)
	end

	private 

	def check_default_settings
		if(!Setting.exists?(['name = ?', 'default_task_type_id']))
			deault_status = TaskStatus.create(name: "Новая")
			Setting.create(name: 'default_task_type_id', value: deault_status.id)
		end
	end

end
