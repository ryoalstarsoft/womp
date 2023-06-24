import React, { Component } from 'react';
import T from 'prop-types';
import styled from 'styled-components';
import rafSchd from 'raf-schd';
import withRelativeMousePos from './utils/withRelativeMousePos';

import defaultProps from './annotationProps';
import Overlay from './Overlay';

const Container = styled.div`
  clear: both;
  position: relative;
  width: 100%;
  &:hover ${Overlay} {
    opacity: 1;
  }
`;

const Img = styled.img`
  display: block;
  width: 100%;
`;

const Items = styled.div`
  position: absolute;
  top: 0;
  left: 0;
  bottom: 0;
  right: 0;
`;

const noop = function() {};

class Annotation extends Component {
  static propTypes = {
    innerRef: T.func,
    onMouseUp: T.func,
    onMouseDown: T.func,
    onMouseMove: T.func,
    onClick: T.func,

    annotations: T.arrayOf(
      T.shape({
        type: T.string,
      })
    ).isRequired,
    type: T.string,
    types: T.arrayOf(T.func).isRequired,

    value: T.shape({
      selection: T.object,
      geometry: T.shape({
        type: T.string.isRequired,
      }),
      data: T.object,
    }),
    onChange: T.func,
    onSubmit: T.func,

    activeAnnotationComparator: T.func,
    activeAnnotations: T.arrayOf(T.any),

    disableAnnotation: T.bool,
    disableSelector: T.bool,
    renderSelector: T.func,
    disableEditor: T.bool,
    renderEditor: T.func,

    renderHighlight: T.func.isRequired,
    renderContent: T.func.isRequired,

    disableOverlay: T.bool,
    renderOverlay: T.func.isRequired,
  };

  constructor(props) {
    super(props);

    this.scheduleMouseMove = rafSchd((x, y) => this.onMouseMove(x, y));
  }

  componentWillMount() {
    this.scheduleMouseMove.cancel();
  }

  state = {
    top: null,
    selecting: false,
  };

  static defaultProps = defaultProps;

  setInnerRef = el => {
    this.props.relativeMousePos.innerRef(el);
    this.props.innerRef(el);
  };

  getSelectorByType = type => {
    const foundType = this.props.types.find(s => s.TYPE === type);
    if (foundType !== undefined) return foundType.selector;
    if (process.env.NODE_ENV !== 'production') {
      console.error(`Unable to find selector for type: ${type}`);
    }
  };

  callDefined = (value, fn) => {
    if (fn !== undefined && typeof value !== 'undefined') {
      fn(value);
    }
  };

  onMouseMove = (x, y) => {
    this.props.relativeMousePos.onMouseMove(x, y);
    this.callDefined(this.callSelectorMethod('onMouseMove'), this.changeType);
  };

  onTargetMouseMove = e => {
    this.scheduleMouseMove(e.clientX, e.clientY);
  };

  onTargetMouseLeave = e => {
    this.props.relativeMousePos.onMouseLeave(e);
  };

  isSelecting = () =>
    this.props.value !== undefined && this.props.value.selection !== undefined;

  onMouseUp = e => {
    const value = this.callSelectorMethod('onMouseUp', e);

    if (
      (typeof value === 'undefined' || value.selection === undefined) &&
      this.isSelecting() &&
      this.props.value.selection.showEditor
    ) {
      this.callDefined(this.props.value, this.props.onChange);
      return;
    }

    this.callDefined(value, this.changeValueColor);
  };

  // Change a shape's color, not okay to mutate because it could be a stale object
  changeValueColor = value => {
    const data = value.data === undefined ? {} : value.data;
    this.props.onChange({
      ...value,
      data: {
        ...data,
        color: this.props.color,
      },
    });
  };

  // Assign shape's type once, this is okay to mutate because it is direct from a selector
  changeType = value => {
    if (value.geometry !== undefined && value.geometry.type === undefined) {
      value.geometry.type = this.props.type;
    }
    this.props.onChange(value);
  };

  onMouseDown = e => {
    // Edit current annotation by clicking
    const { top } = this.state;
    if (top !== null) {
      const newTop = {
        ...top,
        selection: { ...top.selection, showEditor: true, mode: 'EDITING' },
      };
      this.props.onChange(newTop);
      return newTop;
    }

    this.callDefined(
      this.callSelectorMethod('onMouseDown', e.clientX, e.clientY),
      this.props.onChange
    );
  };
  onClick = e =>
    this.callDefined(
      this.callSelectorMethod('onClick', e.clientX, e.clientY),
      this.changeValueColor
    );

  onSubmit = () => {
    this.props.onSubmit(this.props.value);
  };

  callSelectorMethod = (methodName, x, y) => {
    if (this.props.disableAnnotation) {
      return;
    }

    if (this.props[methodName] !== undefined) {
      this.props[methodName](x, y);
    } else {
      const selector = this.getSelectorByType(this.props.type);
      if (selector && selector.methods[methodName]) {
        const value = selector.methods[methodName](
          this.props.value,
          this.props.relativeMousePos
        );
        return value;
      }
    }
  };

  shouldAnnotationBeActive = annotation => {
    const { top } = this.state;
    if (this.props.activeAnnotations) {
      const isActive = this.props.activeAnnotations.find(active =>
        this.props.activeAnnotationComparator(annotation, active)
      );

      return isActive !== undefined || top === annotation;
    } else {
      return (
        top &&
        top.data.id === annotation.data.id &&
        this.isSelecting() === false
      );
    }
  };

  render() {
    const { props } = this;
    const {
      relativeMousePos,
      renderHighlight,
      renderContent,
      renderSelector,
      renderEditor,
      renderOverlay,
    } = props;

    return (
      <Container style={props.style} onMouseLeave={this.onTargetMouseLeave}>
        <Img
          className={props.className}
          style={props.style}
          alt={props.alt}
          src={props.src}
          draggable={false}
          innerRef={this.setInnerRef}
        />
        <Items
          onClick={this.onClick}
          onMouseUp={this.onMouseUp}
          onMouseDown={this.onMouseDown}
          onMouseMove={this.onTargetMouseMove}
        >
          {relativeMousePos &&
            relativeMousePos.height &&
            props.annotations.map(annotation =>
              renderHighlight({
                key: annotation.data.id,
                relativeMousePos: relativeMousePos,
                annotation,
                active: this.shouldAnnotationBeActive(annotation),
                onMouseOver: () => this.setState({ top: annotation }),
                onMouseOut: () => this.setState({ top: null }),
              })
            )}
          {!props.disableSelector &&
            props.value &&
            props.value.geometry &&
            relativeMousePos &&
            relativeMousePos.height &&
            renderSelector({
              relativeMousePos,
              annotation: props.value,
              color: props.color,
              onMouseOver: noop,
              onMouseOut: noop,
            })}
        </Items>
        {!props.disableOverlay &&
          renderOverlay({
            type: props.type,
            annotation: props.value,
          })}
        {props.annotations.map(
          annotation =>
            this.shouldAnnotationBeActive(annotation) &&
            renderContent({
              key: annotation.data.id,
              annotation: annotation,
            })
        )}
        {!props.disableEditor &&
          props.value &&
          props.value.selection &&
          props.value.selection.showEditor &&
          renderEditor({
            relativeMousePos,
            annotation: props.value,
            onChange: props.onChange,
            onSubmit: this.onSubmit,
          })}
      </Container>
    );
  }
}
export default withRelativeMousePos()(Annotation);
