import React, { Fragment } from 'react'
import axios from 'axios'
import styled from 'styled-components'

const Field = ({ field, disabled }) => (
  <Fragment>
    <div className="flex items-center">
      <span>
        <span className="bold h3">{field.label}</span> ({field.name})
      </span>{' '}
      {disabled && <span className="badge">Default</span>}
    </div>
    <FieldInput {...field} />
    {!disabled && (
      <EditButton style={{ float: 'right', marginRight: '1rem' }} />
    )}
  </Fragment>
)
const DefaultFields = () => (
  <Fragment>
    {[
      { label: 'First Name', name: 'first_name', kind: 'text' },
      { label: 'Last Name', name: 'last_name', kind: 'text' },
      { label: 'Email Address', name: 'email', kind: 'email' },
      { label: 'Note', name: 'note', kind: 'multiline' }
    ].map(defaultField => (
      <li>
        <Field field={defaultField} key={defaultField.name} disabled />
      </li>
    ))}
  </Fragment>
)
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
      return (
        <Input
          type="text"
          placeholder="Text input"
          icon="/icons/type.svg"
          readOnly
        />
      )
    case 'multiline':
      return <textarea placeholder="Multi-line input" readOnly />
    case 'email':
      return <input type="email" placeholder="Email input" readOnly />
    case 'multiselect':
      return (
        <select readOnly>
          <Fragment>
            <option value="" disabled>
              Select an option
            </option>
            {options.map(option => (
              <option value={option} key={option}>
                {option}
              </option>
            ))}
          </Fragment>
        </select>
      )
  }
}
const Input = styled.input`
  padding-left: 2rem;
  &:before {
    content: url('${props => props.icon}') !important;
  }
`

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
          <ul className="list list--unlinked">
            <DefaultFields />
            {fields.map(field => (
              <li>
                <Field field={field} key={field.name} />
              </li>
            ))}
          </ul>
        )}
      </Fragment>
    )
  }
}
