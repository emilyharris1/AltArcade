import processing.serial.*;
import processing.sound.*;
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

float yellowBallX = 300;
float yellowBallY = 350;
float blueBallX = 500;
float blueBallY = 350;
float speedBallSize = 35;

boolean slowEffectActive = false; // powerups
boolean speedEffectActive = false;
int slowEffectTimer = 0;
int speedEffectTimer = 0;
float originalSpeedX = 3;
float originalSpeedY = 5;

SoundFile bounceSound;
SoundFile scoreSound;
SoundFile serveSound;
SoundFile loseSound;

void setup(){
  size(800, 700);
  myPort = new Serial(this, "/dev/cu.usbserial-D30DPUI8", 9600);
  myPort.bufferUntil('\n');
  
  bounceSound = new SoundFile(this, "bounce.wav"); 
  scoreSound = new SoundFile(this, "score.wav");   
  serveSound = new SoundFile(this, "serve.wav");  
  loseSound   = new SoundFile(this, "lose.mp3");
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
  
  // powerups
  fill(255, 255, 0);
  ellipse(yellowBallX, yellowBallY, speedBallSize, speedBallSize);
  fill(0, 0, 255);
  ellipse(blueBallX, blueBallY, speedBallSize, speedBallSize);
  
  if (!gameStarted || paused){
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(16);
    text("Control bottom paddle by moving foam left and right • SPACE serve • P pause • R reset", 
         width/2, height/2 - 60);
    text("Ball speeds up after each paddle hit • Yellow ball = slow down • Blue ball = speed up", 
         width/2, height/2 - 30);
  }
  
  if (gameStarted && !paused){
    fill(255);
    ellipse(ballX, ballY, ballSize, ballSize);
    
    ballX += ballSpeedX;
    ballY += ballSpeedY;
    
    // yellow ball collision
    if (!slowEffectActive && dist(ballX, ballY, yellowBallX, yellowBallY) < (ballSize + speedBallSize) / 2) {
      slowEffectActive = true;
      slowEffectTimer = millis();
      originalSpeedX = ballSpeedX;
      originalSpeedY = ballSpeedY;
      ballSpeedX *= 0.4; // Slow down
      ballSpeedY *= 0.4;
    }
    
    // blue ball collision
    if (!speedEffectActive && dist(ballX, ballY, blueBallX, blueBallY) < (ballSize + speedBallSize) / 2) {
      speedEffectActive = true;
      speedEffectTimer = millis();
      originalSpeedX = ballSpeedX;
      originalSpeedY = ballSpeedY;
      ballSpeedX *= 2.0; // Speed up
      ballSpeedY *= 2.0;
    }
    
    if (slowEffectActive && millis() - slowEffectTimer > 5000) {
      slowEffectActive = false;
      ballSpeedX = (ballSpeedX > 0 ? 1 : -1) * abs(originalSpeedX);
      ballSpeedY = (ballSpeedY > 0 ? 1 : -1) * abs(originalSpeedY);
    }
    
    if (speedEffectActive && millis() - speedEffectTimer > 5000) {
      speedEffectActive = false;
      ballSpeedX = (ballSpeedX > 0 ? 1 : -1) * abs(originalSpeedX);
      ballSpeedY = (ballSpeedY > 0 ? 1 : -1) * abs(originalSpeedY);
    }
    
    // bounce off wall + direction
    if (ballX < 10 || ballX > width-10){
      ballSpeedX *= -1;
      bounceSound.play();
    } // bounce off paddle + direction
    if (ballY + ballSize/2 > playerY && 
        ballX > playerX && ballX < playerX + paddleW){
      ballSpeedY *= -1;
      ballY = playerY - ballSize/2;
      bounceSound.play();
      
      ballSpeedX *= 1.05;
      ballSpeedY *= 1.05;
    }
    if (ballY - ballSize/2 < aiY + paddleH && 
        ballX > aiX && ballX < aiX + paddleW){
      ballSpeedY *= -1;
      ballY = aiY + paddleH + ballSize/2;
      bounceSound.play();
      
      ballSpeedX *= 1.05;
      ballSpeedY *= 1.05;
    }
    
    if (ballY < 0){
      playerScore++;
      scoreSound.play(); 
      resetBall();
    } else if (ballY > height){
      aiScore++;
      loseSound.play();
      resetBall();
    }
    
    int threshold = 10; 
    
    if (rightVal - leftVal > threshold){
  playerX += playerSpeed;
} else if (leftVal - rightVal > threshold){
  playerX -= playerSpeed;
}
    playerX = constrain(playerX, 0, width - paddleW);
    
    float error = map(noise(frameCount * 0.01), 0, 1, -40, 40);
    float targetX = ballX - paddleW/2 + error;
    aiX += (targetX - aiX) * 0.035;
    aiX = constrain(aiX, 0, width - paddleW);
    
  } else {
    fill(255);
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
  ballSpeedY = random(1) > 0.5 ? 2.75 : -2.75;
  ballSpeedX = random(-3, 3);
  slowEffectActive = false;
  speedEffectActive = false;
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
  if (key == ' ') { // space
    gameStarted = true;
    paused = false;
    serveSound.play();
  } else if (key == 'r' || key == 'R') {
    resetGame();
    gameStarted = false;
  } else if (key == 'p' || key == 'P') {
    paused = !paused;
  }
}
