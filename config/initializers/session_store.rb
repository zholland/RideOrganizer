# Be sure to restart your server when you modify this file.

#Rails.application.config.session_store :cookie_store, key: '_ride_organizer_session'

Rails.application.config.session_store :active_record_store, {expire_after: 48.hours}