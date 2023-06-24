import React, { Component } from 'react';
import Annotation from './Annotation';
import annotationProps from './annotationProps';

import Point from './Point';
import Editor from './Editor';

import ColorPicker from './ColorPicker';

export default class Annotator extends Component {
  state = {
    type: Point.TYPE,
    annotations: [],
    annotation: {},
    activeAnnotations: null,
    saved: true,
    color: '#FFFFFF',
    readOnly: false,
    href: window.location.pathname.indexOf("admin") === 1 ? '/admin/projects/' : (window.location.pathname.indexOf("modelers") === 1 ? '/modelers/' : '/projects/'),
    postHref: window.location.pathname.indexOf("admin") === 1 ? '/admin/uploads/' : '/uploads/'
  };

  componentWillMount = () => {
    let formattedExistingAnnotations = this.props.existingAnnotations.map(
      function(annotation) {
        return {
          id: annotation.id,
          geometry: {
            x: parseFloat(annotation.geometry.x),
            y: parseFloat(annotation.geometry.y),
            width: parseFloat(annotation.geometry.width),
            height: parseFloat(annotation.geometry.height),
            type: annotation.geometry.type,
          },
          data: {
            id: annotation.data.id,
            text: annotation.data.text,
            color: annotation.data.color,
          },
        };
      }
    );

    this.setState({
      annotations: formattedExistingAnnotations,
      readOnly: this.props.readOnly
    });
  };

  // Sidebar Functions
  onMouseOver = annotation => e => {
    this.setState({
      annotation: this.state.annotation,
      activeAnnotations: [annotation.data.id],
    });
  };

  onMouseOut = annotation => e => {
    this.setState({
      annotation: this.state.annotation,
      activeAnnotations: null,
    });
  };

  activeAnnotationComparator = (a, b) => a.data.id === b;

  activateAnnotation = annotation => {
    this.setState({
      annotation: {
        selection: {
          showEditor: true,
          mode: 'EDITING',
        },
        id: annotation.id,
        geometry: annotation.geometry,
        data: annotation.data,
      },
    });
  };

  onChange = annotation => this.setState({ annotation });
  onSubmit = annotation => {
    const { geometry, data } = annotation;
    let { id } = annotation;
    if (id === undefined) {
      id = Math.random();
    }

    var annotationObject = { id, geometry, data: { ...data, id } };
    var newAnnotations = this.state.annotations;
    var index = newAnnotations.findIndex(annotation => annotation.id === id);
    if (newAnnotations[index]) {
      newAnnotations[index] = annotationObject;
    } else {
      newAnnotations.push(annotationObject);
    }

    this.setState({
      saved: false,
      annotation: {},
      annotations: newAnnotations,
    });
  };

  onCancel = annotation => {
    this.setState({
      annotation: {},
    });
  };

  onDelete = annotation => {
    const newAnnotations = this.state.annotations.filter(
      a => a.id !== annotation.id
    );

    this.setState({
      saved: false,
      annotation: {},
      annotations: newAnnotations,
    });
  };

  submitToServer = () => {
    let postAnnotations = this.state.annotations;
    let _this = this;

    fetch(`${this.state.postHref}${this.props.uploadId}/update_annotations`, {
      method: 'POST',
      headers: {
        Accept: 'application/json',
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(postAnnotations),
    }).then(function(response) {
      // redirection happens on this endpoint
      if (response.status === 200 || response.status === 204) {
        _this.setState({
          saved: true,
        });

        window.location.href = _this.state.href + (parseInt(_this.props.projectId) + 100000);
      }
    });
  };

  renderEditor = props => {
    const { geometry } = props.annotation;
    if (!geometry) return null;

    return (
      <Editor
        annotation={props.annotation}
        onChange={props.onChange}
        onSubmit={props.onSubmit}
        onCancel={this.onCancel}
        onDelete={this.onDelete}
      />
    );
  };

  setTool = tool => this.setState({ type: tool.TYPE });

  render() {
    return (
      <div>
        <div className="fl w-80 pr2 cf">
          <div className="fl w-10 pa1 cf">
          </div>

          <div className="fl w-90 cf">
            <div className="pa3">
              <ColorPicker
                color={this.state.color}
                onChangeComplete={({ hex }) =>
                  this.setState({ color: hex })
                }
              />
            </div>
          </div>
        </div>

        <div className="fl w-20 pl2 cf">
        </div>

        <div className="fl w-80 pr2">
          <div className="fl w-10 cf">
            {annotationProps.types.map((type, index) => (
              <div className="fl w-100 mb3" key={index}>
                <a
                  key={index}
                  className={`center button-small ${
                    type.icon
                  } pointer ml1 square ${
                    this.state.type === type.TYPE ? 'active' : ''
                  }`}
                  title={`${type.title} Tool`}
                  onClick={e => this.setTool(type)}
                />
              </div>
            ))}
          </div>

          <div className="fl w-90 cf">
            <Annotation
              src={this.props.imageUrl}
              alt={this.props.imageAltText}
              annotations={this.state.annotations}
              activeAnnotationComparator={this.activeAnnotationComparator}
              activeAnnotations={this.state.activeAnnotations}
              color={this.state.color}
              type={this.state.type}
              value={this.state.annotation}
              onChange={this.onChange}
              onSubmit={this.onSubmit}
              renderEditor={this.renderEditor}
            />
          </div>
        </div>

        <div className="fl w-20 pl2">
          {/* Toolbar */}
          <div className="relative">
            {this.state.annotations.length > 0 && (
              <ul className="mv0 pl0 tc list">
                {this.state.annotations.map(annotation => {
                  return (
                    <li
                      className="mv2 sidebar-annotation"
                      onMouseOver={this.onMouseOver(annotation)}
                      onMouseOut={this.onMouseOut(annotation)}
                      key={annotation.data.id}
                    >
                      <span>{annotation.data.text}</span>
                      <span
                        className="pl2"
                        onClick={() => {
                          this.activateAnnotation(annotation);
                        }}
                      >
                        <i className="far fa-edit pointer" aria-hidden="true" />
                      </span>
                    </li>
                  );
                })}
              </ul>
            )}

            {this.state.annotations.length === 0 && (
              <p className="tc">
                click anywhere to begin annotating your image
              </p>
            )}

            {!this.state.readOnly && !this.state.saved && (
              <div className="tc">
                <p
                  className="mt2 button primary-button"
                  onClick={this.submitToServer}
                >
                  save changes
                </p>
                <p className="mt2">
                  <a
                    className="button secondary-button"
                    data-confirm="are you sure? you have unsaved changes."
                    href={this.state.href + (parseInt(this.props.projectId) + 100000)}
                  >
                    cancel
                  </a>
                </p>
              </div>
            )}
            {this.state.readOnly && (
              <p className="tc mt2">
                you are unable to save the changes to this images annotations, it is read only<br/>
                <a
                  className="button secondary-button mt2"
                  href={this.state.href + (parseInt(this.props.projectId) + 100000)}
                >
                  cancel
                </a>
              </p>
            )}
            {!this.state.readOnly && this.state.saved && (
              <p className="tc mt2">
                <a
                  className="button secondary-button"
                  href={this.state.href + (parseInt(this.props.projectId) + 100000)}
                >
                  cancel
                </a>
              </p>
            )}
          </div>
        </div>
      </div>
    );
  }
}
