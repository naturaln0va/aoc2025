# This script was written for the advent of code 2025 day 2.
# https://adventofcode.com/2025/day/2

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
    first_test_input = "11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124"
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
    lines = input.lines.map(&:strip)
    ranges = input.split(",").map { |r|
      from, to = r.split("-").map(&:to_i)
      range = from..to
    }

    invalid = Array.new

    ranges.each do |r|
      r.each do |i|
        str = i.to_s
        mid = str.length / 2
        parts = [str[0...mid], str[mid..]]
        if parts[0] == parts[1]
          invalid << i
        end
      end
    end

    invalid.sum
  end

  def solve_second(input)
    lines = input.lines.map(&:strip)
    ranges = input.split(",").map { |r|
      from, to = r.split("-").map(&:to_i)
      range = from..to
    }

    invalid = Array.new

    ranges.each do |r|
      r.each do |i|
        if is_repeating?(i)
          invalid << i
        end
      end
    end

    invalid.sum
  end

  def is_repeating?(num)
    str = num.to_s
    mid = str.length / 2
    candidate = str[0]

    while candidate.length <= mid
      test = candidate * (str.length / candidate.length)
      if test == str
        return true
      end

      candidate = str[0..candidate.length]
    end

    false
  end
end

s = Solver.new(day = 2)
s.test_case
puts("")
s.decipher
