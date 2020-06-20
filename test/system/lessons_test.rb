# frozen_string_literal: true

require 'application_system_test_case'

class LessonsTest < ApplicationSystemTestCase
  include AuthManagment

  test 'visiting the lesson show' do
    sign_in_as(:one)

    language_module_lesson = language_module_lessons(:one)
    language = language_module_lesson.language
    language_module = language_module_lesson.module

    visit language_module_lesson_url(language.slug, language_module.slug, language_module_lesson.slug)

    assert { page.has_selector?('#basics-lesson-container') }
    assert { page.driver.browser.manage.logs.get(:browser).empty? }
  end
end