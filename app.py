from flask import Flask, jsonify

app = Flask(__name__)


@app.get("/")
def health():
    return jsonify({"message": "Hello from Flask", "status": "ok"})


@app.get("/ping")
def ping():
    return "pong", 200


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
