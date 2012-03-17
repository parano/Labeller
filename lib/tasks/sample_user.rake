namespace :db  do
	desc "Create some sample users 1000@a.com __1010@a.com"
	task :populate => :environment do
		Rake::Task['db:reset'].invoke
        for i in 1000..1010 do
            User.create!(:email => "#{i}@a.com",
                        :password => '123456',
                        :password_confirmation => '123456',
                        :role => 'labeller')
        end

		User.create!(:email => 'parano@qq.com',
                 :password => 'password',
                 :password_confirmation => 'password',
                 :role => 'admin')

		User.create!(:email => 'jingshuai@summba.com',
					:password => 'summba',
					:password_confirmation => 'summba',
					:role => 'initiator')
	end


end
