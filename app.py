from flask import Flask, render_template, request, redirect
import mysql.connector

from dotenv import load_dotenv
import os

load_dotenv()  # loads .env file

db = mysql.connector.connect(
    host=os.getenv("DB_HOST"),
    user=os.getenv("DB_USER"),
    password=os.getenv("DB_PASSWORD"),
    database=os.getenv("DB_NAME"),
)
cursor = db.cursor()


app = Flask(__name__)

@app.route('/')
def home():
    return render_template("index.html")

@app.route('/add', methods=['POST'])
def add_student():
    name = request.form['name']
    rollno = request.form['rollno']

    cursor.execute("INSERT INTO students (name, rollno) VALUES (%s, %s)", (name, rollno))
    db.commit()

    return redirect('/students')

@app.route('/students')
def students():
    cursor.execute("SELECT name, rollno FROM students")
    data = cursor.fetchall()
    return render_template("students.html", students=data)

if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=5000)
