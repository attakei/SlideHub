class InitialDb < ActiveRecord::Migration
  def self.up
    create_table 'categories' do |t|
      t.string 'name', limit: 255, null: false
    end unless ActiveRecord::Base.connection.table_exists?('categories')

    unless ActiveRecord::Base.connection.table_exists?('comments')
      create_table 'comments' do |t|
        t.integer  'user_id',  limit: 4,     null: false
        t.integer  'slide_id', limit: 4,     null: false
        t.text     'content',  limit: 65535, null: false
        t.datetime 'created',                null: false
        t.datetime 'modified'
      end
      add_index 'comments', ['slide_id'], name: 'idx_comments_slide_id_key', using: :btree
      add_index 'comments', ['user_id'], name: 'idx_comments_user_id_key', using: :btree
    end

    unless ActiveRecord::Base.connection.table_exists?('slides')
      create_table 'slides' do |t|
        t.integer  'user_id',        limit: 4,                     null: false
        t.string   'name',           limit: 255,                   null: false
        t.text     'description',    limit: 65535,                 null: false
        t.boolean  'downloadable',                 default: false, null: false
        t.integer  'category_id',    limit: 4,                     null: false
        t.datetime 'created',                                      null: false
        t.datetime 'modified'
        t.string   'key',            limit: 255,   default: ''
        t.string   'extension',      limit: 10,    default: '',    null: false
        t.integer  'convert_status', limit: 4,     default: 0
        t.integer  'total_view',     limit: 4,     default: 0,     null: false
        t.integer  'page_view',      limit: 4,     default: 0
        t.integer  'download_count', limit: 4,     default: 0,     null: false
        t.integer  'embedded_view',  limit: 4,     default: 0,     null: false
      end
      add_index 'slides', ['category_id'], name: 'idx_slides_category_id_key', using: :btree
      add_index 'slides', ['page_view'], name: 'idx_slides_page_view_key', using: :btree
      add_index 'slides', ['user_id'], name: 'idx_slides_user_id_key', using: :btree
    end

    unless ActiveRecord::Base.connection.table_exists?('tags')
      create_table 'tags' do |t|
        t.string   'identifier', limit: 30
        t.string   'name',       limit: 30,             null: false
        t.string   'keyname',    limit: 30,             null: false
        t.datetime 'created'
        t.datetime 'modified'
        t.integer  'occurrence', limit: 4,  default: 0, null: false
      end
      add_index 'tags', %w(identifier keyname), name: 'UNIQUE_TAG', unique: true, using: :btree
    end

    unless ActiveRecord::Base.connection.table_exists?('users')
      create_table 'users' do |t|
        t.string   'username',     limit: 32,                    null: false
        t.string   'display_name', limit: 128,                   null: false
        t.string   'password',     limit: 255,                   null: false
        t.boolean  'admin',                      default: false, null: false
        t.boolean  'disabled',                   default: false
        t.datetime 'created',                                    null: false
        t.datetime 'modified'
        t.text     'biography',    limit: 65535
        t.integer  'slides_count', limit: 4,     default: 0
      end
      add_index 'users', ['username'], name: 'idx_username_ukey', unique: true, using: :btree
    end
  end
end
