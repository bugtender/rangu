# frozen_string_literal: true

require "bundler/gem_tasks"
require "minitest/test_task"
require "rubocop/rake_task"

Minitest::TestTask.create do |task|
  # The legacy API mutates caller-owned string literals. Re-enable warnings
  # once the immutable API lands in a follow-up commit.
  task.warning = false
end
RuboCop::RakeTask.new

task default: %i[test rubocop]
