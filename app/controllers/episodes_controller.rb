class EpisodesController < ApplicationController
  before_action :set_volume, only: [:show, :update, :destroy]

  # GET /episodes
  def index
    order = params.fetch(:order, :desc)
    @episodes = Episode.order(id: order)

    render json: @episodes.as_json(
      methods: :permalink,
      only: [ :id, :number,
        :title, :published_at
      ]
    ).map { |v|
      if v["id"]
        v.merge({
          url: episode_url(v["id"])
        })
      else
        v
      end
    }
  end

  # GET /episodes/1
  def show
    render json: @episode.as_json(
      only: [ :id, :number, :title, :text,
        :published_at, :aquarium_url, :aerostatica_url
      ],
      include: {
        tracks: {
          only: [ :artist, :title ],
          include: {
            artist: {
              only: [ :name ]
            }
          }
        }
      }
    ).merge({url: episode_url(@episode)})
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_episode
      @episode = Episode.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def episode_params
      params.require(:episode).permit(:number, :title, :order)
    end
end
