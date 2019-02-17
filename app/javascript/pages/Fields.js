import React, { Fragment } from 'react'
import axios from 'axios'
import styled from 'styled-components'
import { sortBy } from 'lodash'

class Field extends React.Component {
  state = {
    name: this.props.field.name,
    label: this.props.field.label,
    kind: this.props.field.kind,
    options: this.props.field.options
  }

  updateLabel = e => {
    const label = e.target.value
    const name = label
      .trim()
      .replace(/[^\w\s]/gi, '')
      .toLowerCase()
      .replace(/ /g, '_')
    this.setState({ label, name })
  }

  addOption = () => {
    const { options } = this.state
    if (options) {
      let position = options[options.length - 1].position
      while (options.some(e => e.position === position)) position++

      this.setState(state => ({
        options: state.options.concat([{ position, value: '' }])
      }))
    } else {
      this.setState({ options: [{ position: 1, value: '' }] })
    }
  }
  updateOption = (position, value) => {
    let { options } = this.state
    const option = options.find(o => o.position === position)
    const newOption = option
    newOption.value = value
    options[options.indexOf(option)] = newOption
    this.setState({ options })
  }

  render() {
    const { field, disabled, focused, setFocused, deleteField } = this.props
    const { name, label, kind, options } = this.state
    return (
      <FieldWrapper focused={focused}>
        <div className="flex-auto">
          <label
            htmlFor={name}
            className="flex items-center"
            style={{ marginBottom: focused ? '0.5rem' : '2px' }}
          >
            {focused ? (
              <Fragment>
                <FieldName
                  placeholder="Field name"
                  value={label}
                  onChange={this.updateLabel}
                />
                <code className="ml1">{name === '' ? '…' : name}</code>
              </Fragment>
            ) : (
              <Fragment>
                <strong className="bold">{label}</strong>
                <code className="ml1">{name}</code>
              </Fragment>
            )}
            {disabled ? (
              <span className="badge ml-auto">Default</span>
            ) : focused ? (
              <div className="ml-auto flex items-center">
                <Action onClick={() => deleteField(field.name)}>
                  <svg
                    xmlns="http://www.w3.org/2000/svg"
                    width="24"
                    height="24"
                    viewBox="0 0 24 24"
                    fill="none"
                    stroke="currentColor"
                    strokeWidth="1.5"
                    strokeLinecap="round"
                    strokeLinejoin="round"
                  >
                    <polyline points="3 6 5 6 21 6" />
                    <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2" />
                    <line x1="10" y1="11" x2="10" y2="17" />
                    <line x1="14" y1="11" x2="14" y2="17" />
                  </svg>
                </Action>
                <Action onClick={() => setFocused('')}>
                  <svg
                    xmlns="http://www.w3.org/2000/svg"
                    width="24"
                    height="24"
                    viewBox="0 0 24 24"
                    fill="none"
                    stroke="currentColor"
                    strokeWidth="1.5"
                    strokeLinecap="round"
                    strokeLinejoin="round"
                  >
                    <line x1="18" y1="6" x2="6" y2="18" />
                    <line x1="6" y1="6" x2="18" y2="18" />
                  </svg>
                </Action>
              </div>
            ) : (
              <Actions onClick={() => setFocused(field.name)}>
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
              </Actions>
            )}
          </label>
          {focused ? (
            <Fragment>
              <select
                value={kind}
                icon={`/icons/${kind}.svg`}
                onChange={e => this.setState({ kind: e.target.value })}
                className="mb1"
              >
                <option value="text">Text input</option>
                <option value="multiline">Multi-line text input</option>
                <option value="email">Email input</option>
                {/*<option value="checkbox">Checkbox</option>*/}
                <option value="multiselect">Multiple choice</option>
              </select>
              {kind === 'multiselect' && (
                <Fragment>
                  <div className="flex items-center mb1">
                    <span className="bold">Options</span>
                    <Actions onClick={() => this.addOption()}>
                      Add
                      <svg
                        xmlns="http://www.w3.org/2000/svg"
                        width="24"
                        height="24"
                        viewBox="0 0 24 24"
                        stroke="currentColor"
                        strokeWidth="1.5"
                        strokeLinecap="round"
                        strokeLinejoin="round"
                      >
                        <line x1="12" y1="5" x2="12" y2="19" />
                        <line x1="5" y1="12" x2="19" y2="12" />
                      </svg>
                    </Actions>
                  </div>
                  {options ? (
                    sortBy(options, ['position']).map(option => (
                      <input
                        type="text"
                        value={option.value}
                        key={option.position}
                        onChange={e =>
                          this.updateOption(option.position, e.target.value)
                        }
                        placeholder="Option text"
                        style={{ marginBottom: '0.25rem' }}
                      />
                    ))
                  ) : (
                    <span className="muted">No options found.</span>
                  )}
                </Fragment>
              )}
            </Fragment>
          ) : (
            <FieldInput name={name} kind={kind} options={options} />
          )}
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
const Action = styled.span.attrs({
  className: 'primary'
})`
  cursor: pointer;
  &:hover {
    color: #0045a6;
  }
`
const Actions = styled(Action).attrs({
  className: 'ml-auto flex items-center primary'
})``
const FieldName = styled.input.attrs({ type: 'text' })`
  max-width: 12rem !important;
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
            {options ? (
              <Fragment>
                <option value="" disabled>
                  Select an option
                </option>
                {options.map(option => (
                  <option key={option.position} value={option.value}>
                    {option.value}
                  </option>
                ))}
              </Fragment>
            ) : (
              <option value="" disabled>
                No options available
              </option>
            )}
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
    axios.get(`/events/${event.slug}/registration.json`).then(res => {
      this.setState({ fields: res.data, status: 'ready' })
    })
  }

  setFocused = fieldName => {
    this.setState({ focusedField: fieldName })
  }
  deleteField = fieldName => {
    const check = confirm(
      'Are you sure you want to delete this field and all responses? You cannot undo this.'
    )
    if (check) {
      this.setState(state => ({
        fields: state.fields.filter(e => e.name !== fieldName),
        focusedField: ''
      }))
    }
  }

  addField = () => {
    // TODO: use 'position' to handle case of multiple empty fields
    // search for field.name and change to field.position
    const { fields } = this.state
    let label = ['New field', 0]
    while (
      fields.some(
        e =>
          (e.label === label[0] && label[1] === 0) ||
          e.label === label.join(' ')
      )
    ) {
      label[1]++
    }

    const newLabel = label[1] === 0 ? label[0] : label.join(' ')
    const name = newLabel
      .trim()
      .replace(/[^\w\s]/gi, '')
      .toLowerCase()
      .replace(/ /g, '_')
    this.setState(state => ({
      fields: state.fields.concat([{ name, label: newLabel, kind: 'text' }])
    }))
  }

  render() {
    const { fields, focusedField } = this.state
    return (
      <Fragment>
        <h2 className="heading" style={{ marginBottom: '1rem' }}>
          Edit signup form
          <span className="btn" onClick={this.addField}>
            Add field
          </span>
        </h2>
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
                deleteField={this.deleteField}
                key={field.name}
              />
            ))}
          </Fragment>
        )}
      </Fragment>
    )
  }
}
