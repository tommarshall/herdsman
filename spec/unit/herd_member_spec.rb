require 'spec_helper'
require 'herdsman'

describe Herdsman::HerdMember do
  let(:gathered_repo) do
    double(
      path: '/tmp/foo.git',
      initialized?: true,
      fetch!: nil,
      has_unpushed_commits?: false,
      has_unpulled_commits?: false,
      has_untracked_files?: false,
      has_modified_files?: false,
      revision?: true,
      last_fetched: Time.now,
    )
  end
  let(:ungathered_repo) do
    double(
      path: '/tmp/foo.git',
      initialized?: true,
      fetch!: nil,
      has_unpushed_commits?: true,
      has_unpulled_commits?: true,
      has_untracked_files?: true,
      has_modified_files?: true,
      revision?: false,
      last_fetched: Time.now,
    )
  end
  let(:config) do
    double(revision: 'master', fetch_cache: 0)
  end

  describe '#name' do
    it 'returns the directory name when no name set' do
      herd_member = described_class.new(gathered_repo, config)

      expect(herd_member.name).to eq 'foo.git'
    end
    it 'returns the assigned name when a name is set' do
      herd_member = described_class.new(gathered_repo, config, name: 'bar')

      expect(herd_member.name).to eq 'bar'
    end
  end

  describe '#gathered?' do
    it 'returns true when gathered' do
      herd_member = described_class.new(gathered_repo, config)

      expect(herd_member).to be_gathered
    end
    it 'returns false when ungathered' do
      herd_member = described_class.new(ungathered_repo, config)

      expect(herd_member).to_not be_gathered
    end
    context 'with a valid fetch cache' do
      it 'does not call `repo.fetch!`' do
        cached_config = double(name: 'foo', revision: 'bar', fetch_cache: 300)
        herd_member = described_class.new(gathered_repo, cached_config)

        expect(gathered_repo).to_not receive(:fetch!)
        herd_member.gathered?
      end
    end
    context 'with an invalid fetch cache' do
      it 'calls `repo.fetch!`' do
        herd_member = described_class.new(gathered_repo, config)

        expect(gathered_repo).to receive(:fetch!)
        herd_member.gathered?
      end
    end
  end

  describe '#status_report' do
    it 'does not include any previous messages' do
      herd_member = described_class.new(ungathered_repo, config)
      status_report_first_size  = herd_member.status_report.size
      status_report_second_size = herd_member.status_report.size

      expect(status_report_first_size).to eq status_report_second_size
    end
    context 'when gathered' do
      it 'returns an array of info messages' do
        herd_member = described_class.new(gathered_repo, config)
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
          last_fetched: Time.now,
        )
      end
      it 'returns a warning message' do
        allow(uninitialized_repo).to receive(:fetch!).and_raise('Fetch failed')
        herd_member = described_class.new(uninitialized_repo, config)
        status_report = herd_member.status_report

        expect(status_report.is_a?(Array)).to be true
        expect(status_report.size).to be 2
        expect(status_report[0].level).to eq :warn
        expect(status_report[0].msg).to include 'not a git repo'
        expect(status_report[1].level).to eq :warn
        expect(status_report[1].msg).to include 'failed to fetch'
      end
    end
    context 'when the repo has unpushed commits' do
      let(:unpushed_repo) do
        double(
          path: '/tmp/foo.git',
          initialized?: true,
          fetch!: nil,
          has_unpushed_commits?: true,
          has_unpulled_commits?: false,
          has_untracked_files?: false,
          has_modified_files?: false,
          revision?: true,
          last_fetched: Time.now,
        )
      end
      it 'returns a warning message' do
        herd_member = described_class.new(unpushed_repo, config)
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
          fetch!: nil,
          has_unpushed_commits?: false,
          has_unpulled_commits?: true,
          has_untracked_files?: false,
          has_modified_files?: false,
          revision?: true,
          last_fetched: Time.now,
        )
      end
      it 'returns a warning message' do
        herd_member = described_class.new(unpulled_repo, config)
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
          fetch!: nil,
          has_unpushed_commits?: false,
          has_unpulled_commits?: false,
          has_untracked_files?: true,
          has_modified_files?: false,
          revision?: true,
          last_fetched: Time.now,
        )
      end
      it 'returns a warning message' do
        herd_member = described_class.new(untracked_files_repo, config)
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
          fetch!: nil,
          has_unpushed_commits?: false,
          has_unpulled_commits?: false,
          has_untracked_files?: false,
          has_modified_files?: true,
          revision?: true,
          last_fetched: Time.now,
        )
      end
      it 'returns a warning message' do
        herd_member = described_class.new(modified_files_repo, config)
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
          fetch!: nil,
          has_unpushed_commits?: false,
          has_unpulled_commits?: false,
          has_untracked_files?: false,
          has_modified_files?: false,
          revision?: false,
          last_fetched: Time.now,
        )
      end
      it 'returns a warning message' do
        herd_member = described_class.new(incorrect_revision_repo, config)
        status_report = herd_member.status_report

        expect(status_report.is_a?(Array)).to be true
        expect(status_report.size).to be 1
        expect(status_report[0].level).to eq :warn
        expect(status_report[0].msg).to include 'revision is not'
      end
    end
    context 'when ungathered' do
      it 'returns an array of warning messages' do
        herd_member = described_class.new(ungathered_repo, config)
        status_report = herd_member.status_report

        expect(status_report.is_a?(Array)).to be true
        expect(status_report.size).to be 5
        expect(status_report.map(&:level).uniq).to eq [:warn]
      end
    end
  end
end
