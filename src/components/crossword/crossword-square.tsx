import type { Box } from "@/types/crossword";

type CrosswordSquareProps = {
  box: Box;
};

export default function CrosswordSquare({ box }: CrosswordSquareProps) {
  return (
    <div className="relative size-10 border border-black bg-white flex items-center justify-center">
      <div className="absolute top-0 left-0 text-xs text-gray-500 pl-1 pt-0.5">
        {box.number}
      </div>
      <div className="text-lg">{box.value}</div>
    </div>
  );
}
