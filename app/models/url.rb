class Url < Content
  def aftersave    
  end

  def html
    if (title)
      '<a href="'+meta+'" >'+title+'</a>'
    else
      '<a href="'+meta+'" >'+meta+'</a>'
    end
  end
  def as_json(options = {})
    if (!options)
      options = {}
    end
    options[:html] = html
    super.as_json()
  end

end