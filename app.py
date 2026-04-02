import oracledb
from flask import Flask
import ssl

app = Flask(__name__)

DB_USER     = "RICHARDTRAAD_SCHEMA_3RVCI"
DB_PASSWORD = "78PJK8LJPMAYM7YKROEE2O!0G8PhD9"
DB_DSN      = "(DESCRIPTION=(ADDRESS=(PROTOCOL=TCPS)(HOST=db.freesql.com)(PORT=1521))(CONNECT_DATA=(SERVICE_NAME=23ai_34ui2))(SECURITY=(SSL_SERVER_DN_MATCH=NO)))"

@app.route("/")
def index():
    try:
        conn = oracledb.connect(user=DB_USER, password=DB_PASSWORD, dsn=DB_DSN)
        version = conn.version
        conn.close()
        status = "Connected"
        color  = "green"
        detail = f"Oracle DB Version: {version} | Database: 23ai_34ui2 | User: {DB_USER}"
    except Exception as e:
        status = "Connection Failed"
        color  = "red"
        detail = str(e)

    return f"""
    <!DOCTYPE html>
    <html>
    <head>
        <title>Personal Training DB</title>
        <style>
            body {{ font-family: Arial, sans-serif; text-align: center; margin-top: 80px; background: #f4f4f4; }}
            .box {{ background: white; padding: 40px; border-radius: 10px; display: inline-block; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }}
            h1 {{ color: #333; }}
            .status {{ font-size: 48px; font-weight: bold; color: {color}; margin: 20px 0; }}
            .detail {{ color: #666; font-size: 14px; margin-top: 10px; }}
        </style>
    </head>
    <body>
        <div class="box">
            <h1>Personal Training Database</h1>
            <div class="status">{status}</div>
            <div class="detail">{detail}</div>
        </div>
    </body>
    </html>
    """

if __name__ == "__main__":
    app.run(debug=True)