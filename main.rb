
# 楽天カードの利用履歴をパースする
require_relative 'kakeibo'

Dir.glob("./data/*.txt").each do |file|
  kakeibo = Kakeibo.new(File.basename(file))
  kakeibo.export
end
