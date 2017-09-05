import React, { Component } from 'react';
import { loadEpisodes } from '../actions';

class Episodes extends Component {
  static defaultProps = {
    episodes: [
      { id: 1, title: "Alpha" },
      { id: 2, title: "Beta" }
    ]
  }

  fetchEpisodes() {
    this.props.dispatch(loadEpisodes())
    console.log(this.state);
  }

  renderEpisode(episode) {
    if (!episode) {
      return;
    }

    const { id, title } = episode;

    return (
      <div className="Episode" key={id}>
        {id} = {title}
      </div>
    );
  }

  render() {
    return (
      <div className="Episodes">
        <h3>Here will be episodes</h3>
        {this.props.episodes.sort((a, b) => {
          return parseInt(a.id) > parseInt(b.id) ? 1 : -1
        }).map(this.renderEpisode.bind(this))}
        <button onClick={this.fetchEpisodes.bind(this)}>
          Fetch!
        </button>
      </div>
    );
  }
}

export default Episodes;
