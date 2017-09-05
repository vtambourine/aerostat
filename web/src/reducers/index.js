import { combineReducers } from 'redux';
import {
  EPISODES_REQUEST,
  EPISODES_SUCCESS,
  EPISODES_FAILURE
} from '../actions';

const episodes = (state = [], action) => {
  switch (action.type) {
    case EPISODES_SUCCESS:
      return [].concat(action.response);
    default:
      return state;
  }
};

const rootReducer = combineReducers({
  episodes
});

export default rootReducer;
