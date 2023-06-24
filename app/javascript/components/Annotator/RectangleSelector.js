export const TYPE = 'RECTANGLE';

export const methods = {
  onMouseDown(annotation, relMousePos) {
    if (annotation.selection !== undefined) return;
    if (!annotation.selection) {
      const { x: anchorX, y: anchorY } = relMousePos;

      return {
        ...annotation,
        selection: {
          ...annotation.selection,
          mode: 'SELECTING',
          anchorX,
          anchorY,
        },
      };
    }
  },

  onMouseUp(annotation) {
    if (annotation.selection) {
      const { selection, geometry } = annotation;

      if (geometry === undefined) return;

      switch (annotation.selection.mode) {
        case 'SELECTING':
          return {
            ...annotation,
            selection: {
              ...selection,
              showEditor: true,
              mode: 'EDITING',
            },
          };
        default:
          break;
      }
    }

    return annotation;
  },

  onMouseMove(annotation, relMousePos) {
    if (annotation.selection && annotation.selection.mode === 'SELECTING') {
      const { anchorX, anchorY } = annotation.selection;
      const { x: newX, y: newY } = relMousePos;
      const width = newX - anchorX;
      const height = newY - anchorY;

      return {
        ...annotation,
        geometry: {
          ...annotation.geometry,
          x: width > 0 ? anchorX : newX,
          y: height > 0 ? anchorY : newY,
          width: Math.abs(width),
          height: Math.abs(height),
        },
      };
    }

    return annotation;
  },
};

export default {
  TYPE,
  methods,
};
