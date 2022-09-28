# frozen_string_literal: true

module Phlex
	class Compiler
		module Generators
			class StandardElement
				def initialize(formatter, method_name:, arguments: nil)
					@formatter = formatter
					@method_name = method_name
					@arguments = arguments
				end

				def call
					@formatter.append do |f|
						f.text "<"
						f.text tag
						f.text ">"
					end

					if content
						Content.new(@formatter, content: content).call
					end

					@formatter.append do |f|
						f.text "</"
						f.text tag
						f.text ">"
					end
				end

				def content
					positional_arguments = @arguments&.parts&.reject { _1.is_a? SyntaxTree::BareAssocHash }

					return unless positional_arguments

					case positional_arguments.length
					when 1
						positional_arguments.first
					when 0
						nil
					else
						positional_arguments
					end
				end

				def attributes
				end

				def tag
					HTML::STANDARD_ELEMENTS[@method_name]
				end
			end
		end
	end
end
