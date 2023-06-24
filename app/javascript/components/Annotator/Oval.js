import React from 'react';
import styled from 'styled-components';

import RectangleSelector from './RectangleSelector';

const Container = styled.div`
  border-radius: 100%;
  box-sizing: border-box;
`;

function Oval(props) {
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
        height: `${geometry.height}%`,
        width: `${geometry.width}%`,
        ...props.style,
      }}
      onMouseOver={props.onMouseOver}
      onMouseOut={props.onMouseOut}
    />
  );
}

Oval.selector = RectangleSelector;
Oval.TYPE = 'OVAL';
Oval.title = 'Oval';
Oval.icon = 'fa fa-circle';

Oval.defaultProps = {
  className: '',
  style: {},
};

export default Oval;
