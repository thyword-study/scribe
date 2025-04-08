require 'rails_helper'

RSpec.describe ChaptersController, type: :request do
  describe 'GET #index' do
    it 'returns the correct response' do
      translation = FactoryBot.create(:translation)
      book = FactoryBot.create(:translation_book, translation: translation)

      get translation_book_chapters_path translation_code: translation.code.downcase, book_slug: book.slug

      aggregate_failures do
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq 'text/html; charset=utf-8'
      end
    end
  end

  describe 'GET #show' do
    it 'returns the correct response' do
      translation = FactoryBot.create(:translation)
      book = FactoryBot.create(:translation_book, translation: translation)
      chapter = FactoryBot.create(:translation_chapter, translation: translation, book: book, number: 1)

      get translation_book_chapter_path translation_code: translation.code.downcase, book_slug: book.slug, number: chapter.number

      aggregate_failures do
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq 'text/html; charset=utf-8'
      end
    end
  end
end
