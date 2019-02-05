import React, { Fragment } from 'react'
import axios from 'axios'
import styled from 'styled-components'

const Field = ({ field }) => (
  <Card>
    <span className="bold h3">{field.label}</span> ({field.name})
    <FieldInput {...field} />
    <EditButton style={{ float: 'right', marginRight: '1rem' }} />
  </Card>
)
const Card = styled.article`
  min-height: 6rem;
  padding: 1.5rem;
  margin-bottom: 1rem;
  border-radius: 8px;
  box-shadow: rgba(0, 0, 0, 0.063) 0px 8px 32px;
`
const EditButton = () => (
  <a className="btn btn--icon">
    <svg
      xmlns="http://www.w3.org/2000/svg"
      width="16"
      height="24"
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      strokeWidth="2"
      strokeLinecap="round"
      strokeLinejoin="round"
    >
      <path d="M20 14.66V20a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h5.34" />
      <polygon points="18 2 22 6 12 16 8 16 8 12 18 2" />
    </svg>
  </a>
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
    this.getFields()
  }

  getFields() {
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
