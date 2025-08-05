import CrosswordSquare from "./crossword-square";

type CrosswordGridProps = {
  rows: number;
  columns: number;
};

export default function CrosswordGrid({ rows, columns }: CrosswordGridProps) {
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
