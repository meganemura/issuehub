module Issuehub
  class IssueSelector

    def initialize(client, repository)
      @client = client
      @repository = repository
    end

    attr_reader :targets

    def to_numbers
      targets && targets.map(&:number) || []
    end

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
      @targets = detailed_pulls.select {|pull| pull.mergeable }
    end

    def unmergeable
      @targets = detailed_pulls.select {|pull| !pull.mergeable }
    end

    def labeled_as(name)
      if @targets.nil? || @targets.empty?
        return issues  # fetch
      end

      if issues_selected?
        @targets = targets.select {|target| target.labels.detect {|x| x.name == name } }
      else
        @targets = targets.map do |pull|
          @client.issue(@repository, pull.number)
        end
      end
    end

    def milestone(title)
      @targets = targets.select {|target| target.milestone && target.milestone.title == title }
    end

    def no_milestone
      @targets = targets.select {|target| target.milestone.nil? }
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
      if @targets.nil? || @targets.empty?
        pulls   # fetch
      elsif detailed_pulls?
        return @targets
      end

      @targets = pulls.map do |pull|
        @client.pull_request(@repository, pull.number)
      end
    end

    def detailed_pulls?
      !(@targets.first.mergeable.nil?)
    end
  end
end
