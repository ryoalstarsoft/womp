import React, { PureComponent as Component } from 'react';

const withRelativeMousePos = (
  key = 'relativeMousePos'
) => DecoratedComponent => {
  class WithRelativeMousePos extends Component {
    state = { x: null, y: null, height: null, height: null };

    innerRef = el => {
      if (el === undefined) return;
      this.container = el;
      this.container.addEventListener('load', this.onLoad);
    };

    onLoad = () => {
      this.setState({
        height: this.container.height,
        width: this.container.width,
      });
    };

    onMouseMove = (x, y) => {
      if (this.container === undefined) return;
      const rect = this.container.getBoundingClientRect();
      this.setState({
        x: ((x - rect.left) / this.container.width) * 100,
        y: ((y - rect.top) / this.container.height) * 100,
        height: this.container.height,
        width: this.container.width,
      });
    };

    onMouseLeave = e => {
      this.setState({ x: null, y: null });
    };

    render() {
      const hocProps = {
        [key]: {
          innerRef: this.innerRef,
          onMouseMove: this.onMouseMove,
          onMouseLeave: this.onMouseLeave,
          x: this.state.x,
          y: this.state.y,
          width: this.state.width,
          height: this.state.height,
        },
      };

      return <DecoratedComponent {...this.props} {...hocProps} />;
    }
  }

  WithRelativeMousePos.displayName = `withRelativeMousePos(${
    DecoratedComponent.name
  })`;

  return WithRelativeMousePos;
};

export default withRelativeMousePos;
