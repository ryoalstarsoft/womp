export const TYPE = 'POINT';

export const methods = {
  onClick(annotation, relMousePos) {
    if (annotation.geometry !== undefined) return;
    const { x, y } = relMousePos;
    return {
      ...annotation,
      selection: {
        ...annotation.selection,
        showEditor: true,
        mode: 'EDITING',
      },
      geometry: {
        ...annotation.geometry,
        x,
        y,
        width: 0,
        height: 0,
        type: TYPE,
      },
    };
  },
};

export default {
  TYPE,
  methods,
};
