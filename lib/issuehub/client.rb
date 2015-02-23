module Issuehub
  class Client
    def initialize
      dotenv
      setup_github_client
    end

    def dotenv
      Dotenv.load
    end

    def setup_github_client
      Octokit.reset!  # reload environment variables for dotenv
      @github_client = Octokit.client
    end
    attr_reader :github_client

    # owner/repo
    def repository
      ENV['ISSUEHUB_REPOSITORY']
    end

    def pulls
      @pulls ||= github_client.pulls(repository)
    end

    def detailed_pulls
      return @pulls if @detailed

      @pulls = pulls.map do |pull_request|
        @github_client.pull_request(repository, pull_request.number)
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

    def label(target, options)
      as = options.fetch(:as, 'bug')

      issues = case target
               when Symbol
                 if self.respond_to?(target)
                   self.send(target)
                 else
                   []
                 end
               end

      issues.each do |issue|
        @github_client.add_labels_to_an_issue(repository, issue.number, [as])
      end
    end
  end
end
