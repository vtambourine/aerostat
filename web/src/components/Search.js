import React, { Component } from 'react';

class Search extends Component {
  static defaultProps = {
    query: '',
    onChange: () => {}
  }

  render() {
    console.log(this.props);
    return (
      <div className="Search">
        <label className="Search-label">
          <input className="Search-input"
            type="text"
            value={this.props.query}
            onChange={this.props.onChange} />
        </label>
      </div>
    )
  }
}

export default Search;
