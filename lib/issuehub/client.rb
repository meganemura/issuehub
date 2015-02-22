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
      @pulls = github_client.pulls(repository)
    end

    def detailed_pulls
      pulls.map do |pull_request|
        @github_client.pull_request(repository, pull_request.number)
      end
    end
  end
end
