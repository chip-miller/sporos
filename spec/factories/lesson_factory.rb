# == Schema Information
#
# Table name: lessons
#
#  id                      :integer          not null, primary key
#  study_id                :integer          not null
#  position                :integer          default("0")
#  title                   :string(255)      not null
#  description             :text(65535)
#  author                  :string(255)
#  backlink                :string(255)
#  poster_img_file_name    :string(255)
#  poster_img_content_type :string(255)
#  poster_img_file_size    :integer
#  poster_img_updated_at   :datetime
#  poster_img_original_url :string(255)
#  poster_img_fingerprint  :string(255)
#  video_file_name         :string(255)
#  video_content_type      :string(255)
#  video_file_size         :integer
#  video_updated_at        :datetime
#  video_original_url      :string(255)
#  video_fingerprint       :string(255)
#  audio_file_name         :string(255)
#  audio_content_type      :string(255)
#  audio_file_size         :integer
#  audio_updated_at        :datetime
#  audio_original_url      :string(255)
#  audio_fingerprint       :string(255)
#  machine_sorted          :boolean          default("0")
#  duration                :integer
#  published_at            :datetime
#  created_at              :datetime
#  updated_at              :datetime
#
# Indexes
#
#  index_lessons_on_backlink               (backlink)
#  index_lessons_on_study_id_and_position  (study_id,position)
#
include ActionDispatch::TestProcess

FactoryGirl.define do
  factory :lesson do
    before(:create, :stub) { AWS.stub! if Rails.env.test? }
    
    study
    # position 1
    title       { Faker::Lorem.sentence(rand(3..6))  }
    description { Faker::Lorem.paragraph(rand(2..5)) }
    author      { Faker::Name.name }
    backlink    "http://link.com/salt-and-light"
    poster_img  { fixture_file_upload(Rails.root.join('spec/files/', 'poster_image.jpg'), 'image/jpg', true) }
    video       { fixture_file_upload(Rails.root.join('spec/files/', 'video.m4v'       ), 'video/mp4', true) }
    audio       { fixture_file_upload(Rails.root.join('spec/files/', 'audio.m4a'       ), 'audio/mp4', true) }
    video_original_url 'http://example.com/video.m4v'
    audio_original_url 'http://example.com/audio.m4a'
    published_at Time.now
  end
end
