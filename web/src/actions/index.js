import { CALL_API } from '../middleware/api';

export const EPISODES_REQUEST = 'EPISODES_REQUEST';
export const EPISODES_SUCCESS = 'EPISODES_SUCCESS';
export const EPISODES_FAILURE = 'EPISODES_FAILURE';

const fetchEpisodes = () => ({
  [CALL_API]: {
    types: [ EPISODES_REQUEST, EPISODES_SUCCESS, EPISODES_FAILURE ],
    endpoint: 'volumes'
  }
});

export const loadEpisodes = () => (dispatch) => {
  return dispatch(fetchEpisodes());
};
