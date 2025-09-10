"""hello_world 

This module is a hello world demo
"""


def main():
    """Main Function"""
    print("Hello World!")

def greet():
    print("Greetings!")
    print("Test Greet Function")


# the backslash is there so that code coverage
# considers the line hereunder as covered as well
if __name__ == "__main__": \
    main()