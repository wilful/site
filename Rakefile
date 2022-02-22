#html_index = 'docs/index.html'
#FileList['src/content/*.md'].each {|md| file html_index => md}

WORK_DIR = Dir.getwd
CONFIG = WORK_DIR + '/src/pelican/pelicanconf.py'
CONTENT_DIR = WORK_DIR + '/src/content'
OUT_DIR = WORK_DIR + '/docs/'
THEMES_DIR = WORK_DIR + '/src/pelican/themes'
THEME = THEMES_DIR + '/aboutwilson'
TMP_PATH = WORK_DIR + '/src/tmp'
DRAFTS_PATH = WORK_DIR + '/src/drafts'
PELICAN_CMD = "pelican -s #{CONFIG} #{CONTENT_DIR} -o #{OUT_DIR} -t #{THEME}"

def run_pelican(config: CONFIG, content: CONTENT_DIR, out: OUT_DIR, theme: THEME, args: [])
  cmd = "pelican -s #{config} #{content} -o #{out} -t #{theme} #{args.join(' ')}"
  exec cmd
end

def build_docs
  run_pelican
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
end
task :test do
end
task :post do
end
task :drafts do
  ENV['PELICAN_ENV'] = 'testing'
  run_pelican(content: DRAFTS_PATH, out: TMP_PATH, args: ['--listen', '-r'])
end
#file 'docs/index.html' => 'src/content/*.md' do
#end

task :build => :clean
