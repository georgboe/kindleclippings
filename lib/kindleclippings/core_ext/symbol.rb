class Symbol
  unless :symbol.respond_to?(:downcase)
    def downcase
      self.to_s.downcase.intern
    end
  end
end