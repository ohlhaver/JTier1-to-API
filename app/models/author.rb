class Author < ActiveRecord::Base

  def self.create_or_find(author_names)
    authors = []
    author_names.each do |a_n|
      a = self.find_or_initialize_by_name(a_n)
      if a.new_record?
        a.is_agency = false
        a.save!
      end
      authors << a
    end
    return authors
  end
end
