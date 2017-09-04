class TracksController < ApplicationController

  def index
    @tracks = Track.all

    render json: @tracks.as_json(
      only: [:artist, :title, :duration],
      include: {
        issues: {
          only: [:number, :title]
        }
      }
    )
  end

end
