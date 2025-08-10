export type Box = {
  column: number;
  value: string | null;
  number: number | null;
};

export type Row = {
  index: number;
  boxes: Box[];
};

export type Entry = {
  number: number;
  word: string | null;
  clue: string | null;
};

export type Crossword = {
  title: string;
  description: string | null;
  rows: number;
  columns: number;
  acrossEntries: Entry[] | null;
  downEntries: Entry[] | null;
  grid: Row[] | null;
};
