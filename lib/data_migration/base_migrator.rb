require "net/http"
require "uri"

module URI
  def self.escape(url)
    encode_www_form_component(url)
  end
end

module DataMigration
  class BaseMigrator

    private

    def process_in_threads(records, &block)
      threads = []
      records.each_slice(slice_size_for(records)) do |group|
        threads << Thread.new do
          ActiveRecord::Base.connection_pool.with_connection do
            group.each(&block)
          end
        end
      end

      threads.each(&:join)
    end

    MAX_THREADS = 3
    def slice_size_for(records)
      (records.size / MAX_THREADS.to_f).ceil
    end

    def convenience_fee_type_for_ticket_type(ticket_type)
      if ticket_type.convenience_fee_type == "flat-rate"
        TicketType::CONVENIENCE_FEE_TYPES[:flat_rate]
      else
        TicketType::CONVENIENCE_FEE_TYPES[:percentage]
      end
    end

    def download_attachment(attachment)
      download_url = URI.parse("https:#{CGI.unescape(attachment.url(:original))}")

      download_file(download_url)
    end

    def download_file(uri)
      Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == "https") do |http|
        request = Net::HTTP::Get.new(uri)

        http.request(request) do |response|
          file = Tempfile.new(binmode: true)
          response.read_body do |chunk|
            file.write(chunk)
          end
          file.rewind
          return file
        end
      end
    end
  end
end
