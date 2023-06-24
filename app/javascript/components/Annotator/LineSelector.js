// LINE type stores x1,y1 in x,y and x2,y2 in width,height
export const TYPE = 'LINE';

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

      return {
        ...annotation,
        geometry: {
          ...annotation.geometry,
          x: anchorX,
          y: anchorY,
          width: newX,
          height: newY,
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
