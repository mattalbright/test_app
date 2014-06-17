require 'spec_helper'

describe "Assets" do
	before (:each) do
		@catalog_id, @asset_id = "5a74cea3e2ee441687ef92c0fcf37679", "2afe0f5d8f794278a91171c3a16bbbd0"
		@payload = {'foo' => 'bar', 'num' => 42}
		@catalog = double(Catalog, id: @catalog_id)
		@asset = double(Asset, catalog: @catalog, id: @asset_id, payload: @payload)
		@asset_params = {catalog_id: @catalog_id, asset_id: @asset_id}
		@url = "/v2/catalogs/#{@catalog_id}/assets/#{@asset_id}"
	end
	
	describe "Get" do
		it "returns 404 for missing DB object" do
			Asset.should_receive(:find).with(@asset_params).and_return(nil)
			
			get @url
			
			last_response.status.should == 404
			last_response.content_length.should == 0
		end
		
		it "returns 200 and correct JSON" do
			Asset.should_receive(:find).with(@asset_params).and_return(@asset)
			
			get @url
			
			last_response.status.should == 200
			last_response.should be_json
			json_body = last_response.json_body
			json_body.at_json_path('_id').should == @asset_id
			json_body.at_json_path('catalog_id').should == @catalog_id
			json_body.at_json_path('payload').should == @payload
		end
	end
	
	describe "Create" do
		it "returns 201 with Location header" do
			Catalog.should_receive(:new).with(@catalog_id).and_return(@catalog)
			Asset.should_receive(:new).with(@catalog, @asset_id).and_return(@asset)
			@asset.should_receive(:payload=).with(@payload)
			@asset.should_receive(:save).and_return(true)
			
			put @url, {'payload' => @payload}.to_json, {'Content-Type' => 'application/json;charset=utf-8'}
			
			last_response.status.should == 201
			last_response.location.should == "http://example.org#@url"
			last_response.content_length.should == 0
		end
	end
end