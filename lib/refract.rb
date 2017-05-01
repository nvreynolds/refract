require 'spidr'

class FactoryBro
  def self.create(homePage)
    system 'mkdir', '-p', 'page_objects' unless File.directory?(Dir.pwd+"/page_objects")

    Spidr.site(homePage) do |spider|
      spider.every_html_page do |page|
        fileName = page.title.downcase.gsub(' ', "_").delete('|')
        className = page.title.gsub(' ', '').delete('|')
        body = page.doc.to_s
        idElements=body.scan(/\id="(.*?)"/).flatten
        nameElements=body.scan(/\name="(.*?)"/).flatten
        dataTestElements=body.scan(/\data-test="(.*?)"/).flatten
        url = page.url.to_s.partition('.com').last
        elements = element_formatter('id', idElements)
        elements += element_formatter('name', nameElements)
        elements += element_formatter('data-test', dataTestElements)

        path = File.join(Dir.pwd, 'page_objects', "#{fileName}.rb")
        unless File.exists?(path)
          File.open(path, 'w') {|file| file.write(base_page_object_content(url, className, elements)) }
        end
      end
    end
  end

  private

  def self.base_page_object_content(url, className, elements)
    "module App
  class #{className} < SitePrism::Page
    set_url '#{url}'
    #fix regex set_url_matcher //
#{elements}
  end
end
"
  end

  def self.element_formatter(identifier, elementArray)
    elements = ''
    elementArray.each do |e|
      elements += "    element :#{e}, " + '"' + "[#{identifier}=" + "'#{e}']" + '"' + "\n"
    end
    elements
  end
end
