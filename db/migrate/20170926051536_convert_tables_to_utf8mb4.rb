class ConvertTablesToUtf8mb4 < ActiveRecord::Migration[5.1]
  def up
    execute "ALTER TABLE users CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_bin"
    execute "ALTER TABLE users MODIFY name VARCHAR(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin"
    execute "ALTER TABLE users MODIFY email VARCHAR(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin"
    execute "ALTER TABLE users MODIFY encrypted_password VARCHAR(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin"
    execute "ALTER TABLE users MODIFY reset_password_token VARCHAR(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin"
    execute "ALTER TABLE users MODIFY current_sign_in_ip VARCHAR(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin"
    execute "ALTER TABLE users MODIFY last_sign_in_ip VARCHAR(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin"
    execute "ALTER TABLE users MODIFY avatar_file_name VARCHAR(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin"
    execute "ALTER TABLE users MODIFY avatar_content_type VARCHAR(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin"
    execute "ALTER TABLE users MODIFY image VARCHAR(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin"

    execute "ALTER TABLE stories CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_bin"
    execute "ALTER TABLE stories MODIFY link VARCHAR(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin"
    execute "ALTER TABLE stories MODIFY `desc` VARCHAR(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin"
    execute "ALTER TABLE stories MODIFY point VARCHAR(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin"

    execute "ALTER TABLE rooms CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_bin"
    execute "ALTER TABLE rooms MODIFY name VARCHAR(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin"
    execute "ALTER TABLE rooms MODIFY slug VARCHAR(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin"
    execute "ALTER TABLE rooms MODIFY pv VARCHAR(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin"
    execute "ALTER TABLE rooms MODIFY scheme VARCHAR(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin"
  end

  def down
    execute "ALTER TABLE users CONVERT TO CHARACTER SET utf8 COLLATE utf8_bin"
    execute "ALTER TABLE users MODIFY name VARCHAR(255) CHARACTER SET utf8 COLLATE utf8_bin"
    execute "ALTER TABLE users MODIFY email VARCHAR(255) CHARACTER SET utf8 COLLATE utf8_bin"
    execute "ALTER TABLE users MODIFY encrypted_password VARCHAR(255) CHARACTER SET utf8 COLLATE utf8_bin"
    execute "ALTER TABLE users MODIFY reset_password_token VARCHAR(255) CHARACTER SET utf8 COLLATE utf8_bin"
    execute "ALTER TABLE users MODIFY current_sign_in_ip VARCHAR(255) CHARACTER SET utf8 COLLATE utf8_bin"
    execute "ALTER TABLE users MODIFY last_sign_in_ip VARCHAR(255) CHARACTER SET utf8 COLLATE utf8_bin"
    execute "ALTER TABLE users MODIFY avatar_file_name VARCHAR(255) CHARACTER SET utf8 COLLATE utf8_bin"
    execute "ALTER TABLE users MODIFY avatar_content_type VARCHAR(255) CHARACTER SET utf8 COLLATE utf8_bin"
    execute "ALTER TABLE users MODIFY image VARCHAR(255) CHARACTER SET utf8 COLLATE utf8_bin"

    execute "ALTER TABLE stories CONVERT TO CHARACTER SET utf8 COLLATE utf8_bin"
    execute "ALTER TABLE stories MODIFY link VARCHAR(255) CHARACTER SET utf8 COLLATE utf8_bin"
    execute "ALTER TABLE stories MODIFY `desc` VARCHAR(255) CHARACTER SET utf8 COLLATE utf8_bin"
    execute "ALTER TABLE stories MODIFY point VARCHAR(255) CHARACTER SET utf8 COLLATE utf8_bin"

    execute "ALTER TABLE rooms CONVERT TO CHARACTER SET utf8 COLLATE utf8_bin"
    execute "ALTER TABLE rooms MODIFY name VARCHAR(255) CHARACTER SET utf8 COLLATE utf8_bin"
    execute "ALTER TABLE rooms MODIFY slug VARCHAR(255) CHARACTER SET utf8 COLLATE utf8_bin"
    execute "ALTER TABLE rooms MODIFY pv VARCHAR(255) CHARACTER SET utf8 COLLATE utf8_bin"
    execute "ALTER TABLE rooms MODIFY scheme VARCHAR(255) CHARACTER SET utf8 COLLATE utf8_bin"
  end
end
