import { createSelector } from 'reselect';

const getArtists = (state) => state.artists.items;
const getSearchQuery = (state) => state.query;

const getEpisodes = (state) => state.episodes.itemsByNumber;

const getArtistWithEpisodes = createSelector(
  [getArtists, getEpisodes],
  (artists, episodes = {}) => {
    return artists.map(artist => {
      return {
        ...artist,
        episodes: artist.episodes.map(id => episodes[id])
      }
    })
  }
)

export const getVisibleArtists = createSelector(
  // [ getArtists, getSearchQuery ],
  [ getArtistWithEpisodes, getSearchQuery ],
  (artists, query) => {
    // TODO: Implement Search
    if (query) {
      return artists.filter(artist => artist.name.indexOf(query) >= 0);
    } else {
      return artists;
    }
  }
)
