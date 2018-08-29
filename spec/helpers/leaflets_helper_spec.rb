require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the LeafletsHelper. For example:
#
# describe LeafletsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe LeafletsHelper, type: :helper do
  describe "#render_leaflet_option" do
    it "renders options according to current user vote" do
      html = render_leaflet_option("13", ["1", "3", "5", "13"])
      expect(html).to eq('<li><input class="btn btn-default" type="button" value="1" /></li><li><input class="btn btn-default" type="button" value="3" /></li><li><input class="btn btn-default" type="button" value="5" /></li><li><input class="btn btn-default btn-info" type="button" value="13" /></li>')
    end
  end
end
