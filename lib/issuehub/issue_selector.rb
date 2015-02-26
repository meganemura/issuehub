module Issuehub
  class IssueSelector

    def initialize(client, repository)
      @client = client
      @repository = repository
    end

    attr_reader :targets

    def reset!
      @targets = nil
    end

    def issues
      return @targets if issues_selected?
      @targets = @client.issues(@repository)
    end

    def pulls
      return @targets if pulls_selected?
      @targets = @client.pulls(@repository)
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

    private

    def issues_selected?
      return false if @targets.nil? || @targets.empty?
      !! (@targets.first.url =~ %r(/issues/\d$))
    end

    def pulls_selected?
      return false if @targets.nil? || @targets.empty?
      !! (@targets.first.url =~ %r(/pulls/\d$))
    end

    def detailed_pulls
      return @targets if detailed_pulls?
      @targets = pulls.map do |pull_request|
        @client.pull_request(@repository, pull_request.number)
      end
    end

    def detailed_pulls?
      !(@targets.first.mergeable.nil?)
    end
  end
end
