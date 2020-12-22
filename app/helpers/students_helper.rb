module StudentsHelper
  def form_title(record)
    t(record.new_record? ? 'students.new.title' : 'students.edit.title')
  end
end
