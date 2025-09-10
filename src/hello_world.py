"""hello_world 

This module is a hello world demo
"""
from utils import greet_user  # Example import from utils.py

def main():
    """Main Function"""
    user_name = "World"
    print(greet_user(user_name))



# the backslash is there so that code coverage
# considers the line hereunder as covered as well
if __name__ == "__main__": \
    main()