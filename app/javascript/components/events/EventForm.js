import React from 'react'
import styled from 'styled-components'
import { Formik } from 'formik'
import * as yup from 'yup'
import axios from 'axios'
import qs from 'qs'
import { getAuthenticityToken } from '../../utils'

const ErrorMessage = styled.div`
  color: red;
`

const Form = styled.form`
  display: flex;
  flex-direction: column;
`

const Input = styled.input`
  max-width: 20rem;
`

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
        axios({
          method,
          url,
          data: qs.stringify({
            authenticity_token: csrfToken,
            event: {
              name: values.name,
              startDate: values.startDate,
              endDate: values.endDate,
              location: values.location
            }
          })
        })
          .then(res => {
            setSubmitting(false)
            console.log(res)
            window.location.href = res.request.responseURL // TODO: FIX THIS FOR EDITING
          })
          .catch(err => {
            console.log(err)
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
