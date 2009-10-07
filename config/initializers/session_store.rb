# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_JTier1-2API_session',
  :secret      => '0b42ede1b807c6579a5379dfbf9e45024bbc7cd2df97facc686e3337f8964aa1af3b46ac5388944ac06dab54176b8c6ff870880b7a792c60a2d5141d3117b1cb'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
