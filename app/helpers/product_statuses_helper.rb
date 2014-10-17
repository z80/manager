module ProductStatusesHelper
  def statuses
    all = ProductStatus.all
    res = []
    all.each do |ps|
      res.append( [ ps.status, ps.id ] )
    end
    return res
  end
end
