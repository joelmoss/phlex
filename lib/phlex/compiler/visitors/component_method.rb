# frozen_string_literal: true

module Phlex
	class Compiler
		module Visitors
			class ComponentMethod < BaseVisitor
				def optimized_something?
					!!@optimized_something
				end

				visit_method def visit_vcall(node)
					if Optimizers::VCall.new(node, compiler: @compiler).call
						@optimized_something = true
					end

					super
				end

				visit_method def visit_fcall(node)
					if Optimizers::FCall.new(node, compiler: @compiler).call
						@optimized_something = true
					end

					super
				end

				visit_method def visit_class(node)
					nil
				end

				visit_method def visit_module(node)
					nil
				end
			end
		end
	end
end
