def sum_of_divisors(n)
  sum = 1
  (2..Math.sqrt(n).to_i).each do |i|
    if n % i == 0
      sum += (i == (n/i) ? i : i + (n/i))
    end
  end
  sum
end

n = ARGV[0].nil? ? 1 : ARGV[0].to_i
puts sum_of_divisors(n)
