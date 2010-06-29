# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  include GoogleVisualization
  
  def safe_textilize( s )
    if s && s.respond_to?(:to_s)
      doc = RedCloth.new( s.to_s )
      doc.filter_html = true
      doc.to_html
    end
  end
  
  def tag_cloud(tags, classes) 
    max, min = 0, 0 
    tags.each do |tag|
        max = tag.count if tag.count > max
        min = tag.count if tag.count < min 
    end
    divisor = ((max - min) / classes.size) + 1
    
    tags.each do |tag| 
      yield tag.name, classes[(tag.count - min) / divisor]
    end
  end
  
  def popular_tags_list
    popular_tags(Bill.tag_counts)
  end
  
  def popular_tags(tags)
    #Finds the top 5 most popular tags
    # Finds in O(n) as the sort is largely neglible
    top = [[0,tags[0]],[0,tags[0]],[0,tags[0]],[0,tags[0]],[0,tags[0]]]
    tags.each do |tag|
      if tag.count > top[4][0]
        top.pop
        top << [tag.count,tag]
        top.sort!{ |a,b| b[0] <=> a[0] }
      end
    end
    return top.collect{|a| a[1]}
  end
  
end
