import processing.serial.*; 
Serial myPort;
String serialData = "";
int leftVal = 0;
int rightVal = 0;

float ballX, ballY;
float ballSpeedX = 3;
float ballSpeedY = 5;
float ballSize = 20;

float paddleW = 100;
float paddleH = 15;
float playerX, playerY;
float playerSpeed = 6;
float aiX, aiY;
int playerScore = 0;
int aiScore = 0;
boolean gameStarted = false;
boolean paused = false;

void setup(){
  size(800, 700);

  myPort = new Serial(this, "/dev/cu.usbserial-D30DPUI8", 9600);
  myPort.bufferUntil('\n');

  resetGame();
}

void draw(){
  background(0);
  
  stroke(255);
  for (int i = 5; i < width; i += 20){
    line(i, height/2, i+10, height/2);
  }
  
  fill(255);
  textAlign(CENTER);
  textSize(32);
  text(playerScore, 30, height/2 + 60);
  text(aiScore, 30, height/2 - 30);
  
  rect(playerX, playerY, paddleW, paddleH, 6);
  rect(aiX, aiY, paddleW, paddleH, 6);
  
  if (!gameStarted || paused){
    textAlign(CENTER, CENTER);
    textSize(16);
    text("Control paddle by moving foam left and right • SPACE serve • P pause • R reset", 
         width/2, height/2 - 30);
  }
  
  if (gameStarted && !paused){
    ellipse(ballX, ballY, ballSize, ballSize);
    
    ballX += ballSpeedX;
    ballY += ballSpeedY;
    
    if (ballX < 10 || ballX > width-10){
      ballSpeedX *= -1;
    }
    if (ballY + ballSize/2 > playerY && 
        ballX > playerX && ballX < playerX + paddleW){
      ballSpeedY *= -1;
      ballY = playerY - ballSize/2;
    }
    if (ballY - ballSize/2 < aiY + paddleH && 
        ballX > aiX && ballX < aiX + paddleW){
      ballSpeedY *= -1;
      ballY = aiY + paddleH + ballSize/2;
    }
    
    if (ballY < 0){
      playerScore++;
      resetBall();
    } else if (ballY > height){
      aiScore++;
      resetBall();
    }
    
    int threshold = 10; 
    
    if (leftVal - rightVal > threshold){
      playerX += playerSpeed;
    } else if (rightVal - leftVal > threshold){
      playerX -= playerSpeed;
    }
    playerX = constrain(playerX, 0, width - paddleW);
    
    float error = map(noise(frameCount * 0.01), 0, 1, -40, 40);
    float targetX = ballX - paddleW/2 + error;
    aiX += (targetX - aiX) * 0.05;
    aiX = constrain(aiX, 0, width - paddleW);
    
    //println("Left:", leftVal, "Right:", rightVal, "Diff:", leftVal - rightVal);
    
  } else {
    // Show ball in middle when paused or not started
    ellipse(ballX, ballY, ballSize, ballSize);
  }
}

void serialEvent(Serial p){
  serialData = p.readStringUntil('\n');
  if (serialData != null) {
    serialData = trim(serialData);
    String[] values = split(serialData, ',');
    if (values.length == 2) {
      leftVal = int(values[0]);
      rightVal = int(values[1]);
    }
  }
}

void resetBall(){
  ballX = width/2;
  ballY = height/2;
  ballSpeedY = random(1) > 0.5 ? 3 : -3;
  ballSpeedX = random(-2, 2);
}

void resetGame(){
  playerX = width/2 - paddleW/2;
  playerY = height - 40;
  aiX = width/2 - paddleW/2;
  aiY = 30;
  playerScore = 0;
  aiScore = 0;
  resetBall();
}

void keyPressed(){
  if (key == ' ') {
    gameStarted = true;
    paused = false;
  } else if (key == 'r' || key == 'R') {
    resetGame();
    gameStarted = false;
  } else if (key == 'p' || key == 'P') {
    paused = !paused;
  }
}
