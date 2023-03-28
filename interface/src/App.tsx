import React, { useEffect, useState, memo } from "react";
import { BrowserRouter as Router, Route, Routes } from "react-router-dom";
import Home from "./Home";
import Navigation from "./Navigation";
function App() {
  return (
    <Router>
      <Routes>
        <Route element={<Navigation />}>
          <Route path="/apps/gol-cli/:ship/:group" element={<Home />} />
          <Route
            path="/apps/gol-cli/"
            element={
              <>Enter a space in the url example: ...apps/trove/~zod/our</>
            }
          />
        </Route>
      </Routes>
    </Router>
  );
}

export default App;
