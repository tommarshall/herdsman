require 'spec_helper'
require 'herdsman'

describe Herdsman::HerdMember do
  let(:gathered_repo) do
    double(
      path: '/tmp/foo.git',
      initialized?: true,
      has_unpushed_commits?: false,
      has_unpulled_commits?: false,
      has_untracked_files?: false,
      has_modified_files?: false,
      revision?: true,
    )
  end
  let(:ungathered_repo) do
    double(
      path: '/tmp/foo.git',
      initialized?: false,
      has_unpushed_commits?: true,
      has_unpulled_commits?: true,
      has_untracked_files?: true,
      has_modified_files?: true,
      revision?: false,
    )
  end

  describe '#name' do
    it 'returns the directory name when no name set' do
      herd_member = described_class.new(gathered_repo, 'master')
      expect(herd_member.name).to eq 'foo.git'
    end
    it 'returns the assigned name when a name is set' do
      herd_member = described_class.new(gathered_repo, 'master', name: 'bar')
      expect(herd_member.name).to eq 'bar'
    end
  end

  describe '#status_report' do
    context 'when gathered' do
      it 'returns an array of info messages' do
        herd_member = described_class.new(gathered_repo, 'master')
        status_report = herd_member.status_report

        expect(status_report.is_a?(Array)).to be true
        expect(status_report.size).to be 1
        expect(status_report.map(&:level).uniq).to eq [:info]
      end
    end
    context 'when uninitialized' do
      let(:uninitialized_repo) do
        double(
          path: '/tmp/foo.git',
          initialized?: false,
          has_unpushed_commits?: false,
          has_unpulled_commits?: false,
          has_untracked_files?: false,
          has_modified_files?: false,
          revision?: true,
        )
      end
      it 'returns a warning message' do
        herd_member = described_class.new(uninitialized_repo, 'master')
        status_report = herd_member.status_report

        expect(status_report.is_a?(Array)).to be true
        expect(status_report.size).to be 1
        expect(status_report[0].level).to eq :warn
        expect(status_report[0].msg).to include 'not a git repo'
      end
    end
    context 'when the repo has unpushed commits' do
      let(:unpushed_repo) do
        double(
          path: '/tmp/foo.git',
          initialized?: true,
          has_unpushed_commits?: true,
          has_unpulled_commits?: false,
          has_untracked_files?: false,
          has_modified_files?: false,
          revision?: true,
        )
      end
      it 'returns a warning message' do
        herd_member = described_class.new(unpushed_repo, 'master')
        status_report = herd_member.status_report

        expect(status_report.is_a?(Array)).to be true
        expect(status_report.size).to be 1
        expect(status_report[0].level).to eq :warn
        expect(status_report[0].msg).to include 'has unpushed commits'
      end
    end
    context 'when the repo has unpulled commits' do
      let(:unpulled_repo) do
        double(
          path: '/tmp/foo.git',
          initialized?: true,
          has_unpushed_commits?: false,
          has_unpulled_commits?: true,
          has_untracked_files?: false,
          has_modified_files?: false,
          revision?: true,
        )
      end
      it 'returns a warning message' do
        herd_member = described_class.new(unpulled_repo, 'master')
        status_report = herd_member.status_report

        expect(status_report.is_a?(Array)).to be true
        expect(status_report.size).to be 1
        expect(status_report[0].level).to eq :warn
        expect(status_report[0].msg).to include 'has unpulled commits'
      end
    end
    context 'when the repo has untracked files' do
      let(:untracked_files_repo) do
        double(
          path: '/tmp/foo.git',
          initialized?: true,
          has_unpushed_commits?: false,
          has_unpulled_commits?: false,
          has_untracked_files?: true,
          has_modified_files?: false,
          revision?: true,
        )
      end
      it 'returns a warning message' do
        herd_member = described_class.new(untracked_files_repo, 'master')
        status_report = herd_member.status_report

        expect(status_report.is_a?(Array)).to be true
        expect(status_report.size).to be 1
        expect(status_report[0].level).to eq :warn
        expect(status_report[0].msg).to include 'has untracked files'
      end
    end
    context 'when the repo has modified files' do
      let(:modified_files_repo) do
        double(
          path: '/tmp/foo.git',
          initialized?: true,
          has_unpushed_commits?: false,
          has_unpulled_commits?: false,
          has_untracked_files?: false,
          has_modified_files?: true,
          revision?: true,
        )
      end
      it 'returns a warning message' do
        herd_member = described_class.new(modified_files_repo, 'master')
        status_report = herd_member.status_report

        expect(status_report.is_a?(Array)).to be true
        expect(status_report.size).to be 1
        expect(status_report[0].level).to eq :warn
        expect(status_report[0].msg).to include 'has modified files'
      end
    end
    context 'when the repo is on the incorrect revision' do
      let(:incorrect_revision_repo) do
        double(
          path: '/tmp/foo.git',
          initialized?: true,
          has_unpushed_commits?: false,
          has_unpulled_commits?: false,
          has_untracked_files?: false,
          has_modified_files?: false,
          revision?: false,
        )
      end
      it 'returns a warning message' do
        herd_member = described_class.new(incorrect_revision_repo, 'master')
        status_report = herd_member.status_report

        expect(status_report.is_a?(Array)).to be true
        expect(status_report.size).to be 1
        expect(status_report[0].level).to eq :warn
        expect(status_report[0].msg).to include 'revision is not'
      end
    end
    context 'when ungathered' do
      it 'returns an array of warning messages' do
        herd_member = described_class.new(ungathered_repo, 'master')
        status_report = herd_member.status_report

        expect(status_report.is_a?(Array)).to be true
        expect(status_report.size).to be 5
        expect(status_report.map(&:level).uniq).to eq [:warn]
      end
    end
  end
end
