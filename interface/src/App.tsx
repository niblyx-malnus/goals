import React, { useEffect, useMemo } from "react";
import useMediaQuery from "@mui/material/useMediaQuery";
import { createTheme, ThemeProvider } from "@mui/material/styles";
import CssBaseline from "@mui/material/CssBaseline";
import { Main } from "./components";
import useStore from "./store";
import { grey } from "@mui/material/colors";

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
    if (prefersDarkMode) {
      setColorMode("dark");
    } else {
      setColorMode("light");
    }
  }, [prefersDarkMode]);

  const theme = React.useMemo(
    () => createTheme(getDesignTokens(colorMode)),
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
