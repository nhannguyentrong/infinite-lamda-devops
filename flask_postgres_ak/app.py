from flask import Flask,render_template
import psycopg2, boto3, json,os
app = Flask(__name__)
@app.route('/')
def index():
    try: 
        ssm = boto3.client('ssm')
        parameter = ssm.get_parameter(
            Name= os.environ["SSM_PARAMTER_POSTGRESS"],
            WithDecryption=True
        )
        database_info = json.loads(parameter['Parameter']['Value'])

        conn = psycopg2.connect(database=database_info['db_name'],
                                user=database_info['db_username'],
                                password=database_info['db_password'],
                                host=database_info['db_address'],
                                port = database_info['db_port'])
        print(conn.get_dsn_parameters())
        return render_template("index.html", data = conn.get_dsn_parameters(), rds_version= conn.get_parameter_status("server_version"))
    except:
        return render_template("index.html", error="true")

if __name__ == '__main__': 
    app.run(threaded=True,host='0.0.0.0',port=8081)