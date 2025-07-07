package main

import (
    "fmt"
    "log"
    "net/http"
    "os"
)

func handler(w http.ResponseWriter, r *http.Request) {
    fmt.Fprintf(w, "Hello from Go App! 🚀")
}

func main() {
    http.HandleFunc("/", handler)

    port := os.Getenv("PORT")
    if port == "" {
        port = "8082" // fallback port if not set
    }

    log.Printf("Starting server on :%s\n", port)
    log.Fatal(http.ListenAndServe(":"+port, nil))
}
