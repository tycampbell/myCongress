# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_myCongress_session',
  :secret      => '2dfefefaea87b5f543f89130b484ecee6793f7d6ae618d628e2a59c4aeab3a38f0de5ebe66d4cf8156a91c2b66b5f469091516db7428a2c7df9d6cc7d3297c78'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
#ActionController::Base.session_store = :mem_cache_store
