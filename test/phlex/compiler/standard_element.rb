# frozen_string_literal: true

require "test_helper"

describe Phlex::Compiler::Generators::StandardElement do
	let(:formatter) { Phlex::Compiler::Formatter.new("") }
	let(:tree) { SyntaxTree.parse @source || source }
	let(:command) { tree.statements.body.first }
	let(:method_name) { command.message.value.to_sym }
	let(:arguments) { command.arguments }

	let(:generator) do
		Phlex::Compiler::Generators::StandardElement.new(formatter,
			method_name: method_name,
			arguments: arguments)
	end

	let(:output) do
		generator.call
		formatter.tap(&:flush).output
	end

	it "supports string literals" do
		@source = %{div "Hello World!"}
		expect(output).to be == %{@_target << "<div>Hello World!</div>"}
	end

	it "supports string literals with interpolation" do
		@source = %{div "Hello #\{name\}!"}
		expect(output).to be ==
			%{@_target << "<div>" << CGI.escape_html("Hello #\{name\}!") << "</div>"}
	end

	it "supports symbol content" do
		@source = %{div :hello}
		expect(output).to be == %{@_target << "<div>hello</div>"}
	end

	it "supports integer content" do
		@source = %{div 1}
		expect(output).to be == %{@_target << "<div>1</div>"}
	end

	it "supports float content" do
		@source = %{div 1.618033988749}
		expect(output).to be == %{@_target << "<div>1.618033988749</div>"}
	end

	it "supports nil content" do
		@source = %{div nil}
		expect(output).to be == %{@_target << "<div></div>"}
	end

	it "supports non-string-like objects" do
		@source = %{div ["Hello"]}
		expect(output).to be == %{@_target << "<div>" << _output(["Hello"]) << "</div>"}
	end

	it "supports attributes" do
		@source = %{div class: "hello"}
		expect(output).to be == %{@_target << "<div></div>"}
	end

	it "supports positional splats" do
		@source = %{div *args}
		expect(output).to be == %{@_target << "<div>" << _output(*args) << "</div>"}
	end

	it "supports multiple positional splats" do
		@source = %{div *a, *b}
		expect(output).to be == %{@_target << "<div>" << _output(*a, *b) << "</div>"}
	end

	it "supports variable content" do
		@source = %{div name}
		expect(output).to be == %{@_target << "<div>" << _output(name) << "</div>"}
	end

	it "supports instance variable content" do
		@source = %{div @name}
		expect(output).to be == %{@_target << "<div>" << _output(@name) << "</div>"}
	end
end
