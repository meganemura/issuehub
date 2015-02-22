module Issuehub
  class Client
    def initialize
      dotenv
    end

    def dotenv
      Dotenv.load
    end
  end
end
