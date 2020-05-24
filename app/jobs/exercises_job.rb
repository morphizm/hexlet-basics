# frozen_string_literal: true

class ExercisesJob < ApplicationJob
  queue_as :default

  def perform(lang_name)
    exercises_path = Rails.root.join('tmp/hexletbasics')
    language_exercises_path = File.join(exercises_path, "exercises-#{lang_name}")
    language = upsert_language(language_exercises_path, lang_name)

    modules_names = get_modules(language_exercises_path)

    modules_names.each do |module_name|
      modul = upsert_module(module_name, language)
      module_lessons_names = get_lessons(language_exercises_path, module_name)
      module_lessons_names.each do |module_lesson_name|
        upsert_lesson(module_lesson_name, modul, language)
      end
    end
  end

  def get_modules(dest)
    modules_path = File.join(dest, 'modules')
    Dir.open(modules_path) do |dir|
      children = dir.children
      children.select { |child| File.directory?(File.join(modules_path, child)) }
    end
  end

  def get_lessons(dest, module_name)
    lessons_path = File.join(dest, 'modules', module_name)
    Dir.open(lessons_path) do |dir|
      children = dir.children
      children.select { |child| File.directory?(File.join(lessons_path, child)) }
    end
  end

  def upsert_lesson(lesson_name, language_module, language)
    order, slug = lesson_name.split('-', 2)
    module_directory_path = Language::Module.get_directory(language_module)
    path_to_code = File.join(module_directory_path, lesson_name)
    Language::Module::Lesson.find_or_create_by(slug: slug, language_module_id: language_module.id, language_id: language.id, order: order, path_to_code: path_to_code)
  end

  def upsert_module(module_name, language)
    order, slug = module_name.split('-', 2)
    Language::Module.find_or_create_by(slug: slug, language_id: language.id, order: order)
  end

  def upsert_language(dest, lang_name)
    data_path = File.join(dest, 'spec.yml')
    data = File.new(data_path, 'r').read
    language_data = YAML.safe_load(data)['language']

    Language.find_or_create_by(
      name: lang_name,
      slug: lang_name,
      extension: language_data['extension'],
      docker_image: language_data['docker_image'],
      exercise_filename: language_data['exercise_filename'],
      exercise_test_filename: language_data['exercise_test_filename']
    )
  end
end
