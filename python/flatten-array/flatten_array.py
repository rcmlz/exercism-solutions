"""This is the module docstring."""

def flatten(iterable):
    """This is the function docstring."""
    if not isinstance(iterable, list) and iterable != None:
        return [iterable]

    if isinstance(iterable, list) and len(iterable) >= 1:
        return flatten(iterable.pop(0)) + flatten(iterable)

    return []
