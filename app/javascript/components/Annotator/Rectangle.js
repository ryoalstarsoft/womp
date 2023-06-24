import React from 'react';
import styled from 'styled-components';

import RectangleSelector from './RectangleSelector';

const Container = styled.svg`
  box-sizing: border-box;
  transition: box-shadow 0.21s ease-in-out;
`;

function Rectangle(props) {
  const { geometry, data } = props.annotation;
  if (!geometry) return null;

  let color = '#FFFFFF';
  if (data !== undefined && data.color != null) color = data.color;
  else if (props.color !== undefined) color = props.color;

  return (
    <Container
      className={props.className}
      style={{
        border: `2px solid ${color}`,
        position: 'absolute',
        left: `${geometry.x}%`,
        top: `${geometry.y}%`,
        width: geometry.width + '%',
        height: geometry.height + '%',
        ...props.style,
      }}
    >
      <rect
        width="100%"
        height="100%"
        onMouseOver={props.onMouseOver}
        onMouseOut={props.onMouseOut}
        fillOpacity="0"
      />
    </Container>
  );
}

Rectangle.selector = RectangleSelector;
Rectangle.TYPE = 'RECTANGLE';
Rectangle.title = 'Rectangle';
Rectangle.icon = 'fa fa-square';

Rectangle.defaultProps = {
  className: '',
  style: {},
};

export default Rectangle;
