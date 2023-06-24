import React from 'react';
import styled from 'styled-components';

import LineSelector from './LineSelector';

const Container = styled.svg`
  box-sizing: border-box;
`;

function Measurement(props) {
  const { geometry, data } = props.annotation;
  if (!geometry) return null;

  let color = '#FFFFFF';
  if (data !== undefined && data.color != null) color = data.color;
  else if (props.color !== undefined) color = props.color;

  const { x: x1, y: y1, width: x2, height: y2 } = geometry;
  // Calculates the modified angle and scaled view by aspect ratio
  /* preserveAspectRatio='none' leads to a stretch on Y
    that is always proportional to width / height */
  const { width, height } = props.relativeMousePos;
  const ratio = width / height;
  const angle = Math.atan2((y2 - y1) / ratio, x2 - x1);
  const angleDeg = (angle * 180) / Math.PI;
  const scale = `scale(0.25,${ratio * 0.25})`;
  const rotate = `rotate(${angleDeg})`;
  const translate1 = `translate(${x1},${y1})`;
  const translate2 = `translate(${x2},${y2})`;

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
        x1={0}
        x2={0}
        y1={-3}
        y2={3}
        transform={`${translate1} ${scale} ${rotate}`}
      />
      <line
        stroke={color}
        strokeWidth="2px"
        vectorEffect="non-scaling-stroke"
        x1={0}
        x2={0}
        y1={-3}
        y2={3}
        transform={`${translate2} ${scale} ${rotate}`}
      />
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
        strokeOpacity="0"
        strokeWidth="15px"
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

Measurement.selector = LineSelector;
Measurement.TYPE = 'MEASUREMENT';
Measurement.title = 'Measurement';
Measurement.icon = 'fas fa-arrows-alt-h';

Measurement.defaultProps = {
  className: '',
  style: {},
};

export default Measurement;
