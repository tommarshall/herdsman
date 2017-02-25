require 'git'

class TestGitRepo
  attr_reader :path
  def initialize(name)
    @path = File.join(
      File.dirname(__FILE__), '..', '..', 'tmp', 'repo', "#{name}.git"
    )
    @remote_path = File.join(
      File.dirname(__FILE__), '..', '..', 'tmp', 'repo', "#{name}-remote.git"
    )
    @repo = create_repo
  end

  def checkout_branch(branch_name)
    repo.branch(branch_name).checkout
  end

  def checkout_commit(commit_sha)
    repo.checkout(commit_sha)
  end

  def checkout_tag(tag_name)
    tag(tag_name)
    repo.checkout(tag_name)
  end

  def commit_file(file_name, msg = 'Fix foo bar')
    repo.add(File.join(path, file_name))
    repo.commit(msg)
  end

  def fetch
    repo.fetch
  end

  def head_commit_sha
    repo.object('HEAD').sha[0..6]
  end

  def last_fetched
    File.mtime(File.join(path, '.git/FETCH_HEAD'))
  end

  def push
    repo.push
  end

  def reset_hard(commit_sha)
    repo.reset_hard(commit_sha)
  end

  def tag(tag_name)
    repo.add_tag(tag_name)
  end

  def write_file(name, contents)
    File.open(File.join(path, name), 'w') { |f| f.write(contents) }
  end

  private

  attr_reader :repo, :remote_path

  def create_repo
    # create empty dir
    FileUtils.rm_rf(path)
    FileUtils.mkdir_p(path).first

    # initialise repo
    repo = Git.init(path)
    repo.config('user.name', 'Test')
    repo.config('user.email', 'test@example.com')

    # create empty remote dir
    FileUtils.rm_rf(remote_path)
    FileUtils.mkdir_p(remote_path).first

    # initialise remote repo
    Git.init(remote_path, bare: true)

    # initial commit
    write_file('foo.txt', "Foo\nBar\n")
    repo.add(File.join(path, 'foo.txt'))
    repo.commit('Initial commit')

    # push to remote
    repo.add_remote('origin', remote_path)

    # push and track the remote branch (repo.push doesn't track)
    Dir.chdir(File.expand_path(path, Dir.pwd)) do
      `git push --set-upstream origin master > /dev/null 2>&1`
    end

    repo
  end
end
