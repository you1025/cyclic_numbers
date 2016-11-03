FILE_PATH = "./data/numbers.dat"
SEP = ","

N = ARGV[0].nil? ? 100 : ARGV[0].to_i

numbers = Array.new(N+1, true)

def get_numbers(n = nil)
  # ファイルの読込
  str = ""
  open(FILE_PATH, "r") {|f| str = f.gets}

  numbers = str.strip.split(SEP)
  numbers[0..1] = [nil, nil]

  # 数値の上限が指定された場合はそれに従う
  # インデックス範囲外の時は配列がそのまま返される
  numbers = numbers[0..n] unless n.nil?

  # 変換
  # "p"        => :prime
  # 数値文字列 => 数値
  (2..(numbers.size-1)).each do |i|
    numbers[i] = numbers[i] == "p" ? :prime : numbers[i].to_i
  end

  numbers
end


equal_to_selfs = Array.new
sum_of_divisors = Hash.new
cycles = Hash.new
out_of_ranges = Array.new

numbers = get_numbers(N)
(2..N).each do |p|
  # Check: 素数を対象外
  next if numbers[p] == :prime

  q = numbers[p]

  stack = Array.new  
  while true do

    # Check: インデックス範囲外は対象外
    if q > N
      # ToDo: 範囲外な事を通知する手段が必要
      out_of_ranges << (stack.first.nil? ? p : stack.first)
      break
    end

    # 約数の和が自分自身
    if p == q
      equal_to_selfs << p unless equal_to_selfs.include? p
    end

    ### 数値の系列が素数に行き着く事を検知 ###
    if numbers[q] == :prime

      # 素数 q が未登録の場合は空の箱を用意
      unless sum_of_divisors.has_key? q
        sum_of_divisors[q] = [p]
      end

      # スタックに積まれた履歴を出力(重複を除く)
#      sum_of_divisors[q] << stack if stack.size > 0
      stack.each {|v| sum_of_divisors[q] << v}

      break

    ### 数値の系列が循環する事を検知 ###
    elsif !(idx = stack.index(p)).nil?
      # 循環以前と循環部分に分離
      branch = idx == 0 ? nil : stack[0..(idx-1)]
      cycle  = stack[idx..(stack.size-1)]

      # 循環に関する情報の追加
      unless cycles.has_key? cycle
        cycles[cycle] = Array.new
      end
      cycles[cycle] << branch unless branch.nil?

      break

    else
      stack.push p
      p = q
      q = numbers[q]
      next
    end
  end
end


# 約数の和が自分自身と一致する数の出力
# 長さ1の巡回と解釈可能
#puts "equal_to_selfs\t=> #{ equal_to_selfs}"

# 約数を順次算出して作成される系列が素数に行き着く数の出力
#sum_of_divisors.each_pair do |key, pair|
#  sum_of_divisors[key] = pair.uniq.sort
#end
#puts "sum_of_divisors\t=> #{sum_of_divisors}"

# 上限の指定により解析不能と判断された数の出力
#puts "out_of_ranges\t=> #{out_of_ranges}"



### 巡回系列の出力 ###

def include_same_cycle?(cycles, c)
  flg = false
  cycles.each do |cycle|
    if cycle.sort == c.sort
      flg = true
      break
    end
  end
  flg
end

results = Array.new
cycles.each_key do |k|
  if results[k.size-1].nil?
    results[k.size-1] = [k.rotate(k.index(k.min))]
  else
    results[k.size-1] = ([k.rotate(k.index(k.min))] + results[k.size-1]).sort unless include_same_cycle?(results[k.size-1], k)
  end
end
results.compact!

results.each do |cycles|
  cycles.each do |cycle|
    puts "#{cycle.size}: #{cycle}"
  end
end
