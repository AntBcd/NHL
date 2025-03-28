### NHL API extractions
import requests

base_url = "https://api-web.nhle.com/v1/standings/2022-05-01"

# Get standings since the 2000-2001 season (first season with 30 teams).
params = {"season": "20002001"}

rsp = requests.get(base_url)
standings = rsp.json()
print(standings)