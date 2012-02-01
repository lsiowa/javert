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
      #Javert.connection = Net::LDAP.new(config)
      conn = Net::LDAP.new
      conn.host = config["host"]
      conn.port = config["port"] unless config["port"].nil
      conn.authenticate(config["username"], config["password"])
      conn.base = config["base"]
      
      Javert.connect = conn
    end
	end
end
