# frozen_string_literal: true

module Fixtures
	module Compilation
		module FCall
			class StandardElement < Phlex::View
				def template
					h1("Hello World!")
				end
			end

			class StandardElementWithStringInterpolation < Phlex::View
				def template
					h1("Hello #{name}! #{question}?")
				end
			end

			class StandardElementWithSymbol < Phlex::View
				def template
					h1(:hello)
				end
			end

			class StandardElementWithInteger < Phlex::View
				def template
					h1(1)
				end
			end

			class StandardElementWithFloat < Phlex::View
				def template
					h1(1.618033988749)
				end
			end
		end
	end
end
