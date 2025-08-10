import { useCrossword } from "./crossword-provider";
import CrosswordSquare from "./crossword-square";

export default function CrosswordGrid() {
  const { crossword } = useCrossword();
  const { rows, columns, grid } = crossword;

  return (
    <div className="size-fit border border-black">
      {Array.from({ length: rows }).map((_, rowIndex) => (
        <div key={rowIndex} className="flex">
          {Array.from({ length: columns }).map((_, colIndex) => (
            <CrosswordSquare key={colIndex} />
          ))}
        </div>
      ))}
    </div>
  );
}
