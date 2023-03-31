import React, { useEffect, useMemo } from "react";
import useMediaQuery from "@mui/material/useMediaQuery";
import { createTheme, ThemeProvider } from "@mui/material/styles";
import CssBaseline from "@mui/material/CssBaseline";
import { Main } from "./components";
import useStore from "./store";
//add tooltip to new button in header
//add feedback to note requests
//make a uuid, set it to x goal's id (a map) => pass it to the request => do x thing to x goal with the uuid using the map
function App() {
  const prefersDarkMode = useMediaQuery("(prefers-color-scheme: dark)");
  const setColorMode = useStore((store) => store.setColorMode);
  const colorMode = useStore((store) => store.colorMode);

  useEffect(() => {
    if (prefersDarkMode) {
      setColorMode("dark");
    } else {
      setColorMode("light");
    }
  }, [prefersDarkMode]);

  const theme = useMemo(
    () =>
      createTheme({
        palette: {
          mode: colorMode,
        },
      }),
    [colorMode]
  );

  return (
    <ThemeProvider theme={theme}>
      <CssBaseline />
      <Main />
    </ThemeProvider>
  );
}
export default App;
