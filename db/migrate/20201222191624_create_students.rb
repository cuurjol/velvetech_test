class CreateStudents < ActiveRecord::Migration[5.2]
  def change
    create_table :students do |t|
      t.string :last_name, null: false, limit: 40
      t.string :first_name, null: false, limit: 40
      t.string :middle_name, null: true, limit: 60
      t.integer :gender, null: false
      t.string :suid, null: true, limit: 16
      t.references :user, foreign_key: true

      t.timestamps
    end

    add_index :students, :suid, unique: true
  end
end
