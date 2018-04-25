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
    StarWarsComics::Series.all
    puts "Done!"

    loop do
      puts "\nWould you like to list series (fast) or by artist (will need additional download)?"
      puts "Or, type \"exit\" to quit."
      input = gets.strip
      input.downcase!

      if input == "exit" || input == "quit"
        exit
      elsif input.include?("series")
        list_all_series
      elsif input.include?("artist")
        list_all_artists
      else
        puts "\nPlease enter \"series,\" \"artist,\" or \"exit.\""
        sleep(2)
      end
    end

  end

  def list_all_series
    puts " _____________________________________________________________________________ "
    puts "|:..                                                             ``:::%%%%%%HH|"
    puts "|%%%:::::..           C o m i c    B o o k    S e r i e s           `:::::%%%%|"
    puts "|HH%%%%%:::::.....______________________________________________________::::::|\n\n"

    sleep(1)

    StarWarsComics::Series.all.each_with_index do |series, i|
      puts "#{i+1}. #{series.name}"
    end

    loop do
      input = get_input("a series", 1, StarWarsComics::Series.all.length)

      if input.class == Fixnum
        list_issues_for_series(StarWarsComics::Series.find(input))
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

      if input.class == Fixnum
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

  def list_all_artists
    puts " _____________________________________________________________________________ "
    puts "|:..                                                             ``:::%%%%%%HH|"
    puts "|%%%:::::..          C o m i c    B o o k    A r t i s t s          `:::::%%%%|"
    puts "|HH%%%%%:::::.....______________________________________________________::::::|\n\n"
    puts "Downloading all artist info. This could take a while..."

    StarWarsComics::Series.all.each do |series|
      StarWarsComics::Scraper.scrape_issues(series) if series.issues.empty?
    end

    StarWarsComics::Artist.sort_alpha

    puts "Done! Listing...\n\n"
    sleep(2)

    StarWarsComics::Artist.all.each_with_index do |artist, i|
      puts "#{i+1}. #{artist.name}"
    end

    loop do
      input = get_input("an artist", 1, StarWarsComics::Artist.all.length)

      if input.class == Fixnum
        show_info_for_artist(StarWarsComics::Artist.find(input))
        list_all_artists
        break
      elsif input == "back"
        break
      elsif StarWarsComics::Artist.find_by_name(input) != nil
        show_info_for_artist(StarWarsComics::Artist.find_by_name(input))
        list_all_artists
        break
      else
        puts "Could not find an artist with that name. Please try again!"
        sleep(1)
      end
    end

  end

  def show_info_for_artist(artist)
    puts "Artist: #{artist.name}"
    puts "  Artist type: #{artist.class}".gsub("StarWarsComics::Artists::", "")
    puts "  Issues:"

    artist.issues.each {|issue| puts "    #{issue.name}"}

    puts "\nPress \[Enter\] to return to the previous menu."
    gets
  end


  def get_input(picking, min, max)
    puts "\nPick #{picking}--please enter by number or name. Type \"back\" to go back or \"exit\" to quit."

    loop do
      input = gets.strip

      if input.downcase == "exit" || input.downcase == "quit"
        exit
      elsif input.to_i.between?(min, max)
        return input.to_i
      elsif !input.match(/0+/) && input.to_i == 0
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
