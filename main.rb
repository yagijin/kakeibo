
# 楽天カードの利用履歴をパースする

result = Hash.new
sum = 0

print ARGV[0]

File.open("./data/#{ARGV[0]}"){ |f|
  f.each_line{ |line|
    rows = line.split(" ")
    rows.pop(1)
    price = rows.pop().split(',').join('').to_i
    sum += price

    if result[rows[1]] == nil
      result[rows[1]] = price
    else
      result[rows[1]] += price
    end
  }
}

print "実行対象: #{ARGV[0]}\\n"
print "合計: #{sum}円\\n"

sorted_result = result.sort {|a,b| a[1]<=>b[1]}

sorted_result.each do | key, value |
  print "\\n #{key}: #{value} \\n"
  print "#" * ((value / 1000) + 1)
end
