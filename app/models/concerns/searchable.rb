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
        indexes :id, type: :integer, index: true
        indexes :created_at, type: :date, index: true
        indexes :title, type: :text
        indexes :isbn_10, type: :keyword
        indexes :isbn_13, type: :keyword
        indexes :price, type: :float
        indexes :category, type: :object do
          indexes :id, type: :integer, index: true
          indexes :name, type: :text
          indexes :parent_id, type: :integer, index: true
          indexes :parent_name, type: :text
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
      puts query
      response = __elasticsearch__.search(query)
      response
    end

    def self.build_search_query params
      query = Jbuilder.encode do |json|
        json.query do
  
          json.bool do
            json.must do
              if !params[:query].blank?
                json.multi_match do
                  json.fields ['title^2', 'category_name', 'isbn_10^2', 'isbn_13^3']
                  json.query params[:query]
                end
              end# end endif 
            end # end must
            
            json.should do
              if !params[:query].blank?
                cat_query = {
                  'category.name' => params[:query]
                }
                pcat_query = {
                  'category.parent_name' => params[:query]
                }
                json.child! do
                  json.term cat_query
                end
                json.child! do
                  json.term pcat_query
                end
              end # end category
            end # end must

            json.filter do
              unless params[:category_id].blank?
                ft_cat =  { 
                  'category.id' => params[:category_id]
                }
                ft_pcat =  { 
                  'category.parent_id' => params[:category_id]
                }

                json.child! do
                  json.bool do
                    json.should do
                      json.child! do
                        json.term ft_cat
                      end
                      json.child! do
                        json.term ft_pcat
                      end
                    end
                  end
                end
              end # end category_id

              ft_price = { price: {}}
              unless params[:min_price].blank?
                ft_price[:price][:gte] = params[:min_price].to_f
              end
              unless params[:max_price].blank?
                ft_price[:price][:lte] = params[:max_price].to_f
              end

              unless ft_price[:price].blank?
                json.child! do
                  json.range ft_price
                end
              end
              
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
      query
    end
      
  end
end
