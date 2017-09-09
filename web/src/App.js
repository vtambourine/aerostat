import React, { Component } from 'react';
import { connect } from 'react-redux';
import Episodes from './components/Episodes';
import Search from './components/Search';
import {
  loadEpisodes,
  changeQuery,
  showMoreEpisodes
} from './actions';
import logo from './logo.svg';
import './App.css';

class App extends Component {
  componentDidMount() {
    this.props.dispatch(loadEpisodes());
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
        <div className="App-header">
          <h2>Aerostat</h2>
        </div>
        <Search
          query={this.props.query}
          onChange={this.handleSearchChange.bind(this)} />
        <Episodes
          isFetching={this.props}
          episodes={this.props.episodes}
          offset={this.props.episodesOffset}
          onNextClick={this.showMoreEpisodes.bind(this)}/>
      </div>
    );
  }
}

const mapStateToProps = (state) => {
  const { query, episodes, pagination } = state;
  return {
    query,
    episodes,
    episodesOffset: pagination.offset
  }
};

export default connect(
  mapStateToProps
)(App);
