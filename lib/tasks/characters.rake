namespace :characters do
  desc "Creates all the marvel characters"
  task :create => :environment do

    def api_url(offset)
      timestamp = Time.now.to_i.to_s
      hash = Digest::MD5.new.update(timestamp + ENV["private_key"] + ENV["public_key"])

      "http://gateway.marvel.com:80/v1/public/characters?apikey=#{ENV["public_key"]}&ts=#{timestamp}&hash=#{hash}&limit=100&orderBy=name&offset=#{offset}"
    end

    hydra = Typhoeus::Hydra.hydra

    char_count = Character.count
    Character.destroy_all
    puts "destroyed #{char_count} characters"


    offset = 0

    15.times do
      url = api_url(offset)
      request = Typhoeus::Request.new(url, followlocation: true)

      request.on_complete do |response|
        if response.success?
          characters = JSON.parse(response.body)["data"]["results"]
          characters.each do |c|
            name = c["name"]
            image_url = c["thumbnail"].nil? ? "http://i.annihil.us/u/prod/marvel/i/mg/b/40/image_not_available.jpg" : "#{c["thumbnail"]["path"]}.#{c["thumbnail"]["extension"]}"
            new_char = Character.create(name: name, image_url: image_url)
          end
        else
          puts "failure---->#{url}"
        end
      end

      hydra.queue(request)
      request

      offset += 100
    end

    hydra.run
    puts "created #{Character.count} characters"

  end
end