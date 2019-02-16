import React, { Fragment } from 'react'
import axios from 'axios'
import styled from 'styled-components'

class Field extends React.Component {
  state = {}

  render() {
    const { field, disabled, focused, setFocused } = this.props
    return (
      <FieldWrapper focused={focused} onClick={() => setFocused(field.name)}>
        <div className="flex-auto">
          <label
            htmlFor={field.name}
            className="flex items-center"
            style={{ marginBottom: '2px', pointerEvents: 'none' }}
          >
            <strong className="bold">{field.label}</strong>
            <code className="ml1">{field.name}</code>
            {disabled ? (
              <span className="badge ml-auto">Default</span>
            ) : (
              !focused && (
                <EditField>
                  Edit
                  <svg
                    style={{ marginLeft: '0.25rem' }}
                    xmlns="http://www.w3.org/2000/svg"
                    width="16"
                    height="24"
                    viewBox="0 0 24 24"
                    fill="none"
                    stroke="currentColor"
                    strokeWidth="1.5"
                    strokeLinecap="round"
                    strokeLinejoin="round"
                  >
                    <g>
                      <path d="M20 14.66V20a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h5.34" />
                      <polygon points="18 2 22 6 12 16 8 16 8 12 18 2" />
                    </g>
                  </svg>
                </EditField>
              )
            )}
          </label>
          <FieldInput {...field} />
        </div>
      </FieldWrapper>
    )
  }
}
const FieldWrapper = styled.div.attrs({
  className: 'flex items-end col-12 mb2 px2'
})`
  ${props =>
    props.focused &&
    `
    border-left: 4px solid #0069ff;
    border-radius: 2px;
    padding: 1.5rem;
    box-shadow: rgba(0, 0, 0, 0.2) 0px 8px 32px;
  `}
`
const EditField = styled.span.attrs({
  className: 'ml-auto flex items-center primary'
})`
  &:hover {
    color: #0045a6;
  }
`

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
        <Textarea
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
const Textarea = styled.textarea`
  background-image: url('${props => props.icon}');
  background-position: 0.5rem 0.4rem;
  background-size: auto 30%;
  background-repeat: no-repeat;
  padding-left: 2rem !important;
`

export default class Fields extends React.Component {
  state = {
    status: 'loading',
    fields: [],
    focusedField: ''
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

  setFocused = fieldName => {
    this.setState({ focusedField: fieldName })
  }

  render() {
    const { fields, focusedField } = this.state
    return (
      <Fragment>
        {status === 'loading' ? (
          <p className="muted">Loading…</p>
        ) : (
          <Fragment>
            {[
              { label: 'First Name', name: 'first_name', kind: 'text' },
              { label: 'Last Name', name: 'last_name', kind: 'text' },
              { label: 'Email Address', name: 'email', kind: 'email' },
              { label: 'Note', name: 'note', kind: 'multiline' }
            ].map(defaultField => (
              <Field
                field={defaultField}
                focused={focusedField === defaultField.name}
                setFocused={this.setFocused}
                key={defaultField.name}
                disabled
              />
            ))}
            {fields.map(field => (
              <Field
                field={field}
                focused={focusedField === field.name}
                setFocused={this.setFocused}
                key={field.name}
              />
            ))}
          </Fragment>
        )}
      </Fragment>
    )
  }
}
