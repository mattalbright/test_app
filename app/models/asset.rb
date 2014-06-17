class Asset
	attr_reader :id, :catalog
	attr_accessor :payload
	
	def initialize(catalog, id)
		@catalog = catalog
		@id = id
	end
	
	# STUB
	def self.find(find_args)
		asset = Asset.new(Catalog.new(find_args[:catalog_id]), find_args[:asset_id])
		asset.payload = {'foo' => 'bar', 'baz' => 55}
		asset
	end
end