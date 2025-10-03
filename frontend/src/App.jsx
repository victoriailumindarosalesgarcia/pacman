import { useEffect, useState } from "react";

const matrix = [
  [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
  [0,1,1,1,1,1,1,1,0,1,1,1,1,1,1,1,0],
  [0,1,0,1,0,0,0,1,1,1,0,1,0,1,0,1,0],
  [0,1,1,1,0,1,0,0,0,0,0,1,0,1,1,1,0],
  [0,1,0,0,0,1,1,1,1,1,1,1,0,0,0,1,0],
  [0,1,0,1,0,1,0,0,0,0,0,1,1,1,0,1,0],
  [0,1,1,1,0,1,0,1,1,1,0,1,0,1,0,1,0],
  [0,1,0,1,0,1,0,1,1,1,0,1,0,1,0,1,0],
  [0,1,0,1,1,1,0,0,1,0,0,1,0,1,1,1,0],
  [0,1,0,0,0,1,1,1,1,1,1,1,0,0,0,1,0],
  [0,1,1,1,0,1,0,0,0,0,0,1,0,1,1,1,0],
  [0,1,0,1,0,1,0,1,1,1,0,0,0,1,0,1,0],
  [0,1,1,1,1,1,1,1,0,1,1,1,1,1,1,1,0],
  [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
];

export default function App() {
  const [posX, setPosX] = useState(2);
  const [posY, setPosY] = useState(2);

  useEffect(() => {
    const id = setInterval(() => {
      fetch("http://localhost:8000/run")
        .then(r => r.json())
        .then(r => {
          const [x, y] = r.agents[0].pos;
          setPosX(x);
          setPosY(y);
        })
        .catch(console.error);
    }, 1000);
    return () => clearInterval(id);
  }, []);

  const cell = 25;
  const offsetX = 250, offsetY = 5;

  return (
    <div>
      <svg
        width={offsetX + cell * matrix[0].length + 50}
        height={offsetY + cell * matrix.length + 50}
        xmlns="http://www.w3.org/2000/svg"
        style={{ backgroundColor: "lightgray" }}
      >
        {matrix.map((row, rowidx) =>
          row.map((value, colidx) => (
            <rect
              key={`${rowidx}-${colidx}`}
              x={offsetX + cell * colidx}
              y={offsetY + cell * rowidx}
              width={cell}
              height={cell}
              fill={value === 1 ? "#d9d9d9" : "#808080"}
            />
          ))
        )}
        <image
          x={offsetX + cell * (posX - 1) + 5}
          y={offsetY + cell * (posY - 1) + 5}
          width={cell - 10}
          height={cell - 10}
          href="/ghost.png"
        />
      </svg>
    </div>
  );
}
