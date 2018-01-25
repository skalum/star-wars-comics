class Scraper

  def self.scrape_series(path)
    titles = Nokogiri::HTML(open(path)).css("div.CategoryTreeSection a")

    titles.each do |title|
      Series.find_or_create_by_name(title.text.strip).url = title["href"]
    end
  end

  def self.scrape_issues(path)
    issues = Nokogiri::HTML(open(path)).css("div.mw-content-ltr ul li a")

    issues.each do |issue|
      if issue.text.match?(/Star\sWars\s\d+.*/)
        puts issue.text
        Issues.find_or_create_by_name(issue.text.strip).url = issue["href"]
      end
    end
  end

  def self.scrape_issue_info(issue)
    issue_info = Nokogiri::HTML(open(issue.url)).css("aside.portable-infobox")

    issue.title = issue_info.css("h2.pi-title").text

    attributions = issue_info.css("section.pi-item.pi-group div.pi-item")

    attributions.each do |attrib|
      attrib_text = attrib.css("h3.pi-data-label").text
      if attrib_text == "Writer"
        issue.writer =  Artists::Writer.find_or_create_by_name(
                        attrib.css("div.pi-data-value").text)
      elsif attrib_text == "Penciller"
        issue.penciller = Artists::Penciller.find_or_create_by_name(
                          attrib.css("div.pi-data-value").text)
      elsif attrib_text == "Letterer"
        issue.letterer =  Artists::Letterer.find_or_create_by_name(
                          attrib.css("div.pi-data-value").text)
      elsif attrib_text == "Colorist"
        issue.colorist =  Artists::Colorist.find_or_create_by_name(
                          attrib.css("div.pi-data-value").text)
      elsif attrib_text == "Publication date"
        issue.pub_date = attrib.css("div.pi-data-value").text
      elsif attrib_text == "Pages"
        issue.pages = attrib.css("div.pi-data-value").text
      end

    end
  end

end
