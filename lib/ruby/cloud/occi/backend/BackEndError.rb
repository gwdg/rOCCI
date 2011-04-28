module OCCI
  module Backend
  class BackEndError < StandardError
    def initilize
      pp "An ERROR happened from Backend"
    end
  end
  end
end