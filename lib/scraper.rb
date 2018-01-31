class Scraper

  def self.scrape_series(path)
    categories = Nokogiri::HTML(open(BASE_PATH + path)).css("div.CategoryTreeItem a")

    categories.each do |category|
      self.scrape_series(category["href"]) unless self.dont_include(category)
    end

    series_link = Nokogiri::HTML(open(BASE_PATH + path)).css("div.mw-content-ltr ul li:not(.interwiki-ru) a").first

    unless series_link == nil
      series = Series.find_or_create_by_name(series_link.text, series_link["href"])
      series.desc = Nokogiri::HTML(open(BASE_PATH + series.path)).css("div#mw-content-text p").first.text.sub(/\[.*\]/, "")
    end
  end

  def self.scrape_issues(series)
    issues =  Nokogiri::HTML(open(BASE_PATH + series.path)).css(
              "div.mw-content-ltr ul li a")

    issues.each do |issue|
      Issue.find_or_create_by_name(issue.text.strip, issue["href"]).
                                                                series = series
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
