def tef_test():
    x, y = 1, 2
    try:
        x += 2
        y += 4
        raise NotImplementedError
        return x
    except Exception:
        x += 4
        y += 8
        return x
    finally:
        x += 8
        y += 16
        return y