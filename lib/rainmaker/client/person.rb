module Rainmaker
  class Client
    module Person
      # Returns extended information for a given email
      #
       def person(email, options = {})
      options[:email] = email
        response = get('person', options)
        format.to_s.downcase == 'xml' ? response['person'] : response
     end
    end
  end
end
