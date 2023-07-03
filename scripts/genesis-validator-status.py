import requests
import json
import time
import curses
import os
import base64
import hashlib
import sys
from tabulate import tabulate


GENTX_FOLDER = sys.argv[1]
CONSENSUS_ENDPOINT = sys.argv[2]
VALIDATORS_DB = {}

total_genesis_power = 0

def poll_validator_status(api_url):
    prevotes = []
    try:
        response = requests.get(api_url)
        response.raise_for_status()
        data = response.json()
        prevotes = [prevote.split(":")[1].split(" ")[0] for prevote in data["result"]["round_state"]["height_vote_set"][0]["prevotes"] if prevote != "nil-Vote"]

    except requests.exceptions.RequestException as e:
        print("Error occurred:", str(e))
    
    return prevotes

def load_validators_db(path):
    global total_genesis_power
    gentx_files = [f for f in os.listdir(path) if f.endswith('.json')]
    # Iterate over each gentx file
    for gentx_file in gentx_files:
        file_path = os.path.join(path, gentx_file)
        with open(file_path, "r") as f:
            try:
                data = json.load(f)
                pub_key = hashlib.sha256(
                        base64.b64decode(
                            data["body"]["messages"][0]["pubkey"]["key"]
                        )
                    ).hexdigest()
                moniker = data["body"]["messages"][0]["description"]["moniker"]
                security_contact = data["body"]["messages"][0]["description"]["security_contact"]
                website = data["body"]["messages"][0]["description"]["website"]
                identity = data["body"]["messages"][0]["description"]["identity"]
                self_delegation = data["body"]["messages"][0]["value"]["amount"]
                status = "OFFLINE"
                VALIDATORS_DB[pub_key[0:12].upper()] = [
                    moniker,
                    security_contact,
                    website,
                    identity,
                    self_delegation,
                    status
                ]
                total_genesis_power = total_genesis_power + int(self_delegation)
            except json.JSONDecodeError as e:
                print(f"Error decoding JSON file {f}: {e}")


def print_table(stdscr):
    online_power = 0
    global total_genesis_power
    
    # Clear the screen
    stdscr.clear()

    prevotes = poll_validator_status(CONSENSUS_ENDPOINT)
    for prevote in prevotes:
        VALIDATORS_DB[prevote] = VALIDATORS_DB[prevote][:-1] + ["ONLINE"]

    for validator in VALIDATORS_DB.values():
        if validator[-1] == "ONLINE":
            online_power = online_power + int(validator[4])

    header = ["Moniker", "Security Contact", "Website", "Identity", "Self Delegation", "Status"]
    table_data = list(VALIDATORS_DB.values())

    # # Print the table
    # for row in table_data:
    percentage_power_online = (online_power/total_genesis_power) * 100
    stdscr.addstr(f"Voting Power ONLINE: {percentage_power_online}%\n")
    stdscr.addstr(tabulate(table_data, headers=header))

    # Refresh the screen
    stdscr.refresh()

def main(stdscr):
    # Set up the initial table
    print_table(stdscr)

    while True:
        # Wait for 1 second
        time.sleep(0.2)

        # Update the table
        print_table(stdscr)


if __name__ == '__main__':
    gentx_folder = sys.argv[1]
    load_validators_db(GENTX_FOLDER)
    curses.wrapper(main)

