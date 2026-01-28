module Jekyll
    module MergeFilters
        def merge(input, hash)
            unless input.respond_to?(:to_hash)
                # value = input == EMPTY ? 'empty' : input
                is_caller = caller[0][/`([^']*)'/, 1]
                raise ArgumentError.new('merge filter requires at least a hash for 1st arg, found caller|args: ' + "#{is_caller}|#{input}:#{hash}")
            end
            # if hash to merge is NOT a hash or empty return first hash (input)
            unless hash.respond_to?(:to_hash)
                input
            end
            if hash.nil? || hash.empty?
                input
            else
                merged = input.dup
                hash.each do |k, v|
                merged[k] = v
                end
                merged
            end
        end
    end
end

Liquid::Template.register_filter(Jekyll::MergeFilters)
