let g = mkGraph [(0,Word "a"),(1,Word "b"),(2,Tplt ["","is",""]),(3,Rel),(4,Word "c"),(5,Rel),(6,Word "d"),(7,Rel),(8,Word "e"),(9,Word "f"),(10,Rel)] [(3,0,RelEdge (Mbr 1)),(3,1,RelEdge (Mbr 2)),(3,2,RelEdge TpltRole),(5,0,RelEdge (Mbr 1)),(5,2,RelEdge TpltRole),(5,4,RelEdge (Mbr 2)),(7,1,RelEdge (Mbr 1)),(7,2,RelEdge TpltRole),(7,6,RelEdge (Mbr 2)),(10,2,RelEdge TpltRole),(10,8,RelEdge (Mbr 1)),(10,9,RelEdge (Mbr 2))]

let upDown = M.fromList [(TpltRole, NodeSpecVerboseTypes 2), (Mbr 1, VarSpecVerboseTypes Up), (Mbr 2, VarSpecVerboseTypes Down) ]
let downUp = M.fromList [(TpltRole, NodeSpecVerboseTypes 2), (Mbr 1, VarSpecVerboseTypes Down), (Mbr 2, VarSpecVerboseTypes Up) ]

dwtDfsVerboseTypes g (Up, upDown) [0]
dwtDfsVerboseTypes g (Up, downUp) [0]
dwtDfsVerboseTypes g (Down, upDown) [0]
dwtDfsVerboseTypes g (Down, downUp) [0]

dwtBfsVerboseTypes g (Up, upDown) [0]
dwtBfsVerboseTypes g (Up, downUp) [0]
dwtBfsVerboseTypes g (Down, upDown) [0]
dwtBfsVerboseTypes g (Down, downUp) [0]
