
# 楽天カードの利用履歴をパースする

result = Hash.new
sum = 0
i = 0
File.open("./data/#{ARGV[0]}"){ |f|
  f.each_line{ |line|
    rows = line.split(" ")
    rows.pop(1)

    begin
      price = rows.pop().split(',').join('').to_i
      sum += price
    rescue
      print "some error occured\n"
      next
    end

    if result[rows[1]] == nil
      result[rows[1]] = price
    else
      result[rows[1]] += price
    end
  }
}

print "実行対象: #{ARGV[0]}\n"
print "合計: #{sum}円\n"

sorted_result = result.sort {|a,b| a[1]<=>b[1]}

File.open("./result/#{ARGV[0]}", "w") { |f|

  f.puts "実行対象: #{ARGV[0]}"
  f.puts "合計: #{sum}円"

  sorted_result.each do | key, value |
    f.puts "#{key}: #{value}"
    f.puts "#" * ((value / 1000) + 1)
  end
}
