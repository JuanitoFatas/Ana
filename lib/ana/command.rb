require 'thor'
require 'net/http'
require 'json'
require 'launchy'

module Ana
  class Command < Thor
    include Ana::Scalars
    include Thor::Actions

    # Command Mapping
    map '-v'        => :version
    map '--version' => :version
    # Meta
    map 'info'      => :gem_infos
    map 'deps'      => :gem_dependencies
    # Version
    map 'lv'        => :latest_version
    map 'vs'        => :versions
    map 'fv'        => :find_version
    # Search
    map 's'         => :search
    map 'fs'        => :fuzzy_search
    # Open URI
    map 'o'         => :open
    map 'dl'        => :download

    # Create an empty diretory at ~/.gemjsons
    # All later queried JSON files will be saved here.
    desc 'init', 'Ana needs to setup some stuff in your home directory.'
    def init
      empty_directory full_path('~/.gemjsons')
    end

    desc 'version (-v, --version)', 'Display version of Ana.'
    def version
      say "#{Ana::VERSION::STRING}"
    end

    # Print Given Gem's Short description, download counts, latest version,
    # author(s), and license information.
    desc 'gem_infos (info)', 'Print Gem Informations'
    def gem_infos(gem)
      gem_hash = check_if_gem_exist_and_get_json!(gem, type: 'gems')
      say gem_hash['info']
      say "Has been downloaded for #{colorize(gem_hash['downloads'], RED)} times!"
      say "The Latest version is #{colorize(gem_hash['version'], BLUE)}."
      say "Respectful Author(s): #{colorize(gem_hash['authors'], YELLOW)}."
      if gem_hash['licenses'][0].nil?
        say "NO LICENSE :P"
      else
        say "LICENSE under #{colorize(gem_hash['licenses'][0], MAGENTA)}"
      end
    end

    # List dependencies of a given Gem.
    # You could pass 'runtime' / 'development' to see different dependencies.
    # type: 'runtime', 'development'
    desc 'gem_dependencies (deps)', 'Print Gem Dependencies (runtime / development).'
    def gem_dependencies(gem, type='runtime')
      gem_hash = check_if_gem_exist_and_get_json!(gem, type: 'gems')
      gem_hash['dependencies'][type].each do |arr|
        puts "#{arr['name'].ljust(20)} #{arr['requirements']}"
      end
    end

    # Return latest version of given gem.
    desc 'latest_version (v)', 'latest version of a gem.'
    def latest_version(gem)
      gem_hash = check_if_gem_exist_and_get_json!(gem, type: 'gems')
      say("Latest version is #{gem_hash['version']}.", :blue)
    end

    # List versions of a given Gem, default will only list last 10 versions.
    # You can pass all or a fairly large number to display all versions.
    desc 'versions (vs)', 'List versions of a gem.'
    def versions(gem, count=10)
      gem_hash = check_if_gem_exist_and_get_json!(gem, type: 'versions')
      if count == 'all' || count.to_i > gem_hash.count
        count = gem_hash.count
      end
      say("Last #{count} versions of #{gem} are...")
      [*0..count-1].each do |n|
        say("#{gem_hash[n]['built_at'][0..9]} : #{gem_hash[n]['number']}")
      end
    end

    # Find if a given version of Gem exists.
    desc 'version exist?', 'Find if a given version exists.'
    def find_version(gem, ver)
      gem_hash = check_if_gem_exist_and_get_json!(gem, type: 'versions')
      versions = gem_hash.collect { |x| x['number'] }
      if versions.include? ver
        gem_infos gem
      else
        print_gem_version_not_found!
      end
    end

    # Search if a given Gem exists? If exists, return the latest version of it.
    desc 'search (s)', '(Exact) Search for a gem.'
    def search(gem)
      latest_version(gem) if gem_exist?(gem)
    end

    # Invoke system `gem search -r`
    desc 'fuzzy_search (fs)', 'Fuzzy search for a Gem'
    def fuzzy_search(gem)
      system("gem search -r #{Shellwords.escape gem}")
    end

    # Open the URIs of a given Gem.
    # Available URI types could be found in Ana::Scalars::URI_TYPE.
    desc 'open (o)', 'Open gem doc directly via open command.'
    def open(gem, open_type='doc')
      gem_hash = check_if_gem_exist_and_get_json!(gem, type: 'gems')
      url = if URI_TYPE.keys.include? open_type
              skip = false
              gem_hash[URI_TYPE[open_type]]
            else
              say "#{open_type} is not a valid type :( \n"
              print_valid_uri_open_types!
              skip = true
              gem_hash[URI_TYPE['doc']]
            end
      Launchy.open(url) if url.present? && skip == false
    end

    # Download a given Gem.
    desc 'download (dl)', 'Download a Gem'
    def download(gem)
      open gem, 'lib'
    end

    private

      # Add color to terminal text.
      # Available colors could be found in Ana::Scalars.
      # \033 is 100% POSIX compatible. Use \e is also fine.
      def colorize(text, color_code)
        "\033[#{color_code}m#{text}\033[0m"
      end

      # Print all valid URI types.
      def print_valid_uri_open_types!
        say "Available types are: "
        URI_TYPE.keys.each do |key|
          next if key == 'lib'
          print "#{key} "
        end
        print "\n"
      end

      # Check if a Gem exists, if exists load the json and return.
      # The real load will execute every TTL (900) seconds.
      # type: 'versions', 'gems'
      # @return [Hash]
      def check_if_gem_exist_and_get_json!(gem, type: 'versions')
        if gem_exist?(gem)
          gem_uri = URI("https://rubygems.org/api/v1/#{type}/#{gem}.json")
          gem_json_file_path = full_path("~/.gemjsons/#{gem}/#{type}.json")
          unless File.exist?(gem_json_file_path) && fresh?(gem_json_file_path)
            remove_and_create_file!(gem_json_file_path, Net::HTTP.get(gem_uri))
          end
        else
          print_gem_not_found!
        end
        return JSON.parse(IO.read(gem_json_file_path))
      end

      # Check if a given gem exists?
      def gem_exist?(gem)
        uri = URI "https://rubygems.org/api/v1/gems/#{gem}.json"
        return false if GEM_NOT_FOUND == Net::HTTP.get(uri)
        return true
      end

      # Print Gem version not found message.
      def print_gem_version_not_found!
        say(GEM_VER_NOT_FOUND, :red)
      end

      # Print Gem not found message.
      def print_gem_not_found!
        say(GEM_NOT_FOUND, :red)
      end

      # Remove and create (update) a file.
      def remove_and_create_file!(file_path, data)
        if File.exist? file_path
          remove_file(file_path, verbose: false)
          create_file(file_path, data, verbose: false)
          say_status(:update, file_path)
        else
          create_file(file_path, data)
        end
      end

      # Expand the full path of given relative path.
      def full_path(relative_path)
        File.expand_path(relative_path)
      end

      # Check if a file is has been changed within 900s?
      def fresh?(file_path)
        access_time(file_path) < TTL
      end

      # Return a file's change time with respect to current time.
      def access_time(file_path)
        Time.now - File.ctime(file_path)
      end
  end
end