import React, { Fragment } from 'react'
import axios from 'axios'
import Fields from './Fields'
import { getAuthenticityToken } from 'utils'

export default class Registration extends React.Component {
  state = {
    status: 'loading',
    goal: null,
    open_at: null
  }

  componentDidMount() {
    this.getStatus()
  }

  getStatus() {
    const { event } = this.props.props
    axios.get(`/${event.slug}/registration_config.json`).then(res => {
      const registrationConfig = res.data
      this.setState({
        goal: registrationConfig.goal,
        open_at: registrationConfig.open_at,
        status: 'ready'
      })
    })
  }

  handleOpenAtChange = () => {
    const { event } = this.props.props
    const { open_at } = this.state
    axios
      .post(`/${event.slug}/edit_registration_config`, {
        registration_config: {
          open_at: open_at ? null : new Date().toISOString()
        }
      })
      .then(res => {
        this.setState({
          open_at: res.data.open_at
        })
      })
  }

  render() {
    const { status, goal, open_at } = this.state
    const { event } = this.props.props
    return (
      <Fragment>
        {status === 'loading' ? (
          <p className="muted">Loading…</p>
        ) : (
          <Fragment>
            {open_at ? (
              <p>
                Registration is <strong>open</strong>. Attendees can sign up
                through{' '}
                <a href={`/${event.slug}/registration/api`}>
                  your API endpoint
                </a>
                .
              </p>
            ) : (
              <p>
                Registration is <strong>closed</strong>. Attendees can only be{' '}
                <a href={`/${event.slug}/attendees/new`}>created manually</a>.
              </p>
            )}
            <span
              onClick={this.handleOpenAtChange}
              className={`btn ${open_at && 'bg-destroy'}`}
            >
              {open_at ? 'Close' : 'Open'} registration
            </span>
            {open_at && <Fields event={event} />}
          </Fragment>
        )}
      </Fragment>
    )
  }
}
