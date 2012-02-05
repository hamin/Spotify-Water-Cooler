# Complile stylesheets for production using:
# compass compile --force

if defined?(Sinatra) # Running within sinatra
  project_path = Sinatra::Application.root
  environment = :development
else # command line tool
  css_dir = File.join 'public', 'stylesheets'
  relative_assets = true
  environment = :production
end

# Common Config
sass_dir = File.join 'views', 'stylesheets'
images_dir = File.join 'public', 'images'
http_path = "/"
http_images_path = "/images"
http_stylesheets_path = "/stylesheets"
output_style = :compressed