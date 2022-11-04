class Dog
    attr_accessor :name, :breed, :id
    def intialize(name:, breed: id: nil)
        @id = id
        @name = name
        @breed = breed
    end

    def self.drop_table
        sql = <<-SQL
          DROP TABLE IF EXISTS songs
        SQL
    
        DB[:conn].execute(sql)
    end

    def self.create_table
        sql <<-SQL
        CREATE TABLE IF NOT EXISTS dogs (
            id INTEGER PRIMARY KEY,
            name TEXT,
            album TEXT
          )
        SQL
        DB[:conn].execute(sql)
    end

    def save
        sql = <<-SQL
          INSERT INTO songs (name, album)
          VALUES (?, ?)
        SQL
    
        # insert the song
        DB[:conn].execute(sql, self.name, self.album)
    
        # get the song ID from the database and save it to the Ruby instance
        self.id = DB[:conn].execute("SELECT last_insert_rowid() FROM songs")[0][0]
    
        # return the Ruby instance
        self
      end

    def self.create(name:, breed:)
        song = Song.new(name:, breed:)
        song.save
    end

    def self.new_from_db(row)
        self.new(id: row[0], name: row[1], breed: row[2])
    end

    def self.all
        sql <<-SQL
            SELECT *
            FROM dogs
        SQL
        DB[:conn].execute(sql).map do |row|
            self.new_from_db(row)
        end
    end

    def find_by_name(name)
        sql<<-SQL
            SELECT *
            FROM dogs
            WHERE name = ?
            LIMIT 1;
        SQL
        DB[:conn].execute(sql).map do |row|
            self.new_from_db(row)
        end.first
    end

    def find(id)
        sql<<-SQL
            SELECT *
            FROM dogs
            WHERE id = ?
            LIMIT 1
        SQL
        DB[:conn].execute(sql).map do |row|
            self.new_from_db(row)
        end.first
    end
end
