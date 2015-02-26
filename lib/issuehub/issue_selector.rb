module Issuehub
  class IssueSelector

    def initialize(client, repository)
      @client = client
      @repository = repository
    end

    attr_reader :targets

    def reset!
      @issue   = false
      @pull    = false
      @targets = nil
    end

    def issues
      return @targets if @issue
      @issue, @pull = true, false
      @targets = @client.issues(@repository)
    end

    def pulls
      return @targets if @pull
      @issue, @pull = false, true
      @targets = @client.pulls(@repository)
    end

    def detailed_pulls
      return @targets if @detailed

      @targets = pulls.map do |pull_request|
        @client.pull_request(@repository, pull_request.number)
      end
      @detailed = true

      @targets
    end

    def mergeable
      detailed_pulls.select {|pull| pull.mergeable }
    end

    def unmergeable
      detailed_pulls.select {|pull| !pull.mergeable }
    end

    def numbers
      targets.map(&:number)
    end

  end
end
