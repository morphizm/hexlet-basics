import React from 'react';
import MonacoEditor from 'react-monaco-editor';

const Editor = props => {
  const vdom = (
    <MonacoEditor
      width="800"
      height="600"
      language="javascript"
    />
  );
  return vdom;
};

export default Editor;
