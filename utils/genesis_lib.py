"""
This is a Python library for working with Cosmos SDK genesis files.
It contains a collection of functions that can be used to modify genesis
file e.g. in case of hard forks.

Note: Library uses json module and loads entire genesis file in memory so it can be
quite memory intesive and can definitly use some performance improvements e.g. by migrating
to ijson.
"""

import csv
import json


def get_path(genesis_dict, path):
    """
    Get a json value at a given path
    Reference for json value: https://datatracker.ietf.org/doc/html/rfc8259#section-3

    Args:
        genesis_dict (dict): A Python object representation of a genesis file.
        path (str): A jq compatible path to the key to get.
    Returns:
        d (dict): The value at the given path.
    """
    # Split the path into a list and discard the first element, as jq compatible
    # path will always start with a dot so the first element will always be empty
    path_list = path.split(".")[1:]

    # Get the dictionary at the path
    d = genesis_dict
    for key in path_list:
        try:
            d = d[key]
        except KeyError:
            key = key.rstrip("]")
            key, value = key.split("[")
            d = d[key][int(value)]

    # Return the dictionary
    return d

def search_genesis(genesis_dict, search_term):
    """
    Find all occurrences of a search term in a Python object representation of a genesis file.

    Args:
        genesis_dict (dict): A Python object representation of a genesis file.
        search_term (str): The search term.
    
    Returns:
        list: A list of paths to the search term.
    """
    # Create an empty list to store the results
    occurrences = []

    def search(obj, path=""):
        # If obj is a dictionary
        if isinstance(obj, dict):

            for key, value in obj.items():
                # Check if the key matches the search term
                if key == search_term:
                    occurrences.append(path)
                # If the value is another dictionary or list, recursively call the search function
                if isinstance(value, (dict, list)):
                    search(value, path + "." + key)
                # Otherwise, check if the value matches the search term
                elif value == search_term:
                    occurrences.append(path)
        # If obj is a list
        elif isinstance(obj, list):
            for i, item in enumerate(obj):
                # If the item is another dictionary or list, recursively call the search function
                if isinstance(item, (dict, list)):
                    search(item, path + "[" + str(i) + "]")
                # Otherwise, check if the item matches the search term
                elif item == search_term:
                    occurrences.append(path + "[" + str(i) + "]")

    # Start the search by calling the search function with the top-level Python object
    search(genesis_dict)

    # Return the list of occurrences
    return occurrences


def get_balances(genesis_dict, accounts, denom):
    """
    Get the balances of a list of accounts in a Python object representation of a genesis file.

    Args:
        genesis_dict (dict): A Python object representation of a genesis file.
        accounts (list): A list of accounts.
    Returns:
        dict: A dictionary of balances.
    """
    # Create an empty dictionary to store the balances
    balances = {}

    # Get the list of balances from the genesis file
    balances_list = genesis_dict["app_state"]["bank"]["balances"]

    # For each account
    for account in accounts:
        # For each balance in the list of balances
        for balance in balances_list:
            # If the account matches the address in the balance
            if account == balance["address"]:
                balances[account] = balance["coins"]

    # Return the dictionary of balances
    return balances

def del_value_at_path(genesis_dict, path):
    """
    Delete a json value at a given path
    Reference for json value: https://datatracker.ietf.org/doc/html/rfc8259#section-3

    Args:
        genesis_dict (dict): A Python object representation of a genesis file.
        path (str): A jq compatible path to the key to delete.
    Returns:
        no return value, as the function updates the passed genesis_dict object
    """
    # Split the path into a list and discard the first element, as jq compatible
    # path will always start with a dot so the first element will always be empty
    path_list = path.split(".")[1:]

    # Get the key to delete
    key_to_delete = path_list[-1]

    # Remove the key from the path
    path_list = path_list[:-1]

    # Get the dictionary at the path
    d = genesis_dict
    for key in path_list:
        try:
            d = d[key]
        except KeyError:
            key = key.rstrip("]")
            key, value = key.split("[")
            d = d[key][int(value)]

    # Delete the key from the dictionary
    try:
        del d[key_to_delete]
    except KeyError:
        key_to_delete = key_to_delete.rstrip("]")
        key_to_delete, value = key_to_delete.split("[")
        del d[key_to_delete][int(value)]

def replace_value_at_path(genesis_dict, path, new_value):
    """
    Replace a json value of a given path
    Reference for json value: https://datatracker.ietf.org/doc/html/rfc8259#section-3

    Args:
        genesis_dict (dict): A Python object representation of a genesis file.
        path (str): A jq compatible path where the value must be replaced.
        new_value (dict): The new value to replace the old value with.
    Returns:
        no return value, as the function updates the passed genesis_dict object
    """
    # Split the path into a list and discard the first element, as jq compatible
    # path will always start with a dot so the first element will always be empty
    path_list = path.split(".")[1:]

    # Get the key to replace
    key_to_replace = path_list[-1]

    # Remove the key from the path
    path_list = path_list[:-1]

    # Get the dictionary at the path
    d = genesis_dict
    for key in path_list:
        d = d[key]

    # Replace the value in the dictionary
    d[key_to_replace] = new_value

def verify_supply(genesis_dict):
    """
    Verify the total supply in the genesis dict by adding individual account balances
    and comparing it with total supply

    Args:
        genesis_dict (dict): A Python object representation of a genesis file.
    Return:
        boolean: True if the total supply is correct, False otherwise
    """
    supply = genesis_dict["app_state"]["bank"]["supply"]

    sum_of_balances = {}
    for balance in genesis_dict["app_state"]["bank"]["balances"]:
        for coin in balance["coins"]:
            if coin["denom"] in sum_of_balances:
                sum_of_balances[coin["denom"]] += int(coin["amount"])
            else:
                sum_of_balances[coin["denom"]] = int(coin["amount"])

    for coin in supply:
        if coin["denom"] in sum_of_balances:
            if sum_of_balances[coin["denom"]] != int(coin["amount"]):
                return False
        else:
            return False


def del_account(genesis_dict, account):
    """
    Delete an account from the genesis dict

    Args:
        genesis_dict (dict): A Python object representation of a genesis file.
        account (str): The account address to delete.
    Returns:
        no return value, as the function updates the passed genesis_dict object
    """
    occurances = search_genesis(genesis_dict, account)
    balance = get_balances(genesis_dict, [account])
    for o in occurances:
        del_value_at_path(genesis_dict, o)
    
    for coin in balance[account]:
        for supply in genesis_dict["app_state"]["bank"]["supply"]:
            if coin["denom"] == supply["denom"]:
                supply["amount"] = str(int(supply["amount"]) - int(coin["amount"]))
