import { useEffect, useState } from 'react'

const MATRIX = [
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
  [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
]

const CELL = 25
const PADX = 250
const PADY = 5
const WIDTH  = MATRIX[0].length * CELL + PADX * 2
const HEIGHT = MATRIX.length   * CELL + PADY * 2

export default function App() {
  const [posX, setPosX] = useState(9)  // x (columna) 1-based
  const [posY, setPosY] = useState(8)  // y (fila)    1-based

  // Polling del backend cada 500 ms
  useEffect(() => {
    let alive = true
    const interval = setInterval(() => {
      fetch('http://localhost:8000/run')
        .then(r => r.json())
        .then(data => {
          if (!alive || !data?.agents?.length) return
          const g = data.agents[0]
          setPosX(Number(g.x))
          setPosY(Number(g.y))
        })
        .catch(() => {})
    }, 500)
    return () => { alive = false; clearInterval(interval) }
  }, [])

  // Dibujo del grid + ghost
  return (
    <svg width={WIDTH} height={HEIGHT} xmlns="http://www.w3.org/2000/svg">
      {MATRIX.map((row, y) =>
        row.map((val, x) => (
          <rect
            key={`${y}-${x}`}
            x={PADX + CELL * x}
            y={PADY + CELL * y}
            width={CELL}
            height={CELL}
            fill={val === 1 ? 'lightgray' : 'gray'}
          />
        ))
      )}
      <image
        href="/ghost.png"
        x={PADX + CELL * posX + 5}
        y={PADY + CELL * posY + 1}
        width="24"
        height="24"
      />
    </svg>
  )
}