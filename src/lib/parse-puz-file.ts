import type { Box, Crossword, Entry, Row } from "@/types/crossword";

// Helper to read null-terminated strings from a byte array
function readNullTerminatedString(
  bytes: Uint8Array,
  offset: number
): [string, number] {
  let end = offset;
  while (end < bytes.length && bytes[end] !== 0) end++;
  const str = new TextDecoder().decode(bytes.slice(offset, end));
  return [str, end + 1];
}

export async function parsePuzFile(file: File): Promise<Crossword | null> {
  const arrayBuffer = await file.arrayBuffer();
  const bytes = new Uint8Array(arrayBuffer);

  // Basic header info
  const width = bytes[0x2c];
  const height = bytes[0x2d];
  const numClues = bytes[0x2e] | (bytes[0x2f] << 8);

  // Solution grid
  const gridStart = 0x34;
  const gridEnd = gridStart + width * height;
  const solution = bytes.slice(gridStart, gridEnd);

  const gridCharacters = Array.from(solution).map((char) =>
    String.fromCharCode(char)
  );
  const gridRows: string[] = [];

  let acrossWords: string[] = [];
  for (let i = 0; i < height; i++) {
    gridRows.push(gridCharacters.slice(i * width, (i + 1) * width).join(""));
    acrossWords.push(...gridRows[i].split(".").filter(Boolean));
  }

  const grid: string[][] = gridRows.map((row) => row.split(""));

  let gridColumns: string[] = [];
  for (let c = 0; c < width; c++) {
    gridColumns.push(grid.map((row) => row[c]).join(""));
  }

  let downWords: string[] = [];
  for (let i = 0; i < width; i++) {
    downWords.push(...gridColumns[i].split(".").filter(Boolean));
  }

  // Strings section: title, author, copyright, clues, notes (all null-terminated)
  let stringOffset = gridEnd + width * height;
  const [title, afterTitle] = readNullTerminatedString(bytes, stringOffset);
  const [author, afterAuthor] = readNullTerminatedString(bytes, afterTitle);
  const [copyright, afterCopyright] = readNullTerminatedString(
    bytes,
    afterAuthor
  );

  // Clues
  let clues: string[] = [];
  let clueOffset = afterCopyright;
  for (let i = 0; i < numClues; i++) {
    const [clue, nextOffset] = readNullTerminatedString(bytes, clueOffset);
    clues.push(clue);
    clueOffset = nextOffset;
  }

  // Notes (optional)
  const [notes] = readNullTerminatedString(bytes, clueOffset);

  // Build grid
  let puzGrid: Row[] = [];
  for (let r = 0; r < height; r++) {
    let boxes: Box[] = [];
    for (let c = 0; c < width; c++) {
      const idx = r * width + c;
      const boxValue = String.fromCharCode(solution[idx]);
      const currentEntry = boxes.push({
        value: boxValue,
        column: c + 1,
        number: null, // You can add clue numbers later
      });
    }
    puzGrid.push({ index: r + 1, boxes });
  }

  // For now, clues are just strings; you can split into across/down later
  // You may want to add logic to assign clue numbers and directions

  const crossword: Crossword = {
    title,
    description: notes || null,
    rows: height,
    columns: width,
    acrossEntries: null, // TODO: parse and assign
    downEntries: null, // TODO: parse and assign
    grid: puzGrid,
  };

  return crossword;
}
