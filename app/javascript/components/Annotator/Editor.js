import React from 'react';
import styled, { keyframes } from 'styled-components';
import TextEditor from './TextEditor';

const fadeInScale = keyframes`
  from {
    opacity: 0;
    transform: scale(0);
  }

  to {
    opacity: 1;
    transform: scale(1);
  }
`;

const Container = styled.div`
  background: white;
  border-radius: 2px;
  box-shadow: 0px 1px 5px 0px rgba(0, 0, 0, 0.2),
    0px 2px 2px 0px rgba(0, 0, 0, 0.14), 0px 3px 1px -2px rgba(0, 0, 0, 0.12);
  margin-top: 16px;
  transform-origin: top left;

  animation: ${fadeInScale} 0.31s cubic-bezier(0.175, 0.885, 0.32, 1.275);
  overflow: hidden;
`;

function Editor(props) {
  const { geometry } = props.annotation;
  if (!geometry) return null;

  let left;
  let top;
  switch (geometry.type) {
    case 'LINE':
    case 'ARROW':
    case 'MEASUREMENT':
      left = Math.min(geometry.x, geometry.width);
      top = Math.max(geometry.y, geometry.height);
      break;
    default:
      left = geometry.x;
      top = geometry.y + geometry.height;
      break;
  }

  return (
    <Container
      className={props.className}
      style={{
        zIndex: '9999',
        position: 'absolute',
        left: `${left}%`,
        top: `${top}%`,
        ...props.style,
      }}
    >
      <TextEditor
        onChange={e =>
          props.onChange({
            ...props.annotation,
            data: {
              ...props.annotation.data,
              text: e.target.value,
            },
          })
        }
        onCancel={e =>
          props.onCancel({
            ...props.annotation,
          })
        }
        onDelete={e =>
          props.onDelete({
            ...props.annotation,
          })
        }
        onSubmit={props.onSubmit}
        value={props.annotation.data && props.annotation.data.text}
        annotation={props.annotation}
      />
    </Container>
  );
}

Editor.defaultProps = {
  className: '',
  style: {},
};

export default Editor;
