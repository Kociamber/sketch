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
    /      - shows all locally stored canvases
    /:id   - shows a specific canvas
```

JSON endpoint requests routes:
* `post` `/canvas`: creates, persists and returns empty canvas, no body params required
* `get` `/canvas`: returns a list of currently stored canvases
* `get` `/canvas/:id`: returns canvas by id, no body params required
* `put` `/canvas/:id`: performs flood or rectangle draw operation, returns "updated" canvas (requred body params below)
* `delete` `/canvas/:id` - removes canvas and returns deleted structure, no body params required

Bodyparams required for `put` (canvas drawing operation) - drawing rectangle:

```json
{"operation":"rectangle","x":7, "y":10,"width":40,"height":15,"fill_char":"#", "outline_char":"+"}
```
* all params are mandatory (besides `fill_char` and `outline_char` - only one of them must be present)
* all numeric values must be integers greater than or equal 0
* `fill_char` and `outline_char` can be only strings of length 1

Bodyparams required for `put` (canvas drawing operation) - performing flood operation:
```json
{"operation":"flood","x":3, "y":3,"fill_char":"7"}
```
* all params are mandatory
* all numeric values must be integers greater than or equal 0
* `fill_char` can be only a strings of length 1

### Sample API calls
Get a list of all stored canvases:  
```bash
curl -H "Content-Type: application/json" -X GET http://localhost:4000/api/canvas/
```
Create new canvas:
```bash
curl -H "Content-Type: application/json" -X POST http://localhost:4000/api/canvas/
```
Get canvas by id:
```bash
curl -H "Content-Type: application/json" -X GET http://localhost:4000/api/canvas/:canvas_id
```
Perform rectangle drawing operation:
```bash
curl -H "Content-Type: application/json" -X PUT -d '{"operation":"rectangle","x":1, "y":2,"width":5,"height":5,"fill_char":"#"}' http://localhost:4000/api/canvas/:canvas_id
```
Perform fill-flood operation:
```bash
curl -H "Content-Type: application/json" -X PUT -d '{"operation":"flood","x":3, "y":2,"fill_char":"^"}' http://localhost:4000/api/canvas/:canvas_id
```
Remove canvas from the storage:
```bash
curl -H "Content-Type: application/json" -X DELETE http://localhost:4000/api/canvas/:canvas_id
```
### Return JSON structure
All operations are returning a canvas of following structure:
```json
{"canvas":{"content":{"0":{"0":"-","1":"-","2":"-","3":"-","4"},...,"id":"ee25fbec-2767-11eb-8a6f-784f436f155b"}}}
```
