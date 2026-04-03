require 'deb_version'

module Jekyll
    module SortDebverFilters
        def nil_safe_debver_comp(a, b)
            if !a.nil? && !b.nil?
                version_a = DebVersion.new(a.to_s)
                version_b = DebVersion.new(b.to_s)
                version_a <=> version_b
            elsif a.nil? && b.nil?
                0
            else
                a.nil? ? 1 : -1
            end
        end

        def sort_debver(input, property = nil)
            ary = Liquid::StandardFilters::InputIterator.new(input)

            return [] if ary.empty?

            if property.nil?
                ary.sort do |a, b|
                nil_safe_debver_comp(a, b)
                end
            elsif ary.all? { |el| el.respond_to?(:[]) }
                begin
                ary.sort { |a, b| nil_safe_debver_comp(a[property], b[property]) }
                rescue TypeError
                raise_property_error(property)
                end
            end
        end
    end
end

Liquid::Template.register_filter(Jekyll::SortDebverFilters)
