module ApplicationHelper
  def build_filter_path(key, value)
    parameters = {
      category: params[:category],
      hero: params[:hero],
      map: params[:map],
      from: params[:from],
      to: params[:to],
      sort: params[:sort],
      expired: params[:expired],
      author: params[:author],
      search: params[:search]
    }

    parameters[key] = value

    if parameters.values.all? { |v| v.nil? }
      return root_path
    else
      return filter_path(parameters)
    end
  end

  def non_www_url
    url = request.original_url
    url.gsub("www.", "")
  end

  def is_wiki?
    controller_path.split('/').first == "wiki" ? true : false
  end

  def to_slug(string)
    string.to_s.downcase.gsub(" ", "-").gsub(":", "").gsub(".", "").gsub("'", "")
  end

  def maps
    YAML.load(File.read(Rails.root.join("config/arrays", "maps.yml")))
  end

  def heroes
    YAML.load(File.read(Rails.root.join("config/arrays", "heroes.yml")))
  end

  def categories
    YAML.load(File.read(Rails.root.join("config/arrays", "categories.yml")))
  end

  def quotes
    YAML.load(File.read(Rails.root.join("config/arrays", "quotes.yml")))
  end
end
