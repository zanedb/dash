import React, { Fragment } from 'react'
import styled from 'styled-components'
import { isEmpty, sortBy } from 'lodash'

export default ({
  id,
  name,
  label,
  kind,
  options,
  position,
  focused,
  setFocused,
  updateField,
  deleteField,
  disabled
}) => {
  const updateLabel = e => {
    const label = e.target.value
    const name = label
      .trim()
      .replace(/[^\w\s]/gi, '')
      .toLowerCase()
      .replace(/ /g, '_')
    updateField(position, { label, name })
  }

  const addOption = () => {
    if (isEmpty(options)) {
      updateField(position, { options: [{ position: 1, value: '' }] })
    } else {
      let optionPosition = options[options.length - 1].position
      while (options.some(e => e.position === optionPosition)) optionPosition++

      updateField(position, {
        options: options.concat([{ position: optionPosition, value: '' }])
      })
    }
  }

  const updateOption = (optionPosition, value) => {
    const option = options.find(o => o.position === optionPosition)
    const newOption = option
    newOption.value = value
    options[options.indexOf(option)] = newOption
    updateField(position, { options })
  }

  const deleteOption = optionPosition => {
    updateField(position, {
      options: options.filter(o => o.position !== optionPosition)
    })
  }

  return (
    <FieldWrapper focused={focused}>
      <div className="flex-auto">
        <label
          htmlFor={name}
          className="flex items-center"
          style={{ marginBottom: focused ? '0.5rem' : '2px' }}
        >
          {focused ? (
            <Fragment>
              <FieldNameInput
                placeholder="Field name"
                value={label}
                onChange={updateLabel}
                autoFocus
              />
              <code className="ml1">{name === '' ? '…' : name}</code>
            </Fragment>
          ) : (
            <Fragment>
              <strong className="bold">{label}</strong>
              <code className="ml1">{name}</code>
            </Fragment>
          )}
          {disabled ? (
            <span className="badge ml-auto">Default</span>
          ) : focused ? (
            <div className="ml-auto flex items-center">
              <Action onClick={() => deleteField(position)}>
                <Icon icon="trash" />
              </Action>
              <Action onClick={() => setFocused('')}>
                <Icon icon="x" />
              </Action>
            </div>
          ) : (
            <Actions onClick={() => setFocused(position)}>
              <span style={{ marginRight: '0.25rem' }}>Edit</span>
              <Icon icon="edit" />
            </Actions>
          )}
        </label>
        {focused ? (
          <Fragment>
            <span className="bold">Type</span>
            <select
              value={kind}
              icon={`/icons/${kind}.svg`}
              onChange={e => updateField(position, { kind: e.target.value })}
              className="mb1"
            >
              <option value="text">Text input</option>
              <option value="multiline">Multi-line text input</option>
              <option value="email">Email input</option>
              {/*<option value="checkbox">Checkbox</option>*/}
              <option value="multiselect">Multiple choice</option>
            </select>
            {kind === 'multiselect' && (
              <Fragment>
                <div className="flex items-center mb1">
                  <span className="bold">Options</span>
                  <Actions onClick={() => addOption()}>
                    Add
                    <Icon icon="add" />
                  </Actions>
                </div>
                {isEmpty(options) ? (
                  <span className="muted">No options found.</span>
                ) : (
                  sortBy(options, ['position']).map(option => (
                    <div className="flex items-center" key={option.position}>
                      <input
                        type="text"
                        value={option.value}
                        onChange={e =>
                          updateOption(option.position, e.target.value)
                        }
                        placeholder="Option text"
                        style={{ marginBottom: '0.25rem' }}
                      />
                      <Action
                        className="ml1"
                        onClick={() => deleteOption(option.position)}
                      >
                        <Icon icon="trash" />
                      </Action>
                    </div>
                  ))
                )}
              </Fragment>
            )}
          </Fragment>
        ) : (
          <FieldInput name={name} kind={kind} options={options} />
        )}
      </div>
    </FieldWrapper>
  )
}
const FieldWrapper = styled.div.attrs({
  className: 'flex items-end col-12 mb2'
})`
  ${props =>
    props.focused &&
    `
    border-left: 4px solid #0069ff;
    border-radius: 2px;
    padding: 1.5rem;
    box-shadow: rgba(0, 0, 0, 0.2) 0px 8px 32px;
  `}
`
const Action = styled.span.attrs({
  className: 'primary'
})`
  cursor: pointer;
  &:hover {
    color: #0045a6;
  }
`
const Actions = styled(Action).attrs({
  className: 'ml-auto flex items-center primary'
})``
const FieldNameInput = styled.input.attrs({ type: 'text' })`
  max-width: 12rem !important;
`

const FieldInput = ({ name, kind, options }) => {
  switch (kind) {
    case 'text':
      return (
        <Input
          type="text"
          placeholder="Text input"
          icon="/icons/text.svg"
          id={name}
          readOnly
        />
      )
    case 'multiline':
      return (
        <Textarea
          placeholder="Multi-line input"
          icon="/icons/multiline.svg"
          id={name}
          readOnly
        />
      )
    case 'email':
      return (
        <Input
          type="email"
          placeholder="Email input"
          icon="/icons/email.svg"
          id={name}
          readOnly
        />
      )
    case 'multiselect':
      return (
        <select id={name} readOnly>
          <Fragment>
            {options ? (
              <Fragment>
                <option value="" disabled>
                  Select an option
                </option>
                {options.map(option => (
                  <option key={option.position} value={option.value}>
                    {option.value}
                  </option>
                ))}
              </Fragment>
            ) : (
              <option value="" disabled>
                No options available
              </option>
            )}
          </Fragment>
        </select>
      )
    default:
      null
  }
}
const Input = styled.input`
  background-image: url('${props => props.icon}');
  background-position: 0.5rem center;
  background-size: auto 50%;
  background-repeat: no-repeat;
  padding-left: 2rem !important;
`
const Textarea = styled.textarea`
  background-image: url('${props => props.icon}');
  background-position: 0.5rem 0.4rem;
  background-size: auto 30%;
  background-repeat: no-repeat;
  padding-left: 2rem !important;
`

const Icon = ({ icon }) => (
  <svg
    xmlns="http://www.w3.org/2000/svg"
    width={icon === 'edit' ? '16' : '24'}
    height="24"
    viewBox="0 0 24 24"
    fill="none"
    stroke="currentColor"
    strokeWidth="1.5"
    strokeLinecap="round"
    strokeLinejoin="round"
  >
    <g>
      {icon === 'edit' && (
        <g>
          <path d="M20 14.66V20a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h5.34" />
          <polygon points="18 2 22 6 12 16 8 16 8 12 18 2" />
        </g>
      )}
      {icon === 'add' && (
        <g>
          <line x1="12" y1="5" x2="12" y2="19" />
          <line x1="5" y1="12" x2="19" y2="12" />
        </g>
      )}
      {icon === 'trash' && (
        <g>
          <polyline points="3 6 5 6 21 6" />
          <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2" />
          <line x1="10" y1="11" x2="10" y2="17" />
          <line x1="14" y1="11" x2="14" y2="17" />
        </g>
      )}
      {icon === 'x' && (
        <g>
          <line x1="18" y1="6" x2="6" y2="18" />
          <line x1="6" y1="6" x2="18" y2="18" />
        </g>
      )}
    </g>
  </svg>
)
