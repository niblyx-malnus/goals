import * as React from "react";
import useMediaQuery from "@mui/material/useMediaQuery";
import { createTheme, ThemeProvider } from "@mui/material/styles";
import CssBaseline from "@mui/material/CssBaseline";
import { Main } from "./components";
import useStore from "./store";

function App() {
  const prefersDarkMode = useMediaQuery("(prefers-color-scheme: dark)");
  const setColorMode = useStore((store) => store.setColorMode);
  const colorMode = useStore((store) => store.colorMode);

  React.useEffect(() => {
    if (prefersDarkMode) {
      setColorMode("dark");
    } else {
      setColorMode("light");
    }
  }, [prefersDarkMode]);

  const theme = React.useMemo(
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
