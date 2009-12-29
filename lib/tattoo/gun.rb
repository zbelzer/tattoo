module Tattoo
  class Gun
    def initialize(text, ink=[])
      @text = text
      @ink = ink.inject({}) {|coll, i| coll[i.name] = i; coll} 
    end

    def look
      @ink.values.inject({}) do |markings, ink|
        markings[ink.name] = ink.find_markings(@text)
        markings
      end
    end

    def tattoo
      text = @text.dup

      look.each do |name, markings|
        markings.each do |marking|
          text = @ink[name].mark(marking, text)
        end
      end

      text
    end
  end
end
