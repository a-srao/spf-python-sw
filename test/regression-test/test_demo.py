def test_squares_up_to_ten(regtest):

    result = [i*i for i in range(11)]

    # one way to record output:
    print(result, file=regtest)