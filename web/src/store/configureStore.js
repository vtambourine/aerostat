import { createStore, applyMiddleware, compose } from 'redux';
import thunkMiddleware from 'redux-thunk';
import apiMiddleware from '../middleware/api';
import rootReducer from '../reducers';

// ---
// Middlewares
// ---
const middlewares = [
  thunkMiddleware,
  apiMiddleware
];

// ---
// Enchancers
// ---
const enhancers = [
  window.devToolsExtension ? window.devToolsExtension() : f => f
]

const configureStore = (preloadedState = {}) => {
  const store = createStore(
    rootReducer,
    preloadedState,
    compose(applyMiddleware(...middlewares), ...enhancers)
  );

  return store;
};

export default configureStore;
