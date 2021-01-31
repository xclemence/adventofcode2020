(ns day17.core2
  (:gen-class))

(require '[clojure.java.io :as io])
(require '[clojure.string :as str])
(require '[clojure.set :as set])

(defn lines [filename]
  (with-open [rdr (io/reader filename)]
    (doall (line-seq rdr))
  )
)

(defn cube-neighbors[cube]
  (def x-value (get cube 0))
  (def y-value (get cube 1))
  (def z-value (get cube 2))
  (def w-value (get cube 3))

  (doall (for [
          x (range (- x-value 1) (+ x-value 2)) 
          y (range (- y-value 1) (+ y-value 2)) 
          z (range (- z-value 1) (+ z-value 2))
          w (range (- w-value 1) (+ w-value 2))
       ] 
       [x y z w]))
)

(defn cube-to-check[cubes] 
  (set (mapcat cube-neighbors cubes))
)

(defn new-cube-state[cube, active-cubes]
  (def neighbors (set (cube-neighbors cube)))

  (def neighbors-on (count (set/intersection active-cubes neighbors)))

  (if (some #(= cube %) active-cubes)
    (or (= neighbors-on 3) (= neighbors-on 4))
    (= neighbors-on 3)
  )
)

(defn simulate[active-cubes]
  (def cube-check (cube-to-check active-cubes))

  (def result (set (filter (fn[x] (new-cube-state x active-cubes)) cube-check)))

  (println "-----------------------")
  (println (count cube-check) (count result))
  (println "-----------------------")
  result
)

(defn multi-run [active-cubes, number]
  (def result (simulate active-cubes))

  (if (= number 1)
      result
      (multi-run result (- number 1))
  )
)

(defn get-layer [cubes z w]
  (map (fn[value] [(get value 0) (get value 1)]) (filter (fn[x] (and (= (get x 2) z) (= (get x 3) w))) cubes))
)

(defn find-active-index
  ([line]   (find-active-index line 0))
  ([line, start]
    (def index (str/index-of line "#" start))
    (if (not index)
      []
      (into [index] (find-active-index line (+ index 1)))
    )
  )
)

(defn -main [& args]
  
  (def lines (lines (io/resource "data")))

  (def active (set (for [x (range (count lines)) y (find-active-index (nth lines x))] [x y 0 0])))

  (println "Start: " (new java.util.Date))
  (def run (multi-run active 6))
  (println "End: " (new java.util.Date))

)
