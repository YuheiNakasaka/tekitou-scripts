# coding: utf-8
# 1) (デフォルトではオフ) [東京スナックナビ](http://snacknavi.com/)からスナック名を取得する
# 2) mecabで形態素解析
# 3) ランダムでスナック名を作成する

require 'bundler/setup'
require 'mechanize'
require 'natto'

class SnackCrawler
  def initialize(cwl=false,file_name='snack_name_generator.csv')
    @cwl = cwl
    @agent = Mechanize.new
    @base = 'http://snacknavi.com/area/'
    @paging = 's='
    @amp = '&'
    @slash = '/'
    @pattern = 'span.shopname20'
    @output_file = "#{File.expand_path('../../', __FILE__)}/outputs/#{file_name}"
    @targets = [
        {line: 'yamanote'},
        {line: 'chuuou'}
    ]
  end

  def run
    if @cwl == true
      @targets.each_with_index do |target, i|
        log("LINE | #{target[:line]}")
        get_page(target, i)
      end
    end
  end

  private

  def get_page(target, i)
    log("Page #{i}")
    sleep(1)
    target_url = [@base, target[:line], @amp, @paging, i, @slash].join('')
    res = @agent.get(target_url).search(@pattern).map{|obj| obj.text }.join("\n")
    if !res.empty?
      File.open( @output_file, 'a') do |f|
        f.puts res
      end
      get_page(target, i+20)
    end
  end
end

class Parser
  def initialize(file_name='snack_name_generator.csv')
    @results = []
    @output_file = "#{File.expand_path('../../', __FILE__)}/outputs/#{file_name}"
  end

  def run
    parsed_data
  end

  private

  def parsed_data
    results = []
    text = File.read(@output_file)
    nm = Natto::MeCab.new
    nm.parse(text) do |t|
      if t.feature.split(/,/)[0] == '名詞' && t.surface.match(/(スナック|スナツク)/).nil?
        results << t.surface
      end
    end
    results
  end
end

def log(text)
  puts "[#{Time.now.strftime('%Y/%m/%d %H:%M')}] #{text}"
end

############## exec ###############
crawler = SnackCrawler.new
crawler.run

parser = Parser.new
puts "スナック #{parser.run.sample(rand(3)+1).join('')}"