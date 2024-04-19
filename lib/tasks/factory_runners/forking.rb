module FactoryRunners
  module Forking
    def with_forking
      if forking_enabled?
        fork { yield }
      else
        yield
      end
    end

    private

    def forking_enabled?
      ENV.fetch("FACTORIES_FORKING", "0") == "1"
    end
  end
end
