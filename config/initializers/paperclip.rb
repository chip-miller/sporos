# https://github.com/thoughtbot/paperclip/blob/master/lib/paperclip/interpolations.rb
# Paperclip.interpolates(:timestamp_now) { |attachment, style| Time.now.to_i }

Paperclip::Attachment.default_options[:use_timestamp] = false