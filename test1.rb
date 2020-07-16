require 'uri'
require 'net/http'
require 'json'

def request url_requested, api_key #Metodo API
    #capturad de url
    url = URI(url_requested+"https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=10&api_key=IUjbbtYHhBzj7GgoRv6WrLD1VA4ras04UZ6BxcK7#{api_key}")    
    https = Net::HTTP.new(url.host, url.port);    
    https.use_ssl = true
    https.verify_mode = OpenSSL::SSL::VERIFY_PEER
    request = Net::HTTP::Get.new(url)        
    #Captura de respuesta
    response = https.request(request)
    #Retorno de respuesta
    return JSON.parse(response.read_body)
end

#Metodo construcción HTML
def build_web_page list_hash
    #HASH
    response = list_hash
    #HTML
    result = "\r<html>\n\r\t<head>\n\r\t</head>\n\r\t<body>\n\r\t\t<ul>"
    #Iteración de hash y búsqueda de fotos
    response['photos'].count.times do |i|        
        result += "\n\r\t\t\t<li><img src='#{response['photos'][i]['img_src']}'></li>"        
    end
    result += "\n\r\t\t</ul>\n\r\t</body>\n\r</html>"
    File.write("index.html",result)
end


#BONUS
def photos_count list_hash
    response = list_hash
    result = {}
    result[:camara] = response['photos'][0]['camera']['full_name']
    result[:cantidad_fotos] = response['photos'].count
    result
end

#key en caso de hacer más de 50 consultas en las últimas 24 horas
build_web_pages(request("https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?",api_key))
print photos_count(request("https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?",api_key))