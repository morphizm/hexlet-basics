class RenameLessonMemberColumns < ActiveRecord::Migration[6.0]
  def change
    rename_column :language_lesson_members, :language_lesson_id, :lesson_id
  end
end
