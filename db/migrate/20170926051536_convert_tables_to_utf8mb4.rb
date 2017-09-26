class ConvertTablesToUtf8mb4 < ActiveRecord::Migration[5.1]
  def change
    execute "ALTER TABLE users CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_bin"
    execute "ALTER TABLE users MODIFY name VARCHAR(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin"

    execute "ALTER TABLE stories CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_bin"
    execute "ALTER TABLE stories MODIFY link VARCHAR(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin"
    execute "ALTER TABLE stories MODIFY `desc` VARCHAR(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin"

    execute "ALTER TABLE rooms CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_bin"
    execute "ALTER TABLE rooms MODIFY name VARCHAR(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin"
  end
end
