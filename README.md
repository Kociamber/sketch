# Sketch

Client-server system representing an ASCII art drawing canvas. It implements:

*   JSON based RESTful endpoint.
*   Two canvas operations - rectangle drawing and flood-fill.
*   DETS based canvas persistence mechanism (no DB needed!)
*   Phenix LiveView based client (read only)

## Install and run locally
  * Clone repo with `git clone https://github.com/Kociamber/sketch.git`.
  * Perform the required application setup with `mix setup`.
  * Start the endpoint with `mix run` or `iex -S mix phx.server` (with interactive console).

## Usage

To access LiveView based client visit [`localhost:4000`](http://localhost:4000) from your browser.    

After the setup your local storage is empty - you can quickly create (an assignement test fixture based) canvas you can run the seedfile with `mix seed`.  

To "clear" your storage simply delete `sketch_storage` file from the project's root directory.

Browser's routes:
```
    /      - shows all locally storred canvases
    /:id   - shows a specific canvas
```

JSON endpoint requests routes:
* `post` `/canvas`: creates, persists and returns empty canvas, no body params required
* `get` `/canvas`: returns a list of currently stored canvases
* `get` `/canvas/:id`: returns canvas by id, no body params required
* `put` `/canvas/:id`: performs flood or rectangle draw operation, returns "updated" canvas (requred body params below)
* `delete` `/canvas/:id` - removes canvas and returns deleted structure, no body params required

required `put` params:
* x: integer
* y: integer
