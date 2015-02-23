module Issuehub
  class IssueSelector

    def initialize(github_client, repository)
      @github_client = github_client
      @repository = repository
    end

    def pulls
      @pulls ||= @github_client.pulls(@repository)
    end

    def detailed_pulls
      return @pulls if @detailed

      @pulls = pulls.map do |pull_request|
        @github_client.pull_request(@repository, pull_request.number)
      end
      @detailed = true

      @pulls
    end

    def mergeable
      detailed_pulls.select {|pull| pull.mergeable }
    end

    def unmergeable
      detailed_pulls.select {|pull| !pull.mergeable }
    end

  end
end
