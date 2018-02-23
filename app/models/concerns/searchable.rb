require 'jbuilder'
module Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    settings :analysis => {
      :analyzer => {
        :default => {
          :tokenizer  => :standard,
          :filter  => [:standard, :asciifolding, :lowercase]
        }
      }
    } do
      mapping do
        indexes :id, type: :integer, index: :not_analyzed
        indexes :created_at, type: :date, index: :not_analyzed

        indexes :category_name, type: :string
        indexes :isbn_10, type: :string, index: :not_analyzed
        indexes :isbn_13, type: :string, index: :not_analyzed
        indexes :price, type: :float
        indexes :category, type: :object do
          indexes :id, type: :integer, index: :not_analyzed
          indexes :name, type: :string
          indexes :parent_id, type: :integer, index: :not_analyzed
          indexes :parent_name, type: :string, index: :not_analyzed
        end
      end

    end

    def as_indexed_json(options={})
      self.as_json({
        only: [
          :id,
          :title,
          :price,
          :isbn_10,
          :isbn_13,
          :category_name,
          :created_at
        ],
        methods: [:category_name],
        include: {
          category: {
            only: [:id, :name, :parent_id],
            methods: [:parent_name]
          }
        }
      })
    end

    def self.search(params)
      query = build_search_query(params)
      response = __elasticsearch__.search(query)
      response
    end

    def self.build_search_query params
      query = Jbuilder.encode do |json|
        json.query do
  
          json.filtered do
            if !params[:query].blank?
              json.query do
                json.multi_match do
                  json.fields ['title', 'isbn_10^2', 'isbn_10^3']
                  json.query params[:query]
                end
              end# end query
            end # endif
            json.filter do
              # json.bool do
                json.and do

                  if !params[:query].blank? && params[:query].length > 0
                    room_query = {'category.name' => params[:query]}
                    json.child! do
                      json.terms room_query
                    end
                  end # end category
  
                  if !params[:min_price].blank? && params[:max_price].length > 1
                    price_query = {
                      'price' => {
                        gte: params[:min_price].to_f,
                        lte: params[:max_price].to_f
                      }
                    }
                    json.child! do
                      json.range price_query
                    end
                  end
                  
                
                end # end and
  
  
              # end # end bool
  
            end # end filter
  
          end
        end
  
        if !params[:sort].blank?
          sort = {}
          case params[:sort]
          when 'price_low'
            sort['price'] = {
              'mode' => 'min',
              'order' => 'asc'
            }
          when 'price_high'
            sort['price'] = {
              'mode' => 'min',
              'order' => 'desc'
            }
          end
   
          json.sort [sort, '_score']
        end
      end
    end
      
  end
end
