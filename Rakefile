#html_index = 'docs/index.html'
#FileList['src/content/*.md'].each {|md| file html_index => md}

require 'yaml'
require 'git'
require 'logger'

WORK_DIR = Dir.getwd
CONFIG = WORK_DIR + '/src/pelican/pelicanconf.py'
CONTENT_DIR = WORK_DIR + '/src/content'
OUT_DIR = WORK_DIR + '/docs/'
THEMES_DIR = WORK_DIR + '/src/pelican/themes'
THEME = THEMES_DIR + '/aboutwilson'
TMP_PATH = WORK_DIR + '/src/tmp'
DRAFTS_PATH = WORK_DIR + '/src/drafts'
ALIASES_PATH = WORK_DIR + '/src/aliases'

class SiteGit
  attr_reader :work_dir
  def initialize(work_dir=WORK_DIR)
    @work_dir = work_dir
    @git = Git.open(WORK_DIR, :log => Logger.new(STDOUT))
  end
  def reset
    @git.fetch
    @git.reset
  end
  def commit
    @git.add(:all => true)
    @git.commit('Update my repo', opts = {:all => true})
  end
  def push
    @git.push
  end
end

repo = SiteGit.new

namespace :git do
  task :reset do
    repo.reset
  end
  task :commit do
    repo.commit
  end
  task :push do
    repo.push
  end
  task :update => [:commit, :push] do
  end
end


def run_pelican(config: CONFIG, content: CONTENT_DIR, out: OUT_DIR, theme: THEME, args: [])
  cmd = "pelican -s #{config} #{content} -o #{out} -t #{theme} #{args.join(' ')}"
  exec cmd
end

def build_docs
  run_pelican
end

def read_contents
end

desc 'Default task for project building'
task :default => [:build] do
end
task :build do
  build_docs
end
task :clean do
  rm_rf OUT_DIR
  mkdir OUT_DIR
end
task :commit do
  settings = YAML.load_file("#{WORK_DIR}/src/default.yaml")
  puts(settings)
end
task :test do
  ENV['PELICAN_ENV'] = 'testing'
  run_pelican(content: DRAFTS_PATH, out: TMP_PATH, args: ['--listen', '-r'])
end
task :post do
  cmd = "bash #{WORK_DIR}/bin/new_post"
  exec cmd
end
task :aliases do
  mkdir_p ALIASES_PATH
  Dir.glob("#{CONTENT_DIR}/**/*.md").each do |file|
    File.open(file) {|f|
      title = f.read.match(/[tT]itle\:(.*)/)[1]
        .strip.downcase.tr(" ", "_")
      link = "#{ALIASES_PATH}/#{title}.txt"
      puts("Try create #{link}")
      File.symlink(file,link) if not File.exist?(link)
    }
  end
end
task :drafts do
end
#file 'docs/index.html' => 'src/content/*.md' do
#end

task :build => :clean
