const API_ROOT = 'http://localhost:3000/';

export const CALL_API = 'Call API';

const callApi = (endpoint) => {
  const fullUrl = (endpoint.indexOf(API_ROOT) === -1) ? API_ROOT + endpoint : endpoint;

  return fetch(fullUrl)
    .then((respose) => {
      return respose.json().then((json) => {
        return json;
      })
    });
}

export default (store) => (next) => (action) => {
  const apiAction = action[CALL_API];
  if (typeof apiAction === 'undefined') {
    return next(action);
  }

  const actionWith = (data) => {
    const finalAction = Object.assign({}, action, data);
    delete finalAction[CALL_API];
    return finalAction;
  };

  const { endpoint, types } = apiAction;
  const [ requestType, successType, failureType ] = types;

  next(actionWith({
    type: requestType
  }));

  return callApi(endpoint).then(
    (response) => next(actionWith({
      type: successType,
      response
    })),
    (error) => next(actionWith({
      type: failureType,
      error: error.message || 'Error happened'
    }))
  );

};
