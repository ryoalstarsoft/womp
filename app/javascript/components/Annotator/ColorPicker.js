import React, { Component } from 'react';
import { CirclePicker as BasePicker } from 'react-color';
import styled from 'styled-components';

const colors = [
	'#FFFFFF',
  '#545259',
  '#4348A6',
	'#18AA53',
	'#FE7E43',
	'#FFCC33',
	'#891E9B',
];

// Necessary to fix spacing and add border unless we want to fork and copy the circle picker
const StyledPicker = styled(BasePicker)`
  padding-left: 2px;
  justify-content: center;
  &.circle-picker span div span div {
    border: 1px solid #CBCACD !important;
  }
`;
const CirclePicker = props => (
  <StyledPicker
    width="100%"
    circleSize={24}
    circleSpacing={8}
    colors={colors}
		color={'#545259'}
    {...props}
  />
);

export default CirclePicker;
