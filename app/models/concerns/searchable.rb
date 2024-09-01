module Searchable
  extend ActiveSupport::Concern

  included do
    scope :search, ->(search_params) {
      relation = all
      relation = relation.keyword_search(search_params[:q]) if search_params[:q].present?
      relation = relation.ordered(search_params[:sort], search_params[:sort_direction]) if search_params[:sort].present?
      relation
    }

    scope :ordered, ->(property, direction = :asc) {
      public_send("order_by_#{property}", direction)
    }
  end

  class_methods do
    def orderable_by(*args)
      args.each do |arg|
        if arg.is_a?(Symbol) || arg.is_a?(String)
          define_order_by_scope_for_property(arg)
        elsif arg.is_a?(Hash)
          arg.each do |association, association_properties|
            define_order_by_scopes_for_association_properties(association, association_properties)
          end
        end
      end
    end

    private

    def define_order_by_scope_for_property(property)
      scope :"order_by_#{property}", ->(direction = :asc) {
        if columns_hash[property.to_s].type.presence_in([:string, :text])
          order(Arel.sql("#{table_name}.#{property} COLLATE NOCASE #{direction}"))
        else
          order(property => direction)
        end
      }
    end

    def define_order_by_scopes_for_association_properties(association, properties)
      properties.each do |property|
        define_order_by_scope_for_association_property(association, property)
      end
    end

    def define_order_by_scope_for_association_property(association, property)
      scope :"order_by_#{association}_#{property}", ->(direction = :asc) {
        association_reflection = reflect_on_association(association)

        if association_reflection.klass.columns_hash[property.to_s].type.presence_in([:string, :text])
          joins(association_reflection.name).order(Arel.sql("#{association_reflection.plural_name}.#{property} COLLATE NOCASE #{direction}"))
        else
          joins(association_reflection.name).order("#{association_reflection.plural_name}.#{property}" => direction)
        end
      }
    end
  end
end
