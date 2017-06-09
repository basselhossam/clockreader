# clockreader
matlab analog clock to digital clock converter

this project uses matlab hough line algorithm and sobel edge detection algorithm to detect the digital clock value from the image.

it works with both jpg or png formats.

there is two modes of operations:

1- debug mode where there is a figure shown every step to show the processing done on the image

2- non debug mode where only the final result is shown in the console

## Usage

1- download / clone the project

2- open main.m file using matlab

3- set the varible ```imageurl``` to the image name

4- set the varible ```debug``` with true or false as you like

5- run the project and check the result in the console.

## Algorithm

1- we read the image.

2- we try to get the center of the clock by using sobel edge detection assuming that the clock is the biggest shape in the image.

3- we apply hough line to get lines of the arrows and we apply it multiple times for accuracy.

4- after we get the lines we use the angle between lines to determine the clock value.
