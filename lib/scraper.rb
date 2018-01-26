class Scraper

  def self.scrape_series(path)
    titles =  Nokogiri::HTML(open(BASE_PATH + path)).css(
              "div.CategoryTreeSection a")

    titles.each do |title|
      Series.find_or_create_by_name(title.text.strip, title["href"])
    end
  end

  def self.scrape_issues(series)
    issues =  Nokogiri::HTML(open(BASE_PATH + series.path)).css(
              "div.mw-content-ltr ul li a")

    issues.each do |issue|
      if issue.text.match?(/Star\sWars\s\d+.*/)
        Issue.find_or_create_by_name(issue.text.strip, issue["href"]).
              series = series
      end
    end
  end

  def self.scrape_issue_info(issue)
    issue_info =  Nokogiri::HTML(open(BASE_PATH + issue.path)).css(
                  "aside.portable-infobox")

    issue.name = issue_info.css("h2.pi-title").text

    attributions = issue_info.css("section.pi-item.pi-group div.pi-item")

    attributions.each do |attrib|
      attrib_type = attrib.css("h3.pi-data-label").text
      attrib_value = attrib.css("div.pi-data-value a").text.sub(/\[.*\]/, "")

      unless attrib.css("div.pi-data-value a").empty?
        attrib_link = attrib.css("div.pi-data-value a").attribute("href").value
      end

      if attrib_type == "Writer"
        issue.writer =  Artists::Writer.find_or_create_by_name(
                        attrib_value, attrib_link)
      elsif attrib_type == "Penciller"
        issue.penciller = Artists::Penciller.find_or_create_by_name(
                          attrib_value, attrib_link)
      elsif attrib_type == "Letterer"
        issue.letterer =  Artists::Letterer.find_or_create_by_name(
                          attrib_value, attrib_link)
      elsif attrib_type == "Colorist"
        issue.colorist =  Artists::Colorist.find_or_create_by_name(
                          attrib_value, attrib_link)

      elsif attrib_type == "Publication date"
        issue.pub_date = attrib.css("div.pi-data-value a").text
      elsif attrib_type == "Pages"
        issue.pages = attrib.css("div.pi-data-value a").text
      end

    end
  end

end
