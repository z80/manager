module PartTypesHelper
  def part_types
    t = PartType.all
    res = []
    t.each do |pt|
      res.append( [pt.name, pt.id] )
    end
    return res
  end
end
