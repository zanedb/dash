import React, { Fragment } from 'react'
import axios from 'axios'
import styled from 'styled-components'

const Field = ({ field, disabled }) => (
  <div className="flex items-end col-12 mb2">
    <div className="flex-auto">
      <label htmlFor={field.name} className="flex items-center">
        <strong className="bold">{field.label}</strong>
        <code className="ml1">{field.name}</code>
        {disabled && <span className="badge ml-auto">Default</span>}
      </label>
      <FieldInput {...field} />
    </div>
    {!disabled && <EditButton />}
  </div>
)

const FieldInput = ({ name, kind, options }) => {
  switch (kind) {
    case 'text':
      return (
        <Input
          type="text"
          placeholder="Text input"
          icon="/icons/text.svg"
          id={name}
          readOnly
        />
      )
    case 'multiline':
      return (
        <Input
          as="textarea"
          placeholder="Multi-line input"
          icon="/icons/multiline.svg"
          id={name}
          readOnly
        />
      )
    case 'email':
      return (
        <Input
          type="email"
          placeholder="Email input"
          icon="/icons/email.svg"
          id={name}
          readOnly
        />
      )
    case 'multiselect':
      return (
        <select id={name} readOnly>
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
  background-image: url('${props => props.icon}');
  background-position: 0.5rem center;
  background-size: auto 50%;
  background-repeat: no-repeat;
  padding-left: 2rem !important;
`

const DefaultFields = () => (
  <Fragment>
    {[
      { label: 'First Name', name: 'first_name', kind: 'text' },
      { label: 'Last Name', name: 'last_name', kind: 'text' },
      { label: 'Email Address', name: 'email', kind: 'email' },
      { label: 'Note', name: 'note', kind: 'multiline' }
    ].map(defaultField => (
      <Field field={defaultField} key={defaultField.name} disabled />
    ))}
  </Fragment>
)
const EditButton = () => (
  <a className="btn btn--icon ml2">
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
          <Fragment>
            <DefaultFields />
            {fields.map(field => (
              <Field field={field} key={field.name} />
            ))}
          </Fragment>
        )}
      </Fragment>
    )
  }
}
