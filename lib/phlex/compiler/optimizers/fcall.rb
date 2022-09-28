# frozen_string_literal: true

module Phlex
	class Compiler
		module Optimizers
			class FCall < BaseOptimizer
				module StandardElement
					def format(formatter)
						Generators::StandardElement.new(formatter,
							method_name: value.value.to_sym,
							arguments: arguments.arguments).call
					end
				end

				module VoidElement
					def format(formatter)
						Generators::VoidElement.new(formatter,
							method_name: value.value.to_sym).call
					end
				end

				private

				def name
					@node.value.value.to_sym
				end
			end
		end
	end
end
