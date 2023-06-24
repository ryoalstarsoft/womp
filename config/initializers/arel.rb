require 'arel/nodes/binary'
require 'arel/predications'
require 'arel/visitors/postgresql'

module Arel
	class Nodes::ContainsAnyArray < Arel::Nodes::Binary
		def operator
			:"&&"
		end
	end

	class Visitors::PostgreSQL
		private

		def visit_Arel_Nodes_ContainsAnyArray(o, collector)
			infix_value o, collector, ' && '
		end
	end

	module Predications
		def contains_any(other)
			Nodes::ContainsAnyArray.new self, Nodes.build_quoted(other, self)
		end
	end
end
