class RelationLogo < ApplicationRecord

  def self.get_relation(id)
    return RelationLogo.find_by_item_id(id);
  end

end
