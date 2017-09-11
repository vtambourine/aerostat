import React, { Component } from 'react';

class Episodes extends Component {
  static defaultProps = {
    offset: 0,
    count: 10
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

  renderLoader() {
    return (
      <div className="Episodes-loader">
        Loading...
      </div>
    );
  }

  render() {
    const { offset, count } = this.props;
    const { isFetching, items, filteredItems } = this.props.episodes;
    const episodes = filteredItems;
    const isEmpty = episodes.lenght === 0;

    // console.log(this.props.episodes);

    if (isFetching || isEmpty) {
      return this.renderLoader();
    } else {
      return (
        <div className="Episodes">
          <div>Всего эпизодов: {episodes.length}</div>
          {episodes
            .slice(offset, offset + count)
            .map(this.renderEpisode.bind(this))}
          <div>
            <button onClick={this.props.onPrevtClick}>Show previous</button>
            <button onClick={this.props.onNextClick}>Show next</button>
          </div>
        </div>
      );
    }
  }
}

export default Episodes;
