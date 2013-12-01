class String
  def present?
    !blank?
  end

  # A string is blank if it's empty or contains whitespaces only:
  #
  #   ''.blank?                 # => true
  #   '   '.blank?              # => true
  #   '　'.blank?               # => true
  #   ' something here '.blank? # => false
  def blank?
    self =~ /\A[[:space:]]*\z/
  end
end