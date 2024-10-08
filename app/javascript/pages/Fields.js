import React, { Fragment } from 'react'
import axios from 'axios'
import IdleTimer from 'react-idle-timer'
import qs from 'qs'
import Field from 'components/Field'
import { isEmpty, differenceBy } from 'lodash'
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
    window.addEventListener(
      'beforeunload',
      this.handleWindowBeforeUnload.bind(this)
    )
  }

  componentWillUnmount() {
    window.removeEventListener(
      'beforeunload',
      this.handleWindowBeforeUnload.bind(this)
    )
  }

  handleWindowBeforeUnload(e) {
    if (this.state.hasChanged) {
      e.preventDefault()
      e.returnValue = true
    }
  }

  getFields() {
    const { event } = this.props
    axios.get(`/${event.slug}/registration.json`).then(res => {
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
    // include more serious prompt for preexisting fields
    const { fields } = this.state
    const field = fields.find(o => o.position === position)
    let check = true
    if (field.id) {
      check = confirm(
        'Are you sure you want to delete this field and all responses? You cannot undo this.'
      )
    } else {
      check = confirm('Are you sure you want to delete this field?')
    }
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

    // generate "New field x" label & name
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

    // handle position of new field
    if (isEmpty(fields)) {
      this.setState(state => ({
        fields: state.fields.concat([
          { name, label: newLabel, kind: 'text', position: '1' }
        ]),
        focusedField: '1',
        hasChanged: true
      }))
    } else {
      let position = fields[fields.length - 1].position
      while (fields.some(e => e.position === position)) position++

      this.setState(state => ({
        fields: state.fields.concat([
          { name, label: newLabel, kind: 'text', position }
        ]),
        focusedField: position,
        hasChanged: true
      }))
      window.scrollTo(0, document.body.scrollHeight)
    }
  }

  save = () => {
    const { hasChanged, fields } = this.state
    const { event } = this.props
    if (hasChanged) {
      // get old fields from endpoint, compare, update server-side data
      axios.get(`/${event.slug}/registration.json`).then(res => {
        const oldFields = res.data
        const deletionDiff = differenceBy(oldFields, fields, 'id')

        fields.forEach(f => {
          if (f.id === undefined) {
            // create field
            const csrfToken = getAuthenticityToken()
            axios({
              method: 'post',
              url: `/${event.slug}/registration`,
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
            // edit field
            const csrfToken = getAuthenticityToken()
            axios({
              method: 'post',
              url: `/${event.slug}/registration/${f.slug}`,
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
              // reset field's "updated" state
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
          // delete field
          const csrfToken = getAuthenticityToken()
          axios({
            method: 'post',
            url: `/${event.slug}/registration/${f.slug}`,
            headers: {
              'Content-Type': 'application/x-www-form-urlencoded'
            },
            data: qs.stringify({
              authenticity_token: csrfToken,
              _method: 'delete'
            })
          })
        })
      })
      this.setState({ hasChanged: false })
    }
  }

  render() {
    const { fields, focusedField, hasChanged } = this.state
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
              { label: 'Email Address', name: 'email', kind: 'email' }
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
