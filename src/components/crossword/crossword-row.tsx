import { useCrossword } from "./crossword-provider";
import CrosswordSquare from "./crossword-square";

interface CrosswordRowProps {
  index?: number;
}

export default function CrosswordRow({ index }: CrosswordRowProps) {
  const { crossword } = useCrossword();
  const { grid } = crossword;
  const row = typeof index === "number" && grid ? grid[index] : undefined;
  const { boxes } = row || {};

  if (row && boxes) {
    return (
      <>
        {boxes.map((box) => (
          <CrosswordSquare key={`box-${row.index}-${box.column}`} box={box} />
        ))}
      </>
    );
  }
}
