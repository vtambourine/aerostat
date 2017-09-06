import { combineReducers } from 'redux';
import {
  EPISODES_REQUEST,
  EPISODES_SUCCESS,
  EPISODES_FAILURE,

  SEARCH_QUERY_CHANGE,
  SHOW_MORE_EPISODES
} from '../actions';

const query = (state = '', action) => {
  switch (action.type) {
    case SEARCH_QUERY_CHANGE:
      return action.query;
    default:
      return state;
  }
};

const episodes = (state = [], action) => {
  switch (action.type) {
    case EPISODES_SUCCESS:
      return [].concat(action.response);
    default:
      return state;
  }
};

const pagination = (state = {
  offset: 0,
  count: 20
}, action) => {
  if (action.type === SHOW_MORE_EPISODES) {
    return {
      ...state,
      offset: action.offset
    }
  }

  return state;
};

const rootReducer = combineReducers({
  query,
  episodes,
  pagination
});

export default rootReducer;
