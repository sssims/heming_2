class AddBuyLinkToBooks < ActiveRecord::Migration
  def change
    add_column :books, :buy_link, :string
  end
end
