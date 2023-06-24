import React from 'react';

import Point from './Point';
import Editor from './Editor';
import Rectangle from './Rectangle';
import Oval from './Oval';
import Line from './Line';
import Arrow from './Arrow';
import Content from './Content';
import Overlay from './Overlay';
import Measurement from './Measurement';

const types = [Point, Rectangle, Oval, Line, Arrow, Measurement];
function renderType(props) {
  const Selector = types.find(t => t.TYPE === props.annotation.geometry.type);
  if (Selector === undefined) return nul;
  return <Selector {...props} />;
}

export default {
  innerRef: () => {},
  onChange: () => {},
  onSubmit: () => {},
  type: Point.TYPE,
  types,
  disableAnnotation: false,
  disableSelector: false,
  disableEditor: false,
  disableOverlay: false,
  activeAnnotationComparator: (a, b) => a === b,
  renderSelector: renderType,
  renderEditor: ({ annotation, onChange, onSubmit }) => (
    <Editor annotation={annotation} onChange={onChange} onSubmit={onSubmit} />
  ),
  renderHighlight: renderType,
  renderContent: ({ key, annotation }) => (
    <Content key={key} annotation={annotation} />
  ),
  renderOverlay: ({ type, annotation }) => {
    switch (type) {
      case Point.TYPE:
        return <Overlay>Click to Annotate</Overlay>;
      default:
        return <Overlay>Click and Drag to Annotate</Overlay>;
    }
  },
};
