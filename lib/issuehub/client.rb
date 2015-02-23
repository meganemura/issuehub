require "issuehub/issue_selector"

module Issuehub
  class Client
    def initialize
      dotenv
      setup_github_client
      setup_issue_selector
    end

    def dotenv
      Dotenv.load
    end

    def setup_github_client
      Octokit.reset!  # reload environment variables for dotenv
      @github_client = Octokit.client
    end
    attr_reader :github_client

    def setup_issue_selector
      @selector = IssueSelector.new(github_client, repository)
    end
    attr_reader :selector

    # owner/repo
    def repository
      ENV['ISSUEHUB_REPOSITORY']
    end

    def select(target)
      case target
      when Symbol
        if selector.respond_to?(target)
          selector.send(target)
        else
          []
        end
      end

      self
    end

    def list
      selector.numbers
    end

    def label(options)
      as = options.fetch(:as, 'bug')

      selector.numbers.each do |number|
        @github_client.add_labels_to_an_issue(repository, number, [as])
      end
    end
  end
end
