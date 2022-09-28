# frozen_string_literal: true

module Phlex
	class Compiler
		module Generators
			class Content
				def initialize(formatter, content:)
					@formatter = formatter
					@content = content
				end

				def call
					case @content
					in SyntaxTree::StringLiteral[parts: [SyntaxTree::TStringContent]]
						@formatter.append do |f|
							f.text CGI.escape_html(
								@content.parts.first.value
							)
						end
					in SyntaxTree::SymbolLiteral
						@formatter.append do |f|
							f.text CGI.escape_html(
								@content.value.value
							)
						end
					in SyntaxTree::Int | SyntaxTree::FloatLiteral
						@formatter.append { _1.text @content.value }
					in SyntaxTree::StringLiteral # with interpolation
						@formatter.chain_append do |f|
							f.text "CGI.escape_html("
							@content.format(f)
							f.text ")"
						end
					in SyntaxTree::VarRef[value: SyntaxTree::Kw[value: "nil"]]
						nil
					in Array
						@formatter.chain_append do |f|
							f.text "_output("
							f.seplist(@content, -> { f.text ", " }) { |part| f.format(part) }
							f.text ")"
						end
					else
						@formatter.chain_append do |f|
							f.text "_output("
							@content.format(f)
							f.text ")"
						end
					end
				end
			end
		end
	end
end
