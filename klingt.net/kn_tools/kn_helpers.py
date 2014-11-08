def hashit(text):
    import hashlib
    return hashlib.sha224(text).hexdigest()

def get_date():
    from datetime import date
    return date.today()