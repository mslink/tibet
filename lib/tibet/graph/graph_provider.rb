
module Tibet

  GRAPHML_EXTENSION = 'graphml',freeze
  #REGEX_FN_FORMAT   = /^[:a-z0-9_-]+\.graphml$/.freeze
  REGEX_FN_FORMAT   = /^[:A-Za-z0-9_-]+\.graphml$/.freeze

  class GraphProvider

    attr_reader :schema_path

    def initialize(schema_path)
      @schema_path = schema_path
    end

    def source_pattern
      # follow symbolic links with /**{,/*/**}/
      "#{schema_path}/**{,/*/**}/*.#{GRAPHML_EXTENSION}"
    end

    def deliver
      file_list = determine_schema_file_list

      # fail "-- error: no schema files found in #{source_pattern}" if file_list.empty?
      # abort "-- warning: no schema files found in #{@schema_path}" if file_list.empty?

      if file_list.empty?
        pp "-- warning: no schema files found in #{@schema_path}"
        return
      end

      unless check_file_list_unique(file_list)
        duplicates = file_list.detect { |e| !file_list.rindex(e).eql?(file_list.index(e)) }
        puts "-- warning: file names may not be unique, see ..#{duplicates[-64..-1]}"
        puts "-- info: will remove duplicates"
        file_list.uniq!
      end

      unless check_file_naming_conventions(file_list)
        abort "-- error: file naming convention violation, follow #{REGEX_FN_FORMAT}"
      end

      parsers = create_parsers(file_list)

      GraphBuilder.new(parsers).perform
    end

    def determine_schema_file_list
      file_list = Dir[source_pattern]
      file_list.select! do |fn|
        if fn =~ /:ignore/
          puts "-- info: ignoring ..#{fn[-64..-1]}"
          false
        else
          true
        end
      end

      file_list
    end

    def check_file_list_unique(file_list)
      file_list.uniq.count.eql?(file_list.count)
    end

    def check_file_naming_conventions(file_list)
      file_list.map { |path| File.basename(path) }.all? { |fn| fn =~ REGEX_FN_FORMAT }
    end

    def create_parsers(file_list)
      file_list.map{ |fn| Parser.new(fn) }
    end

  end

end