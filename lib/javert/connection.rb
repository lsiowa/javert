module Javert
  module Connection
    extend ActiveSupport::Concern
    
    def connection
      @@connection ||= Net::LDAP.new
    end
    
    def connection=(new_connection)
      @@connection = new_connection
    end

		def connect(config)
      Javert.connection = Net::LDAP.new(config)
		end
	end
end
