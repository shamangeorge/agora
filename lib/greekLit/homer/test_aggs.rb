require_relative '../config-es'
require_relative '../config-i18n'

doc = {
  aggs: {
    word: {
      terms: {
        field: "word_stripped.keyword",
        size: 50
      }
    }
  }
}
_index = "homer-iliad"
_type = "word"
#res = @es_client.search(index: _index, type:_type, body: doc)
res = @es_client.search(index: _index, body: doc)
puts res["aggregations"]["word"]["buckets"]
