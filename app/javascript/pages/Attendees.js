import React, { Fragment } from 'react'
import Fuse from 'fuse.js'
import { isEmpty } from 'lodash'
import { getAvatarUrl } from '../utils'

const Attendee = ({
  path,
  slug,
  name,
  email,
  checked_in_at,
  checked_out_at
}) => (
  <a href={`${path}/${slug}`}>
    <li>
      <img
        src={getAvatarUrl(name, email)}
        className="profile-img"
        width={48}
        height={48}
      />
      <div className="ml2">
        <span className="bold block">
          {name}
          {checked_in_at === null ? null : (
            <span
              className={
                checked_out_at === null ? 'badge bg-info' : 'badge bg-success'
              }
            >
              Checked in{checked_out_at === null ? null : ' & out'}
            </span>
          )}
        </span>
        <span className="muted">{email}</span>
      </div>
    </li>
  </a>
)

export default class Attendees extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      value: ''
    }
    const { attendees } = this.props.props
    // make full name of attendee searchable
    for (const attendee of attendees) {
      attendee.name = `${attendee.first_name} ${attendee.last_name}`
    }
    const options = {
      shouldSort: true,
      threshold: 0.2,
      keys: ['name', 'email', 'public_id']
    }
    this.fuse = new Fuse(attendees, options)
  }

  render() {
    const { value } = this.state
    const attendees =
      value === '' ? this.props.props.attendees : this.fuse.search(value)
    return (
      <Fragment>
        {isEmpty(this.props.props.attendees) ? (
          <p className="muted">There are no attendees.</p>
        ) : (
          <Fragment>
            <input
              type="search"
              id="search"
              aria-label="Search"
              className="input full-width"
              placeholder={`Search ${attendees.length} attendee${
                attendees.length === 1 ? '' : 's'
              }…`}
              value={value}
              onChange={e => this.setState({ value: e.target.value })}
            />
            {isEmpty(attendees) ? (
              <p className="muted">No attendees found.</p>
            ) : (
              <ul
                className={`list list--row list--border-always ${
                  attendees.length === 1 ? '' : 'list--dual'
                }`}
              >
                {attendees.map(attendee => (
                  <Attendee
                    key={attendee.slug}
                    path={this.props.props.path}
                    {...attendee}
                  />
                ))}
              </ul>
            )}
          </Fragment>
        )}
      </Fragment>
    )
  }
}
