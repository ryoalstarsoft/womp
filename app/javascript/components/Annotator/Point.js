import React from 'react';
import styled from 'styled-components';

import PointSelector from './PointSelector';

const Container = styled.div`
  border-radius: 50%;
  box-sizing: border-box;
  height: 16px;
  position: absolute;
  transform: translate3d(-50%, -50%, 0);
  width: 16px;
`;

function Point(props) {
  const { geometry, data } = props.annotation;
  if (!geometry) return null;

  let color = '#FFFFFF';
  if (data !== undefined && data.color != null) color = data.color;
  else if (props.color !== undefined) color = props.color;

  return (
    <Container
      style={{
        border: `3px solid ${color}`,
        top: `${geometry.y}%`,
        left: `${geometry.x}%`,
      }}
      onMouseOver={props.onMouseOver}
      onMouseOut={props.onMouseOut}
    />
  );
}

Point.selector = PointSelector;
Point.TYPE = 'POINT';
Point.title = 'Point';
Point.icon = 'far fa-dot-circle';

export default Point;
