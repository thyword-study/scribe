FactoryBot.define do
  factory :exposition_batch_request, class: 'Exposition::BatchRequest' do
    input_file_id { "file-#{Faker::Number.number}" }
    input_file_uploaded_at { Time.current }
    name { Faker::Lorem.words.join(" ").titlecase }
    status { "requested" }
  end
end
