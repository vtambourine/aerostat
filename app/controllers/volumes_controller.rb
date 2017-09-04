class VolumesController < ApplicationController
  before_action :set_volume, only: [:show, :update, :destroy]

  # GET /volumes
  def index
    @volumes = Volume.all

    render json: @volumes.as_json(
      methods: :permalink,
      only: [
        :id,
        :number,
        :title,
        :published_at
      ]
    ).map { |v|
      if v["id"]
        v.merge({
          url: volume_url(v["id"])
        })
      else
        v
      end
    }
  end

  # GET /volumes/1
  def show
    render json: @volume.as_json(
      only: [
        :id,
        :number,
        :title,
        :text,
        :published_at,
        :aquarium_url,
        :aerostatica_url
      ],
      include: {
        tracks: {
          only: [
            :artist,
            :title
          ],
          include: {
            artist: {
              only: [
                :name
              ]
            }
          }
        }
      }
    ).merge({url: volume_url(@volume)})
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_volume
      @volume = Volume.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def volume_params
      params.require(:volume).permit(:number, :title)
    end
end
