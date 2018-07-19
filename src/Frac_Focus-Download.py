import requests, zipfile, io


URL = r"http://fracfocusdata.org/digitaldownload/fracfocuscsv.zip"

OUTPATH = r"C:\Repositories\DDS_Case_Study_2\data"

r = requests.get(URL)
z = zipfile.ZipFile(io.BytesIO(r.content))
z.extractall(OUTPATH)