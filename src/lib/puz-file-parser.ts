import type { Box, Crossword, Entry, Row } from "@/types/crossword";

interface Clue {
  number: number;
  text: string;
  solution: string;
  state: string;
  row: number;
  col: number;
  isAcross: boolean;
  length: number;
}

interface ClueData {
  clues: Clue[];
}
export async function parsePuzFile(file: File): Promise<Crossword | null> {
  let crossword: Crossword | null = null;
  let puzGrid: Row[] | null = [];
  let acrossEntries: Entry[] | null = [];
  let downEntries: Entry[] | null = [];
  const mod: any = await import("@confuzzle/puz-crossword");
  const PuzCrossword = mod.PuzCrossword;
  const fs = require("fs");

  const cw = await PuzCrossword.from(fs.readFileSync(file));

  const solution = cw.solution;
  if (solution) {
    const puzRows: string[] = [];
    for (let i = 0; i < solution.length; i += cw.width) {
      puzRows.push(solution.slice(i, i + cw.width));
    }

    if (cw.clues) {
      const puzClues: ClueData = JSON.parse(cw.clues);
      for (const clue of puzClues.clues) {
        const entry: Entry = {
          number: clue.number,
          row: clue.row,
          column: clue.col,
          word: clue.solution || null,
          clue: clue.text || null,
        };

        if (clue.isAcross) {
          acrossEntries.push(entry);
        } else {
          downEntries.push(entry);
        }
      }
    }

    for (const [rowIndex, row] of puzRows.entries()) {
      const rowArr: string[] = row.split("");

      const cwRow: Box[] = rowArr.map((char, colIndex) => {
        const currentRow = rowIndex + 1;
        const currentCol = colIndex + 1;

        const acrossClue = acrossEntries.find(
          (entry) => entry.row === currentRow && entry.column === currentCol
        );

        const downClue = downEntries.find(
          (entry) => entry.row === currentRow && entry.column === currentCol
        );

        const clueNumber = acrossClue?.number ?? downClue?.number ?? null;
        return {
          value: char,
          column: currentCol,
          number: clueNumber,
        };
      });

      puzGrid.push({ index: rowIndex + 1, boxes: cwRow });
    }
  }

  crossword = {
    title: cw.title || "Untitled",
    description: cw.note || null,
    rows: cw.height,
    columns: cw.width,
    acrossEntries: acrossEntries,
    downEntries: downEntries,
    grid: puzGrid,
  };

  return crossword;
}
