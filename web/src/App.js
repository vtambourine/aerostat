import React, { Component } from 'react';
import { connect } from 'react-redux';
import Episodes from './components/Episodes';
import Artists from './components/Artists';
import Search from './components/Search';
import LatestEpisode from './components/LatestEpisode';
import {
  loadEpisodes,
  loadArtists,
  changeQuery,
  showMoreEpisodes
} from './actions';

import { getVisibleArtists } from './modules/artists.js';

import './App.css';

class App extends Component {
  componentDidMount() {
    this.props.dispatch(loadEpisodes());
    this.props.dispatch(loadArtists());
  }

  handleSearchChange(event) {
    this.props.dispatch(changeQuery(event.target.value));
  }

  showMoreEpisodes() {
    this.props.dispatch(showMoreEpisodes())
  }

  render() {
    return (
      <div className="App">
        <div className="App--content">
          <div className="App-header">
            <h1 className="App-title">Аэростат</h1>
          </div>
          <LatestEpisode episode={this.props.episodes[0]} />
          <Search
            query={this.props.query}
            onChange={this.handleSearchChange.bind(this)} />
          <Episodes
            isFetching={this.props}
            episodes={this.props.episodes}
            offset={this.props.episodesOffset}
            onNextClick={this.showMoreEpisodes.bind(this)} />

          <Artists
            isFetching={this.props.artists.isFetching}
            items={this.props.artists} />
        </div>
      </div>
    );
  }
}

const mapStateToProps = (state) => {
  const { query, episodes, artists, pagination } = state;
  return {
    query,
    episodes,
    artists: getVisibleArtists(state),
    episodesOffset: pagination.offset
  }
};

export default connect(
  mapStateToProps
)(App);
