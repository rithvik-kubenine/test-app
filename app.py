import os

from flask import Flask, jsonify

app = Flask(__name__)


@app.get("/")
def health():
    return jsonify(
        {
            "message": "Hello from Flask",
            "status": "ok",
            "service": "task-349",
        }
    )


@app.get("/ping")
def ping():
    return "pong", 200


if __name__ == "__main__":
    app.run(
        host="0.0.0.0",
        port=int(os.environ.get("PORT", "5000")),
        debug=os.environ.get("FLASK_DEBUG", "").lower() in ("1", "true", "yes"),
    )
