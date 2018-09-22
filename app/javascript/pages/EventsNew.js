import React, { Fragment } from 'react'
import { Formik } from 'formik'
import * as yup from 'yup'
import styled from 'styled-components'

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

export default () => (
  <Fragment>
    <a href="/">Home</a> › <a href="/events">Events</a> ›{' '}
    <a href="#">Add Event</a>
    <h1>Add an Event</h1>
    <Formik
      initialValues={{ name: '', startDate: '', endDate: '', location: '' }}
      validationSchema={yup.object().shape({
        name: yup.string().required(),
        startDate: yup.date('Invalid date').required(),
        endDate: yup.date('Invalid date').required(),
        location: yup.string().required()
      })}
      onSubmit={values => {}}
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
  </Fragment>
)
