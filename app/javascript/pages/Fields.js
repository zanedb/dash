import React from 'react'
import _ from 'lodash'
import axios from 'axios'

export default class Fields extends React.Component {
  state = {
    status: 'loading',
    fields: []
  }

  componentDidMount() {
    const { event } = this.props.props
    axios.get(`/events/${event.slug}/fields.json`).then(res => {
      this.setState({ fields: res.data, status: 'ready' })
    })
  }

  render() {
    const { fields } = this.state
    return (
      <div>
        {status == 'loading' ? (
          <p className="muted">Loading…</p>
        ) : (
          <div>
            {fields.map(field => (
              <h3>{field.name}</h3>
            ))}
          </div>
        )}
      </div>
    )
  }
}
