FILE_PATH = "./numbers.dat"
SEP = ","

N = ARGV[0].nil? ? 10 : ARGV[0].to_i

numbers = Array.new(N+1, :p)
numbers[0..1] = [nil, nil]

# 素数の判定: 素数 => :p
(2..Math.sqrt(N).to_i).each do |i|
  if numbers[i] == :p
    (2..(N/i)).each do |j|
      numbers[i*j] = nil
    end
  end
end


# 約数の和を返す
def sum_of_divisors(n)
  sum = 1
  (2..Math.sqrt(n).to_i).each do |i|
    if n % i == 0
      sum += (i == (n/i) ? i : i + (n/i))
    end
  end
  sum
end

# 約数の和を設定
(2..N).each do |n|
  next unless numbers[n].nil?

  numbers[n] = sum_of_divisors(n)
end


# ファイルへの出力
open(FILE_PATH, "w") do |f|
  f.print numbers.join(SEP)
  f.puts
end


#p numbers
