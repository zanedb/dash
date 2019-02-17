import React, { Fragment } from 'react'
import axios from 'axios'
import Field from 'components/Field'
import { getAuthenticityToken } from 'utils'

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
  updateField = (id, object) => {
    const { fields } = this.state
    const field = fields.find(o => o.id === id)
    const newField = Object.assign(field, object)
    fields[fields.indexOf(field)] = newField
    this.setState({ fields, focusedField: newField.name })
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

  save = () => {
    const method = 'POST'
    // fake HTTP requests, Rails thing
    let browserHTTPMethod = 'POST'
    let fakedHTTPMethod = null
    if (method.toLowerCase() === 'get') {
      browserHTTPMethod = 'GET'
    } else if (method.toLowerCase() !== 'post') {
      fakedHTTPMethod = method
    }
    const csrfToken = getAuthenticityToken()
    axios({
      method: browserHTTPMethod,
      url: `/events/${event.slug}/registration/${this.props.field.slug}`,
      data: {
        authenticity_token: csrfToken,
        _method: fakedHTTPMethod,
        attendee_field: {
          name: field.name,
          label: field.label,
          kind: field.kind,
          value: field.value
        }
      }
    })
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
                {...defaultField}
                focused={focusedField === defaultField.name}
                setFocused={this.setFocused}
                key={defaultField.name}
                disabled
              />
            ))}
            {fields.map(field => (
              <Field
                {...field}
                focused={focusedField === field.name}
                setFocused={this.setFocused}
                deleteField={this.deleteField}
                updateField={this.updateField}
                key={field.name}
              />
            ))}
          </Fragment>
        )}
      </Fragment>
    )
  }
}
