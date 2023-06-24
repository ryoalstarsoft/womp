import React from 'react';
import styled, { keyframes } from 'styled-components';

const Inner = styled.div`
  padding: 8px 16px;

  textarea {
    border: 0;
    margin: 6px 0;
    min-height: 60px;
    outline: 0;
  }
`;

const Button = styled.div`
  background: whitesmoke;
  border: 0;
  box-sizing: border-box;
  cursor: pointer;
  font-size: 1rem;
  margin: 0;
  outline: 0;
  padding: 8px 16px;
  text-align: center;
  text-shadow: 0 1px 0 rgba(0, 0, 0, 0.1);

  transition: background 0.21s ease-in-out;

  &:focus,
  &:hover {
    background: #eeeeee;
  }
`;

function TextEditor(props) {
  return (
    <React.Fragment>
      <Inner>
        <textarea
          placeholder="write description"
          onFocus={props.onFocus}
          onBlur={props.onBlur}
          onChange={props.onChange}
          value={props.value}
          className="w-100"
        />
      </Inner>
      {!props.value && (
        <Button onClick={props.onCancel} className="w-100 womp-red">
          cancel
        </Button>
      )}
      {props.value &&
        props.annotation.id && (
          <div>
            <Button
              onClick={props.onCancel}
              className="fl w-third womp-red"
            >
              cancel
            </Button>
            <Button
              onClick={props.onDelete}
              className="fl w-third womp-red"
            >
              delete
            </Button>
            <Button
              onClick={props.onSubmit}
              className="fl w-third womp-green"
            >
              submit
            </Button>
          </div>
        )}
      {props.value &&
        !props.annotation.id && (
          <div>
            <Button
              onClick={props.onCancel}
              className="fl w-50 womp-red"
            >
              cancel
            </Button>
            <Button
              onClick={props.onSubmit}
              className="fl w-50 womp-green"
            >
              submit
            </Button>
          </div>
        )}
    </React.Fragment>
  );
}

export default TextEditor;
