class StarWarsComics::Scraper

  def self.scrape_series(path, all_series)
    categories = Nokogiri::HTML(open(BASE_PATH + path)).css("div.CategoryTreeItem a")

    categories.each do |category|
      self.scrape_series(category["href"], all_series) unless self.dont_include(category)
    end

    series_link = Nokogiri::HTML(open(BASE_PATH + path)).css("div#mw-pages div a").first

    unless series_link == nil
      series = StarWarsComics::Series.new(series_link.text, series_link["href"])
      series.desc = Nokogiri::HTML(open(BASE_PATH + series.path)).css("div#mw-content-text p").first.text.sub(/\[.*\]/, "")
      all_series << series
    end

    all_series
  end

  def self.scrape_issues(series)
    issues =  Nokogiri::HTML(open(BASE_PATH + series.path)).css('td[style*="background-color:"] + td i a')

    last_issue = nil
    issues.each do |issue_link|
      issue = StarWarsComics::Issue.new(issue_link["title"], issue_link["href"])
      issue.series = series
      issue.last_issue = last_issue
      issue.last_issue.next_issue = issue unless last_issue == nil
      last_issue = issue
    end
  end

  def self.scrape_issue_info(issue)
    issue_info =  Nokogiri::HTML(open(BASE_PATH + issue.path)).css(
                  "aside.portable-infobox")

    issue.name = issue_info.css("h2.pi-title").text

    attributions = issue_info.css("section.pi-item.pi-group div.pi-item")

    attributions.each do |attrib|
      attrib_type = attrib.css("h3.pi-data-label").text
      attrib_value = attrib.css("div.pi-data-value").text.sub(/\[.*\]/, "")

      unless attrib.css("div.pi-data-value a").empty?
        attrib_link = attrib.css("div.pi-data-value a").attribute("href").value
      end

      if attrib_type == "Writer"
        issue.writer =  StarWarsComics::Artists::Writer.find_or_create_by_name(
                        attrib_value, attrib_link)
      elsif attrib_type == "Penciller"
        issue.penciller = StarWarsComics::Artists::Penciller.find_or_create_by_name(
                          attrib_value, attrib_link)
      elsif attrib_type == "Letterer"
        issue.letterer =  StarWarsComics::Artists::Letterer.find_or_create_by_name(
                          attrib_value, attrib_link)
      elsif attrib_type == "Colorist"
        issue.colorist =  StarWarsComics::Artists::Colorist.find_or_create_by_name(
                          attrib_value, attrib_link)

      elsif attrib_type == "Publication date"
        issue.pub_date = attrib_value
      elsif attrib_type == "Pages"
        issue.pages = attrib_value
      end

    end
  end

  private

  def self.dont_include(category)
    category.text == "Canon comic strips" ||
      category.text == "Star Wars Rebels Magazine comics" ||
      category.text == "Star Wars Adventures artists" ||
      category.text == "Star Wars Adventures stories" ||
      category.text == "Star Wars Adventures writers"
    end
end
