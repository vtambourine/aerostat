class ArtistsController < ApplicationController
  def index
    @artists = Artist.all
    render json: @artists.as_json(
      only: [
        :name
      ]
    )
  end

  def show
    @artist = Artist.find(params[:id])

    sql = <<-SQL
      SELECT v.* FROM volumes AS v
      JOIN tracks_volumes AS tv ON tv.volume_id = v.id
      JOIN tracks AS t ON t.id = tv.track_id AND t.artist_id = :artist_id
    SQL

    @volumes = Volume.find_by_sql [ sql, { :artist_id => @artist.id } ]

    render json: @artist.as_json(
      only: [:name]
    ).merge(
      volumes: @volumes.as_json(
        only: [
          :number,
          :title,
          :published_at
        ]
      )
    )

  end
end
