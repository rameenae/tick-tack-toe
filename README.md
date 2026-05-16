# tick-tack-toe
A two-player Tic Tac Toe game built in x86 Assembly using direct memory and register management. No libraries. Pure low-level logic.
# Tic Tac Toe — x86 Assembly 🎮

A fully functional Tic Tac Toe game built entirely in **x86 Assembly (MASM/DOS)**  
No high-level languages. No libraries. Pure registers, memory, and logic.

---

## 🕹️ Game Modes

- **Player vs Player** — Two humans, one keyboard, one winner
- **Player vs CPU** — Face a CPU opponent that picks random available moves

---

## ✨ Features

- Mode selection screen at startup (PvP or PvC)
- Live board rendering after every move
- Turn indicator showing whose move it is (X or O)
- Input validation — rejects out-of-range and already-taken cells
- Win detection — checks all rows, columns, and both diagonals
- Draw detection — triggers when all 9 cells are filled with no winner
- CPU uses timer-based random move selection (`int 1Ah`)
- Clean screen between turns using BIOS interrupt (`int 10h`)

---

## 🛠️ Built With

| Tool | Purpose |
|---|---|
| x86 Assembly (MASM syntax) | Core language |
| `.model small` + `.stack` | DOS memory model |
| `int 21h` | DOS I/O system calls |
| `int 10h` | BIOS screen clear |
| `int 1Ah` | Timer for CPU randomness |
| DOSBox / TASM / MASM | Assembler & emulator |

---

## 📁 Project Structure
tic-tac-toe-x86/
│
├── tictactoe.asm       # Full source code (single file)
└── README.md           # You're reading it


---

## ▶️ How to Run

### Option 1 — DOSBox (Recommended)
1. Install [DOSBox](https://www.dosbox.com/)
2. Install MASM or TASM
3. Mount your project folder:
4. Assemble & link:
### Option 2 — TASM

---

## 🎮 How to Play
Select Mode:

Player vs Player
Player vs CPU


Enter `1` or `2` to choose your mode, then use number keys to place your mark:
| 1 | 2 | 3 |
| 4 | 5 | 6 |
| 7 | 8 | 9 |

Players alternate. First to align 3 wins. Fill all 9 with no winner = Draw.

---

## 💡 Key Concepts Demonstrated

| Concept | Where in Code |
|---|---|
| Direct memory addressing | `board_state` array, `[board_state+bx]` |
| Register-based game logic | `player_turn`, `win_flag`, `game_mode` |
| Conditional jumps | `cmp` + `je/jne/jl/jg` throughout |
| DOS system calls | `int 21h` for I/O, `int 10h` for screen |
| Loop constructs | `row_loop`, `col_loop`, `draw_loop` |
| Randomness via timer | `int 1Ah` in `cpu_move` |
| Modular procedures | `check_win`, `check_draw`, `update_board`, `build_game_draw` |

---

## 🔍 How Win Detection Works
Rows:      [0,1,2]  [3,4,5]  [6,7,8]
Columns:   [0,3,6]  [1,4,7]  [2,5,8]
Diagonals: [0,4,8]  [2,4,6]
Each check compares the character at each position — if all 3 match 
and aren't blank (space = ASCII 32), `win_flag` is set to `1`.

---

## ⚠️ Known Limitations

- CPU plays randomly — no minimax or AI strategy
- Runs in 16-bit DOS environment (requires DOSBox on modern systems)
- Single file, no external dependencies

---

## 📚 What This Project Taught Me

- Translating game logic into pure conditional jumps and memory operations
- Managing state (whose turn, win/draw) entirely through byte-level flags
- Debugging at the register level — one wrong offset breaks everything
- Understanding exactly what happens beneath every `if` statement in C++

---

## 🙋‍♀️ Author

**Rameen Ahmad**  
BS Computer Science — Lahore Garrison University  
[LinkedIn]( https://www.linkedin.com/in/rameen-ahmad-79b058373)

---

⭐ Star this repo if you appreciate low-level programming!
