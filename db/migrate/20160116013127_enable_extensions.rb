class EnableExtensions < ActiveRecord::Migration[6.1]
  def change
    enable_extension 'uuid-ossp'
    enable_extension 'plpgsql'
    enable_extension 'pg_trgm'
    enable_extension 'pgcrypto'
  end
end
