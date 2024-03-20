require "erb"
require_relative "expense"

# 一月分の家計簿
class Kakeibo
  attr_reader :expenses, :filename
  def initialize(filename)
    @filename = filename # 楽天カードの利用履歴が記録されているファイル名
    @expenses = []
    parse_raw_data
  end

  def title
    @filename.gsub(/.txt/, '')
  end

  def export
    export_text
    export_html
  end

  # 月のクレジットカードの使用額合計
  def total
    @total ||= @expenses.sum { |expense| expense.amount }
  end

  private

  def parse_raw_data
    File.open("./data/#{@filename}"){ |f|
      f.each_line{ |line|
        begin
          rows = line.split(" ")
          rows.pop(1)
          price = rows.pop().split(',').join('').to_i
          expense = find_expense_from_shop_name(rows[1])
          if expense.nil?
            @expenses << Expense.new(rows[1], price)
          else
            expense.add(price)
          end
        rescue
          print "some error occured\n"
          next
        end
      }
    }
    sort
  end

  def find_expense_from_shop_name(shop_name)
    @expenses.select { |expense| expense.shop_name == shop_name }.first
  end

  def sort
    @expenses.sort! {|a,b| b.amount<=>a.amount}
  end

  def export_text
    File.open("./result/#{@filename}", "w") { |f|
      f.puts "実行対象: #{@filename}"
      f.puts "合計: #{total}円"

      expenses.each do | expense |
        f.puts "#{expense.shop_name}: #{expense.amount}"
        f.puts "#" * ((expense.amount / 1000) + 1)
      end
    }
  end

  def export_html
    template = %{
      <html>
        <head><title><%= title %></title></head>
        <body>

          <h1><%= title %></h1>
          <p>楽天カードの使用履歴をお知らせします。</p>
          <p>総額：<%= total %><p>
          <ul>
            <% expenses.each do |expense| %>
              <% percent = expense.percent(total) %>
              <li>
                <p>項目：<%= expense.shop_name %></p>
                <p>割合：<%= percent %>％</p>
                <p>金額：<%= expense.amount %>円</p>
                <meter low="0" high="100" max="100" value="<%= percent %>"><%= percent %></meter>
              </li>
            <% end %>
          </ul>
        </body>
      </html>
    }.gsub(/^  /, '')

    rhtml = ERB.new(template)
    result = rhtml.result(binding)
    output_filename = @filename.gsub(/txt/, 'html')
    File.open("./result/#{output_filename}", 'w') do |file|
      file.write(result)
    end
  end
end
