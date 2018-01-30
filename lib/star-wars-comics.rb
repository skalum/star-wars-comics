def list_all_series
  Series.all.sort_by {|series| series.name}.each_with_index do |series, i|
    puts "#{i+1}. #{series.name}"
  end

  input = get_input("a series", 1, Series.all.length)
  list_issues_for_series(Series.all[input-1])
end

def list_issues_for_series(series)
  puts "Getting issues..."
  Scraper.scrape_issues(series)

  series.issues.each_with_index do |issue, i|
    puts "#{i+1}. #{issue.name}"
  end

  input = get_input("an issue", 1, series.issues.length)
  show_info_for_issue(series.issues[input-1])
end

def show_info_for_issue(issue)
  puts "\nIssue: #{issue.name}"
  puts "  Series: #{issue.series.name}"
  puts "  Publication date: #{issue.pub_date}"
  puts "  Pages: #{issue.pages}"
  puts "  Artists:"
  puts "    Writer: #{issue.writer.name}"
  puts "    Penciller: #{issue.penciller.name}"
  puts "    Letterer: #{issue.letterer.name}"
  puts "    Colorist: #{issue.colorist.name}"
end

def get_input(picking, min, max)
  puts "\nEnter a number to choose #{picking}, or enter \"exit\" to quit."

  loop do
    input = gets.strip.downcase

    if input == "exit"
      exit
    elsif input.to_i.between?(min, max)
      return input.to_i
    else
      puts "Please enter a number between #{min} and #{max}, or type \"exit.\""
    end
  end
end
