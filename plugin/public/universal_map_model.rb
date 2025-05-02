module AresMUSH

  class UniversalMapGrid < Ohm::Model
    include ObjectModel
    include FindByName

    attribute :title
    index :title
    attribute :mode             # "abstract" or "grid"
    attribute :fog_enabled, :type => DataType::Boolean
    attribute :fog_data, :type => DataType::Hash, :default => {}
    attribute :revealed, :type => DataType::Array, :default => []
    attribute :created_at, :type => DataType::Time

    collection :tokens, "AresMUSH::UniversalMapToken"
    collection :objects, "AresMUSH::UniversalMapObject"

    def fogged?(location)
      return false unless self.fog_enabled
      key = if self.mode == "grid" && location.include?(",")
        x, y = location.split(',').map(&:to_i)
        "grid_#{x}_#{y}"
      else
        "zone_#{location.downcase}"
      end
      self.fog_data[key] == true
    end
  end

  class UniversalMapToken < Ohm::Model
    include ObjectModel

    attribute :name
    attribute :x, :type => DataType::Integer
    attribute :y, :type => DataType::Integer
    attribute :zone           # Used for abstract mode
    attribute :icon_url
    attribute :visibility, :default => "public"  # "public" or "gm"
    attribute :character_id   # Optional reference to a Character
    reference :map, "AresMUSH::UniversalMapGrid"

    index :map_id
  end

  class UniversalMapObject < Ohm::Model
    include ObjectModel

    attribute :object_type           # e.g., "crate", "asteroid", etc.
    attribute :x, :type => DataType::Integer
    attribute :y, :type => DataType::Integer
    attribute :zone
    attribute :visibility, :default => "public"
    reference :map, "AresMUSH::UniversalMapGrid"

    index :map_id
  end

end
