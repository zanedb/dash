import React from 'react'
import { Formik } from 'formik'

export default () => (
  <Formik
    initialValues={{ name: '', startDate: '', endDate: '', location: '' }}
    onSubmit={values => {}}
    render={props => (
      <form onSubmit={props.handleSubmit}>
        {props.errors.name && <div class="error">{props.errors.name}</div>}
        <input
          type="text"
          name="name"
          placeholder="Hackity Hackathon"
          onChange={props.handleChange}
          onBlur={props.handleBlur}
          value={props.values.name}
        />
        {props.errors.startDate && (
          <div class="error">{props.errors.startDate}</div>
        )}
        <input
          type="text"
          name="startDate"
          placeholder="2018-07-21T17:00:00.000Z"
          onChange={props.handleChange}
          onBlur={props.handleBlur}
          value={props.values.startDate}
        />
        {props.errors.endDate && (
          <div class="error">{props.errors.endDate}</div>
        )}
        <input
          type="text"
          name="endDate"
          placeholder="2018-07-22T21:00:00.000Z"
          onChange={props.handleChange}
          onBlur={props.handleBlur}
          value={props.values.endDate}
        />
        {props.errors.location && (
          <div class="error">{props.errors.location}</div>
        )}
        <textarea
          cols="20"
          name="location"
          placeholder="Address"
          onChange={props.handleChange}
          onBlur={props.handleBlur}
          value={props.values.location}
        />
        <button type="submit">Submit</button>
      </form>
    )}
  />
)
