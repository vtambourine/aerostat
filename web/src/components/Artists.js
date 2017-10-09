import React, { Component } from 'react'

class Artists extends Component {
  static defaultProps = {
    items: []
  }

  renderArtist(artist, key) {
    return (
      <div className="ArtistSearch" key={key}>
        <div className="ArtistSearch--name">
          {artist.name}
        </div>
      </div>
    )
  }

  render() {
    return (
      <div className="Artists">
        {'Here will be artists'}
        {this.props.items.map(this.renderArtist.bind(this))}
      </div>
    )
  }
}

export default Artists;
