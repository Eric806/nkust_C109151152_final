import sqlite3, hashlib

def _main():
    _create()

def _encode(text):
    s = hashlib.sha256()
    s.update(text.encode())
    return s.hexdigest()

def _create():
    import os
    if os.path.isfile('bmi.db'):
        os.remove('bmi.db')
    conn = sqlite3.connect('bmi.db')
    try:
        sql = """create table user(
                user_id integer,
                name text,
                password text,
                primary key(user_id autoincrement))"""
        conn.execute(sql)
        sql = """create table data(
                user_id integer,
                height real,
                weight real,
                time text,
                foreign key(user_id) references user(user_id))"""
        conn.execute(sql)
        print('資料庫建立完成')
        conn.close()
    except sqlite3.OperationalError:
        print("資料庫建立失敗")
        conn.close()
        if os.path.isfile('bmi.db'):
            os.remove('bmi.db')

def register(name, password):
    conn = sqlite3.connect('bmi.db')
    sql = f'select * from user where name="{name}"'
    exist = conn.execute(sql).fetchone() != None
    if not exist:
        password = _encode(password)
        sql = f"insert into user(name, password) values (?, ?)"
        conn.execute(sql, (name, password))
        conn.commit()
        userid = conn.execute("select last_insert_rowid()").fetchone()[0]
    else:
        userid = -1     #帳號已存在
    conn.close()
    return userid

def login(name, password):
    conn = sqlite3.connect('bmi.db')
    password = _encode(password)
    sql = f'select user_id from user where name = "{name}" and password = "{password}"'
    user = conn.execute(sql).fetchone()
    conn.close()
    return -1 if user == None else user[0]

def getData(user_id):
    conn = sqlite3.connect('bmi.db')
    sql = f'select height, weight, time from data where user_id = {user_id}'
    data = conn.execute(sql).fetchall()
    conn.close()
    return data

def insertData(user_id, height, weight, time):
    conn = sqlite3.connect('bmi.db')
    sql = f'insert into data values (?,?,?,?)'
    conn.execute(sql, (user_id, height, weight, time))
    conn.commit()
    conn.close()

def delData(user_id, time):
    conn = sqlite3.connect('bmi.db')
    sql = f'delete from data where user_id = {user_id} and time = "{time}"'
    conn.execute(sql)
    conn.commit()
    conn.close()

if __name__ == '__main__':
    _main()
