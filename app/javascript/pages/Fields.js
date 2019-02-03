import React, { Fragment } from 'react'
import axios from 'axios'
import styled from 'styled-components'

const Field = ({ field }) => (
  <Fragment>
    <span className="bold h3">{field.label}</span> ({field.name})
    <FieldInput {...field} />
  </Fragment>
)
const FieldInput = ({ kind, options }) => {
  switch (kind) {
    case 'text':
      return <input type="text" value={kind} readOnly />
    case 'multiline':
      return <textarea readOnly>{kind}</textarea>
    case 'email':
      return <input type="email" value={kind} readOnly />
    case 'multiselect':
      return (
        <select readOnly>
          {options.map(option => (
            <option value={option} key={option}>
              {option}
            </option>
          ))}
        </select>
      )
  }
}

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
      <Fragment>
        {status === 'loading' ? (
          <p className="muted">Loading…</p>
        ) : (
          <div>
            {fields.map(field => (
              <Field field={field} key={field.name} />
            ))}
          </div>
        )}
      </Fragment>
    )
  }
}
