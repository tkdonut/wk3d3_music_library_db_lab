require('pg')
require_relative('../db/sql_runner')
require_relative('album')


class Artist

attr_reader :id
attr_accessor :name

  def initialize (options)
    @id = options['id'].to_i if options['id']
    @name = options['name']
  end

  def save()
    # db = PG.connect({dbname: 'music_library', host: 'localhost'})
    sql = "INSERT INTO artists (name) VALUES($1) RETURNING id"
    values = [@name]
    # db.prepare("save", sql)
    @id = SqlRunner.run(sql, values)[0]['id'].to_i
    # db.close()
  end

  def self.all()
    sql = "SELECT * FROM artists"
    results = SqlRunner.run(sql)
    return results.map {|result| Artist.new(result)}
  end

  def delete()
    sql = "DELETE FROM artists WHERE id = $1"
    values = [@id]
    results = SqlRunner.run(sql, values)
  end


  def self.delete_all
    sql = "DELETE FROM artists"
    results = SqlRunner.run(sql)
  end

  def albums
    sql = "SELECT * FROM albums WHERE artist_id = $1"
    values = [@id]
    results = SqlRunner.run(sql, values)
    results.map {|result| Album.new(result)}
  end

  def update()
    sql = "UPDATE artists SET name = ($1) WHERE id = $2"
    values = [@name, @id]
    results = SqlRunner.run(sql, values)
  end

  def self.find_by_id(id)
    sql = "SELECT * FROM artists WHERE id = $1"
    values = [id]
    results = SqlRunner.run(sql, values)[0]
    return Artist.new(results)

  end

end
