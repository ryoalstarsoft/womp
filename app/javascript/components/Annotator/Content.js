import React from 'react';
import styled from 'styled-components';

const Container = styled.div`
  background: white;
  border-radius: 2px;
  box-shadow: 0px 1px 5px 0px rgba(0, 0, 0, 0.2),
    0px 2px 2px 0px rgba(0, 0, 0, 0.14), 0px 3px 1px -2px rgba(0, 0, 0, 0.12);
  padding: 8px 16px;
  margin-top: 8px;
  margin-left: 8px;
`;

function Content(props) {
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
      style={{
        position: 'absolute',
        left: `${left}%`,
        top: `${top}%`,
        ...props.style,
      }}
      className={props.className}
      geometry={geometry}
    >
      {props.annotation.data && props.annotation.data.text}
    </Container>
  );
}

Content.defaultProps = {
  style: {},
  className: '',
};

export default Content;
