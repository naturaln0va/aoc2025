# This script was written for the advent of code 2025 day 5.
# https://adventofcode.com/2025/day/5

require "uri"
require "net/http"

class Solver
  def initialize(day, year = 2025)
    @day = day
    @year = year
  end

  def fetch_input
    input_directory = "input"
    unless Dir.exist?(input_directory)
      Dir.mkdir(input_directory)
    end

    input_file_name = "#{@year}-#{@day}-input.txt"
    input_file_path = File.join(input_directory, input_file_name)

    if File.exist?(input_file_path)
      input_file = File.open(input_file_path)
      @input = input_file.read.chomp
      input_file.close
      return
    end

    auth_filename = "cookie.txt"
    unless File.exist?(auth_filename)
      abort("\"cookie.txt\" is required to get the puzzle input for your account.")
    end

    cookie_file = File.open(auth_filename)

    uri = URI("https://adventofcode.com/#{@year}/day/#{@day}/input")
    cookie_value = cookie_file.read.chomp
    user_agent = "github.com/naturaln0va/aoc2025 by Ryan Ackermann"
    headers = {"Cookie" => "session=#{cookie_value}", "User-Agent" => user_agent}

    cookie_file.close

    puts("fetching the puzzle input for day #{@day}...")
    res = Net::HTTP.get_response(uri, headers)

    unless res.is_a?(Net::HTTPSuccess)
      abort("HTTP Error: #{res.code} - #{res.body}")
    end

    @input = res.body

    File.write(input_file_path, @input)
  end

  def test_case
    puts("===TEST===")
    first_test_input = "3-5
10-14
16-20
12-18

1
5
8
11
17
32"
    first_answer = solve_first(first_test_input)
    puts("1st answer: #{first_answer}")
    second_test_input = first_test_input
    second_answer = solve_second(second_test_input)
    puts("2nd answer: #{second_answer}")
  end

  def decipher
    fetch_input
    puts("===PUZZLE===")
    first_answer = solve_first(@input)
    puts("1st answer: #{first_answer}")
    second_answer = solve_second(@input)
    puts("2nd answer: #{second_answer}")
  end

  def solve_first(input)
    answer = 0

    parts = input.split("\n\n")
    first = parts[0].lines.map(&:strip)
    second = parts[1].lines.map(&:strip)
    ingredient_ids = second.map { |s| s.to_i }

    ranges = first
      .map { |r|
        from, to = r.split("-").map(&:to_i)
        range = from..to
      }
      .sort { |a, b| a.min <=> b.min }
      .reverse

    offset = 0
    while offset < ranges.length - 1
      a = ranges[offset]
      b = ranges[offset + 1]
      if a.overlap?(b)
        min_min = [a.min, b.min].min
        max_max = [a.max, b.max].max
        ranges[offset] = min_min..max_max
        ranges.delete_at(offset + 1)
        offset = 0
      else
        offset += 1
      end
    end

    ingredient_ids.each do |id|
      ranges.each do |r|
        if r.member?(id)
          answer += 1
        end
      end
    end

    answer
  end

  def solve_second(input)
    parts = input.split("\n\n")
    first = parts[0].lines.map(&:strip)

    ranges = first
      .map { |r|
        from, to = r.split("-").map(&:to_i)
        range = from..to
      }
      .sort { |a, b| a.min <=> b.min }
      .reverse

    offset = 0
    while offset < ranges.length - 1
      a = ranges[offset]
      b = ranges[offset + 1]
      if a.overlap?(b)
        min_min = [a.min, b.min].min
        max_max = [a.max, b.max].max
        ranges[offset] = min_min..max_max
        ranges.delete_at(offset + 1)
        offset = 0
      else
        offset += 1
      end
    end

    ranges.map(&:count).sum
  end
end

s = Solver.new(day = 5)
s.test_case
puts("")
s.decipher
