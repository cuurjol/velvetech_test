class Student < ApplicationRecord
  belongs_to :user

  enum gender: %i[male female]

  validates :last_name, presence: true, length: { maximum: 40 }
  validates :first_name, presence: true, length: { maximum: 40 }
  validates :middle_name, length: { maximum: 60 }
  validates :gender, presence: true
  validates :suid, length: { minimum: 6, maximum: 16 }, uniqueness: true

  ransacker :full_name do |parent|
    expr = [Arel::Nodes::SqlLiteral.new("' '"), parent.table[:last_name],
            parent.table[:first_name], parent.table[:middle_name]]
    Arel::Nodes::NamedFunction.new('concat_ws', expr)
  end

  def full_name
    "#{last_name.capitalize} #{first_name.capitalize} #{middle_name.capitalize}"
  end

  def translate_gender
    Student.human_enum_name(:gender, self[:gender])
  end
end
