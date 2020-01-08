require 'json'
require 'elasticsearch'
require 'awesome_print'

host = ENV['ES_HOST'] || "127.0.0.1"
port = ENV['ES_PORT'] || 9200
protocol = ENV['ES_PROTOCOL'] || "http"
ES_CONFIG = [{
  host: host,
  port: port,
  scheme: protocol
}].freeze
@es_client = Elasticsearch::Client.new hosts: ES_CONFIG
puts "connected to elasticsearch host @#{protocol}://#{host}:#{port}".green
@es_create = Proc.new do |index, _type, _id, doc|
  @es_client.create(index: index, type:_type, id:_id, body: doc)
end

@es_update = Proc.new do |index, _type, _id, doc|
  @es_client.update(index: index, type:_type, id:_id, body: { doc: doc })
end
