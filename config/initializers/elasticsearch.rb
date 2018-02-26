Elasticsearch::Model.client = Elasticsearch::Client.new(host: ENV.fetch('ELASTICSEARCH_HOST', 'localhost'))
Kaminari::Hooks.init if defined?(Kaminari::Hooks)
Elasticsearch::Model::Response::Response.__send__ :include, Elasticsearch::Model::Response::Pagination::Kaminari
