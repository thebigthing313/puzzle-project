import type { Crossword } from "@/types/crossword";
import { useState, createContext, useContext, type ReactNode } from "react";

const defaultCrossword: Crossword = {
  rows: 15,
  columns: 15,
  title: "Default Crossword",
  description: "Test Crossword for Development",
  acrossEntries: null,
  downEntries: null,
  grid: null,
};

type CrosswordContextType = {
  crossword: Crossword;
  setCrossword: React.Dispatch<React.SetStateAction<Crossword>>;
};

const CrosswordContext = createContext<CrosswordContextType | undefined>(
  undefined
);

export function useCrossword() {
  const context = useContext(CrosswordContext);
  if (!context) {
    throw new Error("useCrossword must be used within a CrosswordProvider");
  }
  return context;
}

type Props = {
  children: ReactNode;
};

export function CrosswordProvider({ children }: Props) {
  const [crossword, setCrossword] = useState<Crossword>(defaultCrossword);

  return (
    <CrosswordContext.Provider value={{ crossword, setCrossword }}>
      {children}
    </CrosswordContext.Provider>
  );
}
