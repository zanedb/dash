import React from 'react'
import { Formik } from 'formik'
import * as yup from 'yup'
import 'unfetch/polyfill'
import qs from 'qs'
import { ErrorMessage, Form, Input } from '../../helpers/Form'
import { getAuthenticityToken } from '../../../utils'

export default ({ values, url, method }) => {
  const csrfToken = getAuthenticityToken()
  return (
    <Formik
      initialValues={values || { fname: '', lname: '', email: '', note: '' }}
      validationSchema={yup.object().shape({
        fname: yup.string().required(),
        lname: yup.string().required(),
        email: yup
          .string()
          .email('invalid email')
          .required(),
        note: yup.string()
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
            attendee: {
              fname: values.fname,
              lname: values.lname,
              email: values.email,
              note: values.note
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
          {props.errors.fname && (
            <ErrorMessage>{props.errors.fname}</ErrorMessage>
          )}
          <Input
            type="text"
            name="fname"
            placeholder="John"
            onChange={props.handleChange}
            onBlur={props.handleBlur}
            value={props.values.fname}
          />
          {props.errors.lname && (
            <ErrorMessage>{props.errors.lname}</ErrorMessage>
          )}
          <Input
            type="text"
            name="lname"
            placeholder="Appleseed"
            onChange={props.handleChange}
            onBlur={props.handleBlur}
            value={props.values.lname}
          />
          {props.errors.email && (
            <ErrorMessage>{props.errors.email}</ErrorMessage>
          )}
          <Input
            type="text"
            name="email"
            placeholder="john@appleseed.com"
            onChange={props.handleChange}
            onBlur={props.handleBlur}
            value={props.values.email}
          />
          {props.errors.note && (
            <ErrorMessage>{props.errors.note}</ErrorMessage>
          )}
          <textarea
            style={{ maxWidth: '20rem' }}
            cols="20"
            name="note"
            placeholder="Blah blah"
            onChange={props.handleChange}
            onBlur={props.handleBlur}
            value={props.values.note}
          />
          <button style={{ maxWidth: '20rem' }} type="submit">
            Submit
          </button>
        </Form>
      )}
    />
  )
}
