require 'spidr'


require 'pry'



  def self.create_files(homePage)
    system 'mkdir', '-p', 'page_objects' unless File.directory?(Dir.pwd+"/page_objects")



    Spidr.site('http://www.seleniumframework.com/Practiceform/') do |spider|
      spider.every_html_page do |page|
        fileName = page.title.downcase.gsub(' ', "_")
        className = page.title.gsub(' ', '')
        body = page.doc.to_s
        idElements=body.scan(/\id="(.*?)"/).flatten
        nameElements=body.scan(/\name="(.*?)"/).flatten
        dataTestElements=body.scan(/\data-test="(.*?)"/).flatten

        url = page.url.to_s.partition('.com').last
        elements = element_formatter('id', idElements)
                  + element_formatter('name', nameElements)
                  + element_formatter('data-test', dataTestElements)

        path = File.join(Dir.pwd, 'page_objects', "#{fileName}.rb")
        unless File.exists?(path)
          File.open(path, 'w') {|file| file.write(base_page_object_content(url, className, elements)) }
        end
      end
    end
  end



  def self.base_page_object_content(url, className, elements)
    "module App
  class #{className} < SitePrism::Page
    set_url '#{url}'
    #fix regex set_url_matcher //
    # element :email, "input[name='email']"
    #{elements}
  end
end
"
  end


  def element_formatter(identifier, elementArray)
    elements = ''
    elementArray.each do |e|
      elements += "element :#{e}, " + '"' + "input[#{identifier}=" + "'#{e}']" + '"' + "\n"
    end
  end

end
