# @judy's Advent of Code

## WARNING! Spoilers abound!

These are my scripts for [Advent of Code](https://adventofcode.com/).

- These aren't always (ever?) going to be very clean or efficient implementations. I'm trying to get the right answer as quickly as possible.
- I'm also not currently doing any of the challenges in a language other than Ruby. I do these for fun! 🥰
- Each day has two challenges, each rewarding a star. I'm not bothering with keeping around the script for the first star of each challenge since they're related, but I'm trying to remember to commit between challenges. So earlier versions of each script will have solutions for the first challenge of each day.

# Install

Clone locally, then run `bundle install` to install the dependencies. Also, if you're not me, sign up for an account at [Advent of Code](https://adventofcode.com/) and try it out!

# Usage

Be warned: These are notes to remind myself what to do, since it's a full year between Advents.

There's a `/template` folder that has a script and a test file. Copy that folder to a new folder for the year and day you're working on.

Then, add data.txt to the folder. Copy+paste the puzzle input from the website into that file.

# Running

Passing in 'test' like so:

    bundle exec ./2022/01/script.rb test

runs the tests for that script. Then to test against the data (the data is stored in `data.txt` in each folder as well):

    bundle exec ./2022/01/script.rb 2022/01/data.txt
