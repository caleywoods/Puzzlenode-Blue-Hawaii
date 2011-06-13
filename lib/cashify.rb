class Float
  def cashify
    return "$" + "%.2f" % self unless self.nil?
  end
end
