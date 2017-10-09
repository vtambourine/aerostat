import { CALL_API } from '../middleware/api';

export const EPISODES_REQUEST = 'EPISODES_REQUEST';
export const EPISODES_SUCCESS = 'EPISODES_SUCCESS';
export const EPISODES_FAILURE = 'EPISODES_FAILURE';

const fetchEpisodes = () => ({
  [CALL_API]: {
    types: [ EPISODES_REQUEST, EPISODES_SUCCESS, EPISODES_FAILURE ],
    endpoint: 'episodes?order=desc'
  }
});

export const loadEpisodes = () => (dispatch) => {
  return dispatch(fetchEpisodes());
};

export const ARTISTS_REQUEST = 'ARTISTS_REQUEST';
export const ARTISTS_SUCCESS = 'ARTISTS_SUCCESS';
export const ARTISTS_FAILURE = 'ARTISTS_FAILURE';

export const loadArtists = () => {
  return {
    type: ARTISTS_SUCCESS,
    response: [
      { name: 'Iron Maiden', episodes: [1, 4, 5] },
      { name: 'Queen', episodes: [10, 40, 50] },
      { name: 'Bob Dylan', episodes: [100, 400, 500] }
    ]
  }
}

export const SEARCH_QUERY_CHANGE = 'SEARCH_QUERY_CHANGE';

export const changeQuery = (query) => ({
  type: SEARCH_QUERY_CHANGE,
  query
});

export const SHOW_MORE_EPISODES = 'SHOW_MORE_EPISODES';

export const showMoreEpisodes = () => (dispatch, getState) => {
  const offset = getState().pagination.offset;
  return dispatch({
    type: SHOW_MORE_EPISODES,
    offset: offset + 20
  });
};
