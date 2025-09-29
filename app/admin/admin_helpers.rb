module AdminHelpers
	# Updated to call the new format_attribute_value helper
	def responsive_attributes_panel(title, items)
		panel title, class: 'responsive-attributes-panel' do
			div class: 'responsive-attributes-container' do
				items.each do |label, value|
					div class: 'attribute' do
						span class: 'attribute-label' do
							label
						end
						span class: 'attribute-value' do
							format_attribute_value(label, value) # <-- Changed this line
						end
					end
				end
			end
		end
	end

	def responsive_image_item(record, attribute_name, image_path_method, title = nil)
		title ||= attribute_name.to_s.humanize.titleize
		div class: 'responsive-image-item' do
			h4 title
			if (image_path = record.send(image_path_method))
				div class: 'image-wrapper' do
					image_tag(image_path, alt: record.send(attribute_name).try(:humanize))
				end
			end
			div class: 'image-caption' do
				(record.send(attribute_name).blank? ? "N/A" : record.send(attribute_name).humanize)
			end
		end
	end

	private

	# This now handles booleans, colors, and default text values.
	def format_attribute_value(label, value)
		case value
		when true
			span 'Yes', class: 'status_tag yes'
		when false
			span 'No', class: 'status_tag no'
		else
			if label.to_s.include?('Color') && value.to_s.present?
				span do
					span class: 'color-swatch', style: "background-color: #{value};"
					span value.to_s
				end
			else
				value.to_s.presence || "N/A"
			end
		end
	end
end