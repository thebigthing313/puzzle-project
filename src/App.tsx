import "./App.css";
import CrosswordGrid from "./components/crossword/crossword-grid";
import {
  CrosswordProvider,
  useCrossword,
} from "./components/crossword/crossword-provider";

function App() {
  const { crossword } = useCrossword();
  return (
    <CrosswordProvider>
      <CrosswordGrid rows={crossword.rows} columns={crossword.columns} />
    </CrosswordProvider>
  );
}

export default App;
