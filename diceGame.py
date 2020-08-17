import random
import time


def roll():
    print('rolling dice...')
    time.sleep(2)
    h = random.randint(1, 6)
    print('you rolled...', h)
    time.sleep(1)
    return(h)


def comp_roll():
    print('computer rolling.....')
    time.sleep(2)
    hc = random.randint(1, 6)
    print('Computer rolled..:', hc)
    return(hc)


def game():
    d = input('Plz type R to roll the dice')
    if d.upper() == 'R':
        human = roll()
    else:
        game()
        return
    computer = comp_roll()
    if human > computer:
        res = "You Won!!"
    else:
        res = "Computer won.."
    print(res)
    return


def rep_game():
    repeat = input('type y to play again')
    while repeat.lower() == 'y':
        game()
    return


game()
rep_game()
