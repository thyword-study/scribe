require 'rails_helper'

RSpec.describe BooksController, type: :request do
  describe 'GET #index' do
    it 'returns the correct response' do
      get bible_books_path bible_code: 'bsb'

      aggregate_failures do
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq 'text/html; charset=utf-8'
      end
    end
  end

  describe 'GET #show' do
    it 'returns the correct response' do
      get bible_book_path bible_code: 'bsb', slug: 'genesis'

      aggregate_failures do
        expect(response).to have_http_status(:temporary_redirect)
        expect(response.content_type).to eq 'text/html; charset=utf-8'
      end
    end
  end
end
