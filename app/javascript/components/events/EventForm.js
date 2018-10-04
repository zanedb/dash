import React from 'react'
import { Formik } from 'formik'
import * as yup from 'yup'
import 'unfetch/polyfill'
import qs from 'qs'
import { ErrorMessage, Form, Input } from '../helpers/Form'
import { getAuthenticityToken } from '../../utils'

export default ({ values, url, method }) => {
  const csrfToken = getAuthenticityToken()
  return (
    <Formik
      initialValues={
        values || { name: '', startDate: '', endDate: '', location: '' }
      }
      validationSchema={yup.object().shape({
        name: yup.string().required(),
        startDate: yup.date('Invalid date').required(),
        endDate: yup.date('Invalid date').required(),
        location: yup.string().required()
      })}
      onSubmit={(values, setSubmitting) => {
        // fake HTTP requests, Rails thing idk
        let browserHTTPMethod = 'POST'
        let fakedHTTPMethod = null
        if (method.toLowerCase() === 'get') {
          browserHTTPMethod = 'GET'
        } else if (method.toLowerCase() !== 'post') {
          fakedHTTPMethod = method
        }

        fetch(url, {
          method: browserHTTPMethod,
          headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
          body: qs.stringify({
            authenticity_token: csrfToken,
            _method: fakedHTTPMethod,
            event: {
              name: values.name,
              startDate: values.startDate,
              endDate: values.endDate,
              location: values.location
            }
          })
        })
          .then(res => {
            window.location.href = res.url
          })
          .catch(err => {
            console.error(err)
          })
      }}
      render={props => (
        <Form onSubmit={props.handleSubmit}>
          {props.errors.name && (
            <ErrorMessage>{props.errors.name}</ErrorMessage>
          )}
          <Input
            type="text"
            name="name"
            placeholder="Hackity Hackathon"
            onChange={props.handleChange}
            onBlur={props.handleBlur}
            value={props.values.name}
          />
          {props.errors.startDate && (
            <ErrorMessage>{props.errors.startDate}</ErrorMessage>
          )}
          <Input
            type="text"
            name="startDate"
            placeholder="2018-07-21T17:00:00.000Z"
            onChange={props.handleChange}
            onBlur={props.handleBlur}
            value={props.values.startDate}
          />
          {props.errors.endDate && (
            <ErrorMessage>{props.errors.endDate}</ErrorMessage>
          )}
          <Input
            type="text"
            name="endDate"
            placeholder="2018-07-22T21:00:00.000Z"
            onChange={props.handleChange}
            onBlur={props.handleBlur}
            value={props.values.endDate}
          />
          {props.errors.location && (
            <ErrorMessage>{props.errors.location}</ErrorMessage>
          )}
          <textarea
            style={{ maxWidth: '20rem' }}
            cols="20"
            name="location"
            placeholder="Address"
            onChange={props.handleChange}
            onBlur={props.handleBlur}
            value={props.values.location}
          />
          <button style={{ maxWidth: '20rem' }} type="submit">
            Submit
          </button>
        </Form>
      )}
    />
  )
}
