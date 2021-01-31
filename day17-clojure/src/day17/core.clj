(ns day17.core
  (:gen-class))

(require '[clojure.java.io :as io])
(require '[clojure.string :as str])

(defn lines [filename]
  (with-open [rdr (io/reader filename)]
    (doall (line-seq rdr))
  )
)

(defn get-layer [values, base]

  (def layer-size (count (first (first values))))
  (def middle (quot layer-size 2))

  (map (fn[x] (map (fn[y] (nth y (+ middle base))) x))  values)
)

(defn print-layer [values]
  (doall (map println values))
)

(defn active? [values]
  (not= (str (second (second (second values)))) ".")
)

(defn neighbors-on [values]

  (def all-on (count (filter (fn[x] (not= (str x) ".")) (flatten values))))

  (if (active? values)
    (if (or (= all-on 3) (= all-on 4)) "#" ".")
    (if (= all-on 3) "#" ".")
  )
)

(defn simulate-z [values]

  (if (= (count (first (first values))) 2)
    []
    (concat [(neighbors-on (into [] (map (fn[x] (map (fn[z] (take 3 z)) x) ) values)))]
            (simulate-z    (into [] (map (fn[x] (map (fn[z] (drop 1 z)) x) ) values)))
    )
  )
)

(defn simulate-y [values]
  (if (= (count (first values)) 2)
    []
    (cons (simulate-z (into [] (map (fn[x] (take 3 x)) values)))
          (simulate-y (into [] (map (fn[x] (drop 1 x)) values)))
    )
  )
)

(defn simulate [values]
  (if (= (count values) 2)
    []
    (cons (simulate-y (take 3 values))
          (simulate (drop 1 values))
    )
  )
)

(defn add-dimension [values]
  (def line-size (count (first values)))
  (def y-size (count (first (first values))))

  (def border-y (repeat (+ y-size 4) "."))
  (def border-x (repeat (+ line-size 4) border-y))

  (concat 
          (repeat 2 border-x)
          (map (fn[x] (concat (repeat 2 border-y) (map (fn[y] (concat ["."] ["."] y ["."] ["."])) x) (repeat 2 border-y))) values)
          (repeat 2 border-x)
  )
)

(defn multi-run [values, number]
  (def result (simulate (add-dimension values)))

  (if (= number 1)
      result
      (multi-run result (- number 1))
  )
)

(defn -main [& args]
  
  (def lines (lines (io/resource "data")))

  (def values (map 
                  (fn[x] (map (fn[y] (vec y)) (str/split x #""))) 
                  lines
              )
  )

  (print-layer values)

  (def result (multi-run values 6))

  (def end-result (count (filter (fn[x] (= (str x) "#")) (flatten result))))

  (println "Result" end-result)
  (print-layer (get-layer result 0))
)
