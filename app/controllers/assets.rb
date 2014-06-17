TestApp::App.controllers :assets, provides: :json do
	get :read, map: '/v2/catalogs/:catalog_id/assets/:asset_id' do
		find_args = params.slice(:catalog_id, :asset_id)
		@asset = Asset.find(params.slice(:catalog_id, :asset_id)) rescue nil
		halt 404 if @asset.nil?
		@view_obj = {
			_id: @asset.id,
			catalog_id: @asset.catalog.id,
			payload: @asset.payload,
		}
		
		render 'shared/index'
	end
	
	put :create, map: '/v2/catalogs/:catalog_id/assets/:asset_id' do
		@asset = Asset.new(Catalog.new(params[:catalog_id]), params[:asset_id])
		
		@json_body = JSON.parse(request.body.read)
		@asset.payload = @json_body['payload']
		@asset.save
		
		redirect url_for(:assets_read, params.slice(:catalog_id, :asset_id)), 201
	end
end
