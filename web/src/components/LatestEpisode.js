import React, { Component } from 'react';

class LatestEpisode extends Component {
  static propTypes = {
    // episode: PropType.object.requred
  }

  render() {
    return (
      <div className="LatestEpisode">
        <div className="container">
          <div className="nunmber">600</div>
          <div className="title">
            Новые пести Ноября
          </div>
          <div className="artists">
            <span className="">Iron Maiden</span>
          </div>
        </div>
      </div>
    );
  }
}

export default LatestEpisode;
