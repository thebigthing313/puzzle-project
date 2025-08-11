import { useCrossword } from "./crossword-provider";
import CrosswordRow from "./crossword-row";

export default function CrosswordGrid() {
  const { crossword } = useCrossword();
  const { grid } = crossword;

  if (grid) {
    return (
      <div className="size-fit border border-black">
        {grid.map((row) => (
          <CrosswordRow index={row.index} key={`row-${row.index}`} />
        ))}
      </div>
    );
  }
}
