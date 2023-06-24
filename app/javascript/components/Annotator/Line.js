import React from 'react';
import styled from 'styled-components';

import LineSelector from './LineSelector';

const Container = styled.svg`
  box-sizing: border-box;
`;

function Line(props) {
  const { geometry, data } = props.annotation;
  if (!geometry) return null;

  let color = '#FFFFFF';
  if (data !== undefined && data.color != null) color = data.color;
  else if (props.color !== undefined) color = props.color;

  const { x: x1, y: y1, width: x2, height: y2 } = geometry;

  return (
    <Container
      className={props.className}
      style={{
        position: 'absolute',
        left: 0,
        top: 0,
        ...props.style,
      }}
      height="100%"
      width="100%"
      viewBox="0 0 100 100"
      preserveAspectRatio="none"
      pointerEvents="none"
    >
      <line
        stroke={color}
        strokeWidth="2px"
        vectorEffect="non-scaling-stroke"
        x1={x1}
        y1={y1}
        x2={x2}
        y2={y2}
      />
      <line
        stroke="black"
        strokeWidth="10px"
        strokeOpacity="0"
        vectorEffect="non-scaling-stroke"
        x1={x1}
        y1={y1}
        x2={x2}
        y2={y2}
        pointerEvents="painted"
        onMouseOver={props.onMouseOver}
        onMouseOut={props.onMouseOut}
      />
    </Container>
  );
}

Line.selector = LineSelector;
Line.TYPE = 'LINE';
Line.title = 'Line';
Line.icon = 'fas fa-minus';

Line.defaultProps = {
  className: '',
  style: {},
};

export default Line;
