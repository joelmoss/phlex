# frozen_string_literal: true

require "test_helper"
require "compilation/fcall"

describe Phlex::Compiler do
	with "a standard element" do
		let(:compiler) { Phlex::Compiler.new(Fixtures::Compilation::FCall::StandardElement) }

		it "compiles the method" do
			expect(compiler).to receive(:redefine).with_arguments <<~RUBY.chomp
				def template
					@_target << "<h1>Hello World!</h1>"
				end
			RUBY

			compiler.call
		end
	end

	with "a standard element with interpolation" do
		let(:compiler) {
			Phlex::Compiler.new(
				Fixtures::Compilation::FCall::StandardElementWithStringInterpolation
			)
		}

		it "compiles the method" do
			expect(compiler).to receive(:redefine).with_arguments <<~RUBY.chomp
				def template
					@_target << "<h1>" << CGI.escape_html("Hello \#{name}! \#{question}?") << "</h1>"
				end
			RUBY

			compiler.call
		end
	end

	with "a standard element with symbol" do
		let(:compiler) {
			Phlex::Compiler.new(
				Fixtures::Compilation::FCall::StandardElementWithSymbol
			)
		}

		it "compiles the method" do
			expect(compiler).to receive(:redefine).with_arguments <<~RUBY.chomp
				def template
					@_target << "<h1>hello</h1>"
				end
			RUBY

			compiler.call
		end
	end

	with "a standard element with integer" do
		let(:compiler) {
			Phlex::Compiler.new(
				Fixtures::Compilation::FCall::StandardElementWithInteger
			)
		}

		it "compiles the method" do
			expect(compiler).to receive(:redefine).with_arguments <<~RUBY.chomp
				def template
					@_target << "<h1>1</h1>"
				end
			RUBY

			compiler.call
		end
	end

	with "a standard element with float" do
		let(:compiler) {
			Phlex::Compiler.new(
				Fixtures::Compilation::FCall::StandardElementWithFloat
			)
		}

		it "compiles the method" do
			expect(compiler).to receive(:redefine).with_arguments <<~RUBY.chomp
				def template
					@_target << "<h1>1.618033988749</h1>"
				end
			RUBY

			compiler.call
		end
	end
end
