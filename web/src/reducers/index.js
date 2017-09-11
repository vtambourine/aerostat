import { combineReducers } from 'redux';
import {
  EPISODES_REQUEST,
  EPISODES_SUCCESS,
  EPISODES_FAILURE,

  ARTISTS_REQUEST,
  ARTISTS_SUCCESS,
  ARTISTS_FAILURE,

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

function filterEpisodes(query, items) {
  if (query.length === 0) {
    return items;
  }

  return items.filter((item) => {
    // Try number
    var number = parseInt(query);
    if ((number !== NaN) && item.number === number) {
      return item;
    }

    // Try title
    // TODO: Replace with safe regexp generation
    if ((new RegExp(query, 'i')).test(item.title)) {
      return item;
    }
  });
}

const episodes = (state = {
  isFetching: false,
  items: [],
  filteredItems: [],
  query: ''
}, action) => {
  switch (action.type) {
    case EPISODES_REQUEST:
      return {
        ...state,
        isFetching: true
      }
    case EPISODES_SUCCESS:
      return {
        ...state,
        isFetching: false,
        items: [].concat(action.response),
        filteredItems: filterEpisodes(state.query, action.response)
      };
    case SEARCH_QUERY_CHANGE:
      return {
        ...state,
        query: action.query.trim(),
        filteredItems: filterEpisodes(action.query, state.items)
      }
    default:
      return state;
  }
};

const artists = (state = {
  isFetching: false,
  items: []
}, action) => {
  switch (action.type) {
    case ARTISTS_REQUEST:
      return {
        ...state,
        isFetching: true
      }
    case ARTISTS_SUCCESS:
      return {
        ...state,
        isFetching: false,
        items: [].concat(action.response)
      }
    case ARTISTS_FAILURE:
      return {
        ...state,
        isFetching: false,
        error: action.error
      }
    default:
      return state;
  }
}

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
  artists,
  pagination
});

export default rootReducer;
