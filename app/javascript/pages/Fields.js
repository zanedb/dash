import React, { Fragment } from 'react'
import axios from 'axios'
import IdleTimer from 'react-idle-timer'
import qs from 'qs'
import Field from 'components/Field'
import { isEmpty, difference, differenceBy } from 'lodash'
import { getAuthenticityToken } from 'utils'

export default class Fields extends React.Component {
  state = {
    status: 'loading',
    fields: [],
    focusedField: '',
    hasChanged: false
  }

  componentDidMount() {
    this.getFields()
  }

  getFields() {
    const { event } = this.props.props
    axios.get(`/events/${event.slug}/registration.json`).then(res => {
      const fields = res.data
      let i = 1
      fields.forEach(a => {
        a.position = i
        a.options = a.options
          ? JSON.parse(a.options)
            ? JSON.parse(a.options)
            : a.options
          : a.options
        i++
      })
      this.setState({ fields, status: 'ready' })
    })
  }

  updateField = (position, object) => {
    const { fields } = this.state
    const field = fields.find(o => o.position === position)
    const newField = Object.assign(field, object)
    newField.updated = true
    newField.position = position
    fields[fields.indexOf(field)] = newField
    this.setState({ fields, focusedField: newField.position, hasChanged: true })
  }

  setFocused = position => {
    this.setState({ focusedField: position })
  }

  deleteField = position => {
    const check = confirm(
      'Are you sure you want to delete this field and all responses? You cannot undo this.'
    )
    if (check) {
      this.setState(state => ({
        fields: state.fields.filter(e => e.position !== position),
        focusedField: '',
        hasChanged: true
      }))
    }
  }

  addField = () => {
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

    if (isEmpty(fields)) {
      this.setState(state => ({
        fields: state.fields.concat([
          { name, label: newLabel, kind: 'text', position: '1' }
        ]),
        hasChanged: true
      }))
    } else {
      let position = fields[fields.length - 1].position
      while (fields.some(e => e.position === position)) position++

      this.setState(state => ({
        fields: state.fields.concat([
          { name, label: newLabel, kind: 'text', position }
        ]),
        hasChanged: true
      }))
    }
  }

  save = () => {
    const { hasChanged, fields } = this.state
    const { event } = this.props.props
    if (hasChanged) {
      axios.get(`/events/${event.slug}/registration.json`).then(res => {
        const oldFields = res.data
        const deletionDiff = differenceBy(oldFields, fields, 'id')

        fields.forEach(f => {
          if (f.id === undefined) {
            // create field
            const csrfToken = getAuthenticityToken()
            axios({
              method: 'post',
              url: `/events/${event.slug}/registration`,
              headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
              },
              data: qs.stringify({
                authenticity_token: csrfToken,
                _method: 'post',
                attendee_field: {
                  name: f.name,
                  label: f.label,
                  kind: f.kind,
                  options: JSON.stringify(f.options)
                }
              })
            })
          } else if (f.updated !== undefined) {
            // edited field
            const csrfToken = getAuthenticityToken()
            axios({
              method: 'post',
              url: `/events/${event.slug}/registration/${f.slug}`,
              headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
              },
              data: qs.stringify({
                authenticity_token: csrfToken,
                _method: 'patch',
                attendee_field: {
                  name: f.name,
                  label: f.label,
                  kind: f.kind,
                  options: JSON.stringify(f.options)
                }
              })
            }).then(() => {
              const { fields } = this.state
              const field = fields.find(o => o.position === f.position)
              const newField = field
              newField.updated = undefined
              fields[fields.indexOf(field)] = newField
              this.setState({ fields })
            })
          }
        })
        deletionDiff.forEach(f => {
          const csrfToken = getAuthenticityToken()
          axios({
            method: 'post',
            url: `/events/${event.slug}/registration/${f.slug}`,
            headers: {
              'Content-Type': 'application/x-www-form-urlencoded'
            },
            data: qs.stringify({
              authenticity_token: csrfToken,
              _method: 'delete'
            })
          }).catch(e => console.log(e))
        })
      })
      this.setState({ hasChanged: false })
    }
  }

  render() {
    const { fields, focusedField, hasChanged } = this.state
    /*if (hasChanged) {
      window.addEventListener('beforeunload', event => {
        event.returnValue = 'Your changes haven’t yet been saved!'
      })
    }*/
    return (
      <Fragment>
        <IdleTimer
          ref={ref => {
            this.idleTimer = ref
          }}
          element={document}
          onIdle={this.save}
          debounce={250}
          timeout={5000}
        />
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
                focused={focusedField === field.position}
                setFocused={this.setFocused}
                deleteField={this.deleteField}
                updateField={this.updateField}
                key={field.position}
              />
            ))}
            <div className="flex justify-center h3 muted">
              {hasChanged ? (
                <span>
                  Unsaved changes —{' '}
                  <a onClick={() => this.save()} style={{ cursor: 'pointer' }}>
                    save now
                  </a>
                  .
                </span>
              ) : (
                <span>All changes saved.</span>
              )}
            </div>
          </Fragment>
        )}
      </Fragment>
    )
  }
}
