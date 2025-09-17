from flask import Flask
app = Flask(__name__)
@app.get("/")
def hi(): return {"ok": True}
app.run(host="0.0.0.0", port=5000)