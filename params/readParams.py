import json
import sys


dbname = sys.argv[1]

#dbname = "wplv"
db_params = {}

with open('/switch2osm/params/productlist.json') as json_file:
    data = json.load(json_file)
    for p in data['geoproduct']:
        if dbname == p['Zugriff']['productname']:
            #print('Name:' + p['name'])
            #print('Institution:' + p['Herausgeber']['institution'])
            #print('veroeffentlicht:' + p['Herausgeber']['veroeffentlicht'])
            #print('name:' + p['Ansprechpartner']['name'])
            #print('adresse:' + p['Ansprechpartner']['adresse'])
            #print('location:' + p['Ansprechpartner']['location'])
            #print('mobil:' + p['Ansprechpartner']['mobil'])
            #print('Mail:' + p['Mail'][0])

            db_params = {
                "user":         p['Zugriff']['user'],
                "version":      p['Zugriff']['version'],
                "port":         p['Zugriff']['port'],
                "hostname":     p['Zugriff']['hostname'],
                "tablespace":   p['Zugriff']['tablespace'],
                "productname":  p['Zugriff']['productname']
            }

            print(json.dumps(db_params))

        if dbname == '':
            print(p['Zugriff']['productname'])
