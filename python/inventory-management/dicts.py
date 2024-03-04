"""This is the module docstring."""

def create_inventory(items):
    """

    :param items: list - list of items to create an inventory from.
    :return:  dict - the inventory dictionary.
    """
    result = {}

    for item in items:
        if item not in result:
            result[item] = 0
        result[item] += 1

    return result


def add_items(inventory, items):
    """

    :param inventory: dict - dictionary of existing inventory.
    :param items: list - list of items to update the inventory with.
    :return:  dict - the inventory dictionary update with the new items.
    """
    new_items = create_inventory(items)

    for key, value in new_items.items():
        if key not in inventory:
            inventory[key] = 0
        inventory[key] += value

    return inventory


def decrement_items(inventory, items):
    """

    :param inventory: dict - inventory dictionary.
    :param items: list - list of items to decrement from the inventory.
    :return:  dict - updated inventory dictionary with items decremented.
    """

    tmp_inventory = create_inventory(items)

    for key, value in tmp_inventory.items():
        if value > 0:
            inventory[key] = max(0, inventory[key] - value)

    return inventory


def remove_item(inventory, item):
    """
    :param inventory: dict - inventory dictionary.
    :param item: str - item to remove from the inventory.
    :return:  dict - updated inventory dictionary with item removed.
    """
    inventory.pop(item, None)

    return inventory


def list_inventory(inventory):
    """

    :param inventory: dict - an inventory dictionary.
    :return: list of tuples - list of key, value pairs from the inventory dictionary.
    """

    return [(key, value) for key, value in inventory.items() if value > 0]
