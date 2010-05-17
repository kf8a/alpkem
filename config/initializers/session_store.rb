# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_alpkem2_session',
  :secret      => 'cf174fa0abdfb8f2924fe7a4b3224ce90c18443c0e26a8d5bfcd403ca4ac783051ebaa512f431a9bac5c79c983cd9aa36c1c996ad458e9622ed5c1e93a54e479'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
ActionController::Base.session_store = :active_record_store
