import "./App.css";
import CrosswordGrid from "./components/crossword/crossword-grid";
import { CrosswordProvider } from "./components/crossword/crossword-provider";

function App() {
  return (
    <CrosswordProvider>
      <CrosswordGrid />
    </CrosswordProvider>
  );
}

export default App;
