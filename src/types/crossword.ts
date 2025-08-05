export type Box = {
  coordinates: [number, number];
  value: string | null;
  number: number | null;
};

export type Entry = {
  number: number;
  direction: "across" | "down";
  word: string | null;
  clue: string | null;
};

export type Crossword = {
  rows: number;
  columns: number;
  grid: Box[][];
};
