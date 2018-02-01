class StarWarsComics::CLI
  def call
    start
  end

  def start
    puts "    .           .        .                     .        .            ."
    puts "              .               .    .          .              .   .         ."
    puts "                _________________      ____         __________"
    puts "  .       .    /                 |    /    \\    .  |          \\"
    puts "      .       /    ______   _____| . /      \\      |    ___    |     .     ."
    puts "              \\    \\    |   |       /   /\\   \\     |   |___>   |"
    puts "            .  \\    \\   |   |      /   /__\\   \\  . |         _/               ."
    puts "  .     ________>    |  |   | .   /            \\   |   |\\    \\_______    ."
    puts "       |            /   |   |    /    ______    \\  |   | \\           |"
    puts "       |___________/    |___|   /____/      \\____\\ |___|  \\__________|    ."
    puts "   .     ____    __  . _____   ____      .  __________   .  _________"
    puts "        \\    \\  /  \\  /    /  /    \\       |          \\    /         |      ."
    puts "         \\    \\/    \\/    /  /      \\      |    ___    |  /    ______|  ."
    puts "          \\              /  /   /\\   \\ .   |   |___>   |  \\    \\"
    puts "    .      \\            /  /   /__\\   \\    |         _/.   \\    \\            +"
    puts "            \\    /\\    /  /            \\   |   |\\    \\______>    |   ."
    puts "             \\  /  \\  /  /    ______    \\  |   | \\              /          ."
    puts "  .       .   \\/    \\/  /____/      \\____\\ |___|  \\____________/  LS"
    puts "                                .                                        ."
    puts "      .                           .         .               .                 ."
    puts "                 .                                   .            ."

    puts "Welcome to Star Wars Comics! Getting all the series..."
    StarWarsComics::Scraper::scrape_series("/wiki/Category:Canon_comics")
    puts "Done! Listing...\n\n"
    sleep(2)
    self.list_all_series
  end

  def list_all_series
    puts " _____________________________________________________________________________ "
    puts "|:..                                                             ``:::%%%%%%HH|"
    puts "|%%%:::::..           C o m i c    B o o k    S e r i e s           `:::::%%%%|"
    puts "|HH%%%%%:::::.....______________________________________________________::::::|\n\n"
    StarWarsComics::Series.all.each_with_index do |series, i|
      puts "#{i+1}. #{series.name}"
    end

    loop do
      input = get_input("a series", 1, StarWarsComics::Series.all.length)

      if input.class == Integer
        list_issues_for_series(StarWarsComics::Series.all[input-1])
        list_all_series
        break
      elsif input == "back"
        break
      elsif StarWarsComics::Series.find_by_name(input) != nil
        list_issues_for_series(StarWarsComics::Series.find_by_name(input))
        list_all_series
        break
      else
        puts "Could not find a series with that name. Please try again!"
        sleep(1)
      end
    end

  end

  def list_issues_for_series(series)
    if series.issues.empty?
      puts "\nGetting issues for #{series.name}..."
      StarWarsComics::Scraper.scrape_issues(series)
      puts "Done! Listing...\n\n"
      sleep(2)
    end

    put_title(series.name)

    series.issues.each_with_index do |issue, i|
      puts "#{i+1}. #{issue.name}"
    end

    loop do
      input = get_input("an issue", 1, series.issues.length)

      if input.class == Integer
        show_info_for_issue(series.issues[input-1])
        list_issues_for_series(series)
        break
      elsif input == "back"
        break
      elsif StarWarsComics::Issue.find_by_name(input)
        show_info_for_issue(StarWarsComics::Issue.find_by_name(input))
        list_issues_for_series(series)
        break
      else
        puts "\nCould not find an issue with that name. Please try again!"
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

  def get_input(picking, min, max)
    puts "\nPick #{picking}--please enter by number or name. Type \"exit\" to quit."

    loop do
      input = gets.strip

      if input.downcase == "exit" || input.downcase == "quit"
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

  def put_title(title)
    puts " ______________________________________________________________________"
    puts "|:..                                                      ``:::%%%%%%HH|"
    puts "|%%%:::::.." +              title.center(50)              + "`:::::%%%%|"
    puts "|HH%%%%%:::::....._______________________________________________::::::|\n\n"
  end

end
