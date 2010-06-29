class PopulateUserTable < ActiveRecord::Migration
  def self.up
    users = %w(Tyler Dale Sheryl Hannah John Malik Curtis Leigh Brad Rob)
    users.each do |user|
      temp = User.new(:username => user, :password => user.downcase,
                      :password_confirmation => user.downcase,
                      :email => user + '@something.com')
      temp.save
    end
  end

  def self.down
    users = %w(Tyler Dale Sheryl Hannah John Malik Curtis Leigh Brad Rob)
    users.each do |user|
      temp = User.find_by_username(user)
      temp.destroy unless temp.nil?
    end
  end
end
