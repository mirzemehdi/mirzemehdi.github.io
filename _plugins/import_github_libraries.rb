require 'uri'
require 'net/http'
require 'json'
require 'nokogiri'
module Jekyll
  class JekyllGithubLibraries < Generator
    safe true
    priority :high
def generate(site)
      jekyll_coll = Jekyll::Collection.new(site, 'libraries')
      site.collections['libraries'] = jekyll_coll
      uri = URI("https://mirzemehdi.com/libraries.json")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      request = Net::HTTP::Get.new(uri)
      response = http.request(request)
      data = JSON.parse(response.read_body)
      data['items'].each do |item|
        title = item['title']
        description = item['description']
        readme_url = item['readme_url']
        pathTitle = title.downcase.gsub(' ', '-')
        path = "#{pathTitle}.md"
        path = site.in_source_dir(path)
        doc = Jekyll::Document.new(path, { :site => site, :collection => jekyll_coll })
        puts "====== #{title} ======"
        puts "#{item['url']}"
        doc.data['title'] = title;
        doc.data['link'] = item['url'];
        # doc.data['description'] = item['description'];



        # Fetch README content from GitHub API
        # readme_uri = URI(readme_url)
        # readme_response = Net::HTTP.get(readme_uri).force_encoding 'utf-8'
        # doc.content = readme_response

        jekyll_coll.docs << doc
      end
    end
  end
end