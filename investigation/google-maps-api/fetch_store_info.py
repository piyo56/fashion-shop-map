import sys, os
import googlemaps

if __name__ == "__main__":
    api_key = os.environ.get("GOOGLE_MAPS_API_KEY")
    store_name = "ユナイテッドアローズ"

    gmaps = googlemaps.Client(key=api_key)
    results = gmaps.places(store_name)
    
    hit_store_num = len(results["results"])
    for i in range(hit_store_num):
        store = results["results"][i]
        print(store["name"])
        sys.stdin.read(1)
