def list_all_series
  Series.all.sort_by {|series| series.name}.each_with_index do |series, i|
    puts "#{i+1}. #{series.name}"
  end

  loop do
    input = get_input(1, Series.all.length)

    if input.class == Integer
      list_issues_for_series(Series.all[input-1])
      list_all_series
      break
    elsif input == "back"
      break
    elsif Series.find_by_name(input) != nil
      list_issues_for_series(Series.find_by_name(input))
      list_all_series
      break
    else
      puts "Could not find a series with that name. Please try again!"
      sleep(1)
    end
  end

end

def list_issues_for_series(series)
  series.issues.each_with_index do |issue, i|
    puts "#{i+1}. #{issue.name}"
  end

  loop do
    input = get_input(1, series.issues.length)

    if input.class == Integer
      show_info_for_issue(series.issues[input-1])
      list_issues_for_series(series)
      break
    elsif input == "back"
      break
    elsif Issue.find_by_name(input)
      show_info_for_issue(Issue.find_by_name(input))
      list_issues_for_series(series)
      break
    else
      puts "Could not find an issue with that name. Please try again!"
      sleep(1)
    end
  end

end

def show_info_for_issue(issue)
  puts "\nIssue: #{issue.name}"
  puts "  Series: #{issue.series.name}"
  puts "  Publication date: #{issue.pub_date}"
  puts "  Pages: #{issue.pages}"
  puts "  Artists:"
  puts "    Writer: #{issue.writer.name if issue.writer}"
  puts "    Penciller: #{issue.penciller.name if issue.penciller}"
  puts "    Letterer: #{issue.letterer.name if issue.letterer}"
  puts "    Colorist: #{issue.colorist.name if issue.colorist}"
  puts "\nPress \[Enter\] to return to the previous menu."
  gets
end

def get_input(min, max)
  puts "Please enter a number or name, or type \"exit\" to quit."

  loop do
    input = gets.strip

    if input.downcase == "exit"
      exit
    elsif input.to_i.between?(min, max)
      return input.to_i
    elsif !input.match?(/0+/) && input.to_i == 0
      return input
    else
      puts "Please enter a name, a number between #{min} and #{max}, or type \"exit.\""
    end
  end
end
