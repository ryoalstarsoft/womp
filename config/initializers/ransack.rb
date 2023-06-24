Ransack.configure do |config|
	config.add_predicate 'contains_any',
		arel_predicate: 'contains_any',
		formatter: proc { |v| "#{v.to_s.gsub("[", "{").gsub("]", "}")}" }
end
