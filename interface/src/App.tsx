import React, { useEffect, useState, useMemo } from "react";
import useMediaQuery from "@mui/material/useMediaQuery";
import {
  createTheme,
  ThemeProvider,
  responsiveFontSizes,
} from "@mui/material/styles";
import CssBaseline from "@mui/material/CssBaseline";
import { Main } from "./components";
import useStore from "./store";
import { grey } from "@mui/material/colors";
import { BrowserRouter as Router, Routes, Route, Link } from "react-router-dom";
import { Details, Home } from "./pages";
import { log } from "./helpers";

//add tooltip to new button in header
//add feedback to note requests
const getDesignTokens = (mode: any) => ({
  palette: {
    mode,
    ...(mode === "light"
      ? {
          // palette values for light mode
          divider: grey[400],
          background: {
            default: "#F8F8F8",
          },
        }
      : {
          // palette values for dark
          divider: grey[800],
          background: {
            default: "#1E1E1E",
            paper: grey[900],
          },
        }),
  },
});
function App() {
  const prefersDarkMode = useMediaQuery("(prefers-color-scheme: dark)");
  const setColorMode = useStore((store) => store.setColorMode);
  const colorMode = useStore((store) => store.colorMode);

  useEffect(() => {
    //do this if no value saved for theme currently
    const selectedTheme: null | string = localStorage.getItem("theme");
    if (
      selectedTheme &&
      (selectedTheme === "light" || selectedTheme === "dark")
    ) {
      setColorMode(selectedTheme);
    } else {
      if (prefersDarkMode) {
        setColorMode("dark");
        localStorage.setItem("theme", "dark");
      } else {
        setColorMode("light");
        localStorage.setItem("theme", "light");
      }
    }
  }, [prefersDarkMode]);

  let theme = React.useMemo(
    () => createTheme(getDesignTokens(colorMode)),
    [colorMode]
  );

  theme = responsiveFontSizes(theme);
  return (
    <ThemeProvider theme={theme}>
      <CssBaseline />
      <Router>
        {/* A <Routes > looks through its children <Route>s and
        renders the first one that matches the current URL. */}
        <Routes>
          <Route path="/apps/gol-cli" element={<Home />} />
          <Route
            path="/apps/gol-cli/:type/:owner/:birth"
            element={<Details />}
          />
        </Routes>
      </Router>
    </ThemeProvider>
  );
}
export default App;
