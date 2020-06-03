/* eslint-disable react/jsx-filename-extension */
import React from 'react';
import ReactDOM from 'react-dom';
import { configureStore } from '@reduxjs/toolkit';
import { Provider } from 'react-redux';

import reducer from './EditorSlice.js';
import Editor from './Editor.jsx';

const App = () => {
  const vdom = <Editor />;
  return vdom;
};

document.addEventListener('DOMContentLoaded', () => {
  const store = configureStore({
    reducer,
  });

  ReactDOM.render(
    (
      <Provider store={store}>
        <App />
      </Provider>
    ),
    document.querySelector('.row'),
  );
});
