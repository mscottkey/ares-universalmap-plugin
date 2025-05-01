module AresMUSH

  class UniversalMapGrid < Ohm::Model
    include ObjectModel
    include FindByName

    attribute :title
    attribute :mode             # "abstract" or "grid"
    attribute :fog_enabled, :type => DataType::Boolean
    attribute :fog_data, :type => DataType::Hash, :default => {}
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
    attribute :x
    attribute :y
    attribute :zone           # Used for abstract mode
    attribute :icon_url
    attribute :visibility, :default => "public"  # "public" or "gm"
    attribute :character_id   # Optional reference to a Character
    reference :map, "AresMUSH::UniversalMapGrid"
  end

  class UniversalMapObject < Ohm::Model
    include ObjectModel

    attribute :type           # e.g., "crate", "asteroid", etc.
    attribute :x
    attribute :y
    attribute :zone
    attribute :visibility, :default => "public"
    reference :map, "AresMUSH::UniversalMapGrid"
  end

end
