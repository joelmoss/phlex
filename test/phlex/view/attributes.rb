# frozen_string_literal: true

describe Phlex::HTML do
	extend ViewHelper

	describe "resolve_attributes hook" do
		describe "first" do
			view1 = Class.new(Phlex::HTML) do
				def resolve_attributes(**attributes)
					attributes[:class] = "1"
					attributes
				end

				def template
					div(identical: "attribute") { "one" }
				end
			end

			view2 = Class.new(Phlex::HTML) do
				def resolve_attributes(**attributes)
					attributes[:class] = "2"
					attributes
				end

				def template
					div(identical: "attribute") { "two" }
				end
			end

			it "renders" do
				expect(view1.new.call).to be == %(<div identical="attribute" class="1">one</div>)
				expect(view2.new.call).to be == %(<div identical="attribute" class="2">two</div>)
			end
		end
	end

	with "hash attributes" do
		view do
			def template
				div data: { name: { first_name: "Joel" } }
			end
		end

		it "flattens the attributes" do
			expect(output).to be == %(<div data-name-first-name="Joel"></div>)
		end
	end

	with "string keyed hash attributes" do
		view do
			def template
				div data: { "name_first_name" => "Joel" }
			end
		end

		it "flattens the attributes without dasherizing them" do
			expect(output).to be == %(<div data-name_first_name="Joel"></div>)
		end
	end

	if RUBY_ENGINE == "ruby"
		with "unique tag attributes" do
			view do
				def template
					div class: SecureRandom.hex
				end
			end

			let :report do
				view.new.call

				MemoryProfiler.report do
					2.times { view.new.call }
				end
			end

			it "doesn't leak memory" do
				expect(report.total_retained).to be == 0
			end
		end
	end
end
