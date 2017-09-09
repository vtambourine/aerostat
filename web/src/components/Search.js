import React, { Component } from 'react';

class Search extends Component {
  static defaultProps = {
    query: '',
    onChange: () => {}
  }

  onExampleClick(event) {
    event.target.value = event.target.innerText;
    this.props.onChange.apply(this, arguments);
  }

  render() {
    return (
      <div className="Search">
        <div className="Search-input-holder">
          <label className="Search-label">
            ∅
          </label>
          <input className="Search-input"
            type="text"
            value={this.props.query}
            onChange={this.props.onChange}
            placeholder="Поиск"/>
        </div>
        <div className="Search-examples">
          {'Например, '}
          <span className="Search-example"
            onClick={this.onExampleClick.bind(this)}>
            Новые песни октября
          </span>
          {' или '}
          <span className="Search-example"
            onClick={this.onExampleClick.bind(this)}>
            Bob Dylan
          </span>
        </div>
      </div>
    )
  }
}

export default Search;
