import React, { Component } from 'react';

class Search extends Component {
  static defaultProps = {
    query: '',
    onChange: () => {}
  }

  componentDidMount() {
    console.log(this.refs);
  }

  onExampleClick(event) {
    event.target.value = event.target.innerText;
    this.props.onChange.apply(this, arguments);
  }

  render() {
    return (
      <div className="Search">
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
        <div className="Search-input-holder">
          <input className="Search-input"
            ref="search"
            type="text"
            value={this.props.query}
            onChange={this.props.onChange}
            placeholder="Поиск"
            autoFocus />
        </div>
      </div>
    )
  }
}

export default Search;
