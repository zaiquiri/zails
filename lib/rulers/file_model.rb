require "multi_json"

module Rulers
  module Model
    class FileModel
      def initialize(filename)
        @filename = filename
        basename = File.split(filename)[-1]
        @id = File.basename(basename, ".json").to_i
        obj = File.read(filename)
        @hash = MultiJson.load(obj)
      end

      def [](name)
        @hash[name.to_s]
      end

      def []=(name, value)
        @hash[name.to_s] = value
      end

      def self.find(id)
        begin
          FileModel.new("db/quotes/#{id}.json")
        rescue Exception => e
          p e.backtrace
          p e
          return nil
        end
      end

      def self.all
        files = Dir["db/quotes/*.json"]
        files.map { |file| FileModel.new(file) }
      end

      def create(attrs)
        feilds = {}
        feilds["submitter"] = attrs[:submitter]
        feilds["quote"] = attrs[:quote]
        feilds["attribution"] = attrs[:attribution]

        files = Dir["db/quotes/*.json"]
        names = files.map { |f| f.split("/")[-1]}
        highest = names.map { |n| n[0...-5].to_i }.max
        id = highest + 1

        File.open("db/quotes/#{id}.json", "w") do |f|
          f.write <<-TEMPLATE
          {
            "submitter" : "#{feilds["submitter"]}",
            "quote" : "#{feilds["quote"]}",
            "attribution" : "#{feilds["attribution"]}"
          }
          TEMPLATE
        end

        FileModel.new "db/quotes/#{id}.json"

      end

      def update(attrs)
        id = attrs[:id]
        raw_file = File.read("db/quotes/#{id}.json")
        obj_as_hash = MultiJson.load(raw_file)
        obj_as_hash.each { |key, value| obj_as_hash[key] = attrs[key] }
        save(obj_as_hash, id)
      end

      private

        def save(obj, id)
          new_json = MultiJson.dump(obj)
          File.open("db/quotes/#{id}.json", "w") { |f| f.write(new_json) }
        end

    end 
  end
end
