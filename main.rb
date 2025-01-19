# 楽天カードの利用履歴をパースする
require_relative 'kakeibo'
require 'optparse'

# コマンドライン引数をパースする
options = {}
OptionParser.new do |opts|
  opts.banner = "使用方法: ruby main.rb [options]"
  
  opts.on("-y YEAR", "--year YEAR", Integer, "処理する年度 (例: 2024)") do |year|
    options[:year] = year
  end
  
  opts.on("-m MONTH", "--month MONTH", Integer, "処理する月 (1-12)") do |month|
    options[:month] = month if (1..12).include?(month)
  end
end.parse!

# 年度と月が指定された場合は特定のファイルのみ処理
if options[:year] && options[:month]
  file_pattern = "./data/#{options[:year]}/#{options[:year]}-#{options[:month]}.txt"
  if File.exist?(file_pattern)
    kakeibo = Kakeibo.new(file_pattern)
    kakeibo.export
  else
    puts "指定された年月のファイルが見つかりません: #{file_pattern}"
  end
# 年度のみ指定された場合はその年のファイルをすべて処理
elsif options[:year]
  file_pattern = "./data/#{options[:year]}/#{options[:year]}-*.txt"
  files = Dir.glob(file_pattern)
  if files.any?
    files.each do |file|
      kakeibo = Kakeibo.new(file)
      kakeibo.export
    end
  else
    puts "指定された年度のファイルが見つかりません: #{options[:year]}"
  end
else
  # 引数が指定されていない場合は全ファイルを処理（既存の動作）
  Dir.glob("./data/*/*.txt").each do |file|
    kakeibo = Kakeibo.new(file)
    kakeibo.export
  end
end
