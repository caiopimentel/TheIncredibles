class SrIncrivel 
{
  private PImage mainImage, mouseOverImage, maskImageS, maskImageL;
  private PImage [] buttonImage;
  private AnimationSurvivalKit imgCalculator; // Objeto que faz calculo de posição/escala/opacidade pras imagens
  private AnimationSurvivalKit blinkCalculator;

  private float [] imgPos = new float [2]; // posição da imagem X e Y respectivamente
  private float [] imgSize = new float [2]; // tamanho da imagem W e H respectivamente
  private float imgScale = 1;
  private float imgOpac = 255; // Opacidade da imagem
  private int animVeloc = 5;  // Velocidade da animação
  private int opacityVelocIN = 8; // Velocidade de fade in
  private int opacityVelocOUT = 2; // Velocidade de fade out
  private int OUT_OF_IMAGE = 7; // Object ID de quando o mouse está fora da imagem
  private float finalScale; // Escala máxima
  private boolean choosen = false; // Armazena se a imagem foi selecionada ou não
  private int clickID = OUT_OF_IMAGE; // Armazena qual foi o ultimo Object ID que o mouse clicou
  private long currentTime, lastBlinkTime;
  private int blinkLimitTime = 800;
  private int blinkVeloc = 2;
  private boolean clickOutSide = false;
  private boolean buttonInteraction = false;


  public SrIncrivel (float [] imgSize_, float x1_, float y1_, float x2_, float y2_, float finalScale_) {
    imgSize = imgSize_;
    imgCalculator = new AnimationSurvivalKit (x1_, y1_, x2_, y2_, finalScale_, 255);
    blinkCalculator = new AnimationSurvivalKit (0, 230);
    imgPos [0] = x1_;
    imgPos [1] = y1_;
    finalScale = finalScale_;
  }


  public void loadImages (String mainImage_, String mouseOverImage_, String maskImage_, String [] buttonImage_) 
  { //Carrega imagem principal, mouseOver, mask, e destaques de botões
    mainImage = loadImage (mainImage_);
    mouseOverImage = loadImage (mouseOverImage_);
    maskImageS = loadImage (maskImage_);
    maskImageL = loadImage (maskImage_);

    maskImageS.resize (int (imgSize [0]), int (imgSize [1])); // Escala a mask para o layout geral (em que ela é pequena)
    maskImageL.resize (int (imgSize [0] * finalScale), int (imgSize [1] * finalScale)); // Escala a mask para o layout específico (em que ela é grande)

    buttonImage = new PImage [buttonImage_.length];
    for (int i = 0; i < buttonImage.length; i++) {
      buttonImage [i] = loadImage (buttonImage_ [i]);
    }
  }


  public void display (boolean mainChoosen_) 
  { //Dá display da imagem do personagem adequada a ação do usuário
    displayCursor (mainChoosen_);

    tint (255, imgOpac);
    displayMouseOver ();
  }


  public void fadeInImage () 
  { // Anima o fade in da Imagem
    imgOpac = imgCalculator.animateOpacity(opacityVelocIN, false);
  }


  public void fadeOutImage () 
  { // Anima o fade out da Imagem
    imgOpac = imgCalculator.animateOpacity(opacityVelocOUT, true);
  }


  public void chooseImage () 
  { // Seleciona a imagem
    choosen = true;
  }


  public void unchooseImage () 
  { // Deseleciona a imagem
    choosen = false;
  }


  public void animateInImage () 
  { //Anima a imagem sendo escolhida (posição e escala)
    imgPos = imgCalculator.animateAlongLine (true, animVeloc, false, 100);
    imgScale = imgCalculator.animateScale (animVeloc, false);
  }


  public void animateOutImage () 
  { //Anima a imagem deixando de ser escolhida (posição e escala)
    imgPos = imgCalculator.animateAlongLine (true, animVeloc, true, 100);
    imgScale = imgCalculator.animateScale (animVeloc, true);
  }


  public void printDetails () 
  { // Dá print dos valores principais (para debuging)
    println ("-------------printDetails---------------");
    println ("imgPos X = " + imgPos [0]);
    println ("imgPos Y = " + imgPos [1]);
    println ("imgScale = " + imgScale);
    println ("imgOpac = " + imgOpac);
    println ("choosen = " + choosen); 
    println ("getMouseOverID = " + getMouseOverID ()); 
    println ("----------------------------------------");
  }


  private int getMouseOverID () 
  { // Retorna o valor do Object ID respectivo ao pixel da mascara em que o mouse está em cima
    color pickedColor; // Armazena a cor do pixel da mask que o mouse está em cima
    int objectID = 0; // Armazena ID do objeto sobre o qual o mouse está em cima
    color [] objectIDColor = {color (255, 0, 0), color (0, 255, 0), color (0, 0, 255), color (255, 255, 0), color (255, 0, 255), color (0, 255, 255)};
    // As cores respectivas a cada objeto
    color white = color (255);


    float mouseXTranslated, mouseYTranslated;

    mouseXTranslated = mouseX - imgPos [0]; 
    mouseYTranslated = mouseY - imgPos [1];

    if (choosen) {
      pickedColor = maskImageL.get(int (mouseXTranslated), int (mouseYTranslated));
    } else {
      pickedColor = maskImageS.get(int (mouseXTranslated), int (mouseYTranslated));
    }

    for (int i = 0; i < objectIDColor.length; i++) {
      if (objectIDColor [i] == pickedColor) {
        objectID = i;
        break;
      } else if (pickedColor == white) {
        objectID = 6;
      } else {
        objectID = OUT_OF_IMAGE; // Valor que não corresponde a nenhum index do objectIDColor, para representar nenhum mouse over em nenhuma mascara
      }
    }

    return objectID;
  }


  public boolean isMouseOver () 
  { // Retorna se o mouse está ou não em cima da ilustração
    boolean mouseOver = false;

    if (getMouseOverID () < 6) {
      mouseOver = true;
    } else {
      mouseOver = false;
    }

    return mouseOver;
  }


  public boolean isChoosen () 
  { // Retorna se a imagem está selecionada ou não
    return choosen;
  }


  private void displayCursor (boolean mainChoosen_) 
  { // Renderiza o cursor de acordo com a posição do mouse
    if (mainChoosen_) {
      if (isMouseOver ()) {
        if (choosen) {
          if (getMouseOverID () < 5) {
            cursor (HAND);
          } else {
            cursor (ARROW);
          }
        } else {
          if (getMouseOverID () < 6) {
            cursor (HAND);
          } else {
            cursor (ARROW);
          }
        }
      } else if (getMouseOverID () == 6) {
        cursor (ARROW);
      }
    }
  }


  public int getClickID () 
  { // Retorna o valor do Object ID respectivo ao pixel da mascara em que o mouse estava em cima em seu último click
    if (mousePressed) {
      clickID = getMouseOverID ();
    }

    return clickID;
  }


  public void updateInteraction () 
  { // Checa se teve algum botão clicado e altera o estado do buttonInteraction
    if (choosen && getClickID () < 5) {
      buttonInteraction = true;
    } else if (!choosen) {
      buttonInteraction = false;
    }
  }


  public boolean hadInteraction () 
  { // Retorna se tem algum botão clicado ou não
    return buttonInteraction;
  }


  private void displayMouseOver () 
  { // Renderiza diferentes imagens dependendo do ID sobre o que mouse está
    currentTime = millis ();

    if (!choosen) {
      if (getMouseOverID () >= 6) {  
        image (mainImage, imgPos [0], imgPos [1], (imgSize [0] * imgScale), (imgSize [1] * imgScale));
      } else {
        image (mouseOverImage, imgPos [0], imgPos [1], (imgSize [0] * imgScale), (imgSize [1] * imgScale));
      }
    }

    if (choosen) { // Mostrar essas imagens se o personagem for escolhido
      if (getClickID () <= 5) { // Se foi clicado em cima de botões da ilustração mostrar essas imagens
        if (buttonImage.length == 4) {
          switch (getClickID ()) {
          case 0: // Objeto 0
            image (buttonImage [0], imgPos [0], imgPos [1], (imgSize [0] * imgScale), (imgSize [1] * imgScale));
            break;
          case 1: // Objeto 1
            image (buttonImage [1], imgPos [0], imgPos [1], (imgSize [0] * imgScale), (imgSize [1] * imgScale));
            break;
          case 2: // Objeto 2
            image (buttonImage [2], imgPos [0], imgPos [1], (imgSize [0] * imgScale), (imgSize [1] * imgScale));
            break;
          case 5: // Silhueta, nenhum botão
            if (mousePressed) {
              clickOutSide = true;
              lastBlinkTime = currentTime;
            }

            if ((currentTime - lastBlinkTime) <= blinkLimitTime && clickOutSide) { // Parte responsável pelo piscar a dica quando se clica fora dos botões
              tint (255, imgOpac);
              image (mainImage, imgPos [0], imgPos [1], (imgSize [0] * imgScale), (imgSize [1] * imgScale));
              tint (255, blinkCalculator.animateOpacity(blinkVeloc, false));
              image (buttonImage [3], imgPos [0], imgPos [1], (imgSize [0] * imgScale), (imgSize [1] * imgScale));
            } else {
              tint (255, imgOpac);
              image (mainImage, imgPos [0], imgPos [1], (imgSize [0] * imgScale), (imgSize [1] * imgScale));
              tint (255, blinkCalculator.animateOpacity(blinkVeloc, true));
              image (buttonImage [3], imgPos [0], imgPos [1], (imgSize [0] * imgScale), (imgSize [1] * imgScale));
              clickOutSide = false;
            }
            break;
          }
        }
        if (buttonImage.length == 5) {
          switch (getClickID ()) {
          case 0: // Objeto 0
            image (buttonImage [0], imgPos [0], imgPos [1], (imgSize [0] * imgScale), (imgSize [1] * imgScale));
            break;
          case 1: // Objeto 1
            image (buttonImage [1], imgPos [0], imgPos [1], (imgSize [0] * imgScale), (imgSize [1] * imgScale));
            break;
          case 2: // Objeto 2
            image (buttonImage [2], imgPos [0], imgPos [1], (imgSize [0] * imgScale), (imgSize [1] * imgScale));
            break;
          case 3: // Objeto 3
            image (buttonImage [3], imgPos [0], imgPos [1], (imgSize [0] * imgScale), (imgSize [1] * imgScale));
            break;
          case 5: // Silhueta, nenhum botão
            if (mousePressed) {
              clickOutSide = true;
              lastBlinkTime = currentTime;
            }
            if ((currentTime - lastBlinkTime) <= blinkLimitTime && clickOutSide) { // Parte responsável pelo piscar a dica quando se clica fora dos botões
              tint (255, imgOpac);
              image (mainImage, imgPos [0], imgPos [1], (imgSize [0] * imgScale), (imgSize [1] * imgScale));
              tint (255, blinkCalculator.animateOpacity(blinkVeloc, false));
              image (buttonImage [4], imgPos [0], imgPos [1], (imgSize [0] * imgScale), (imgSize [1] * imgScale));
            } else {
              tint (255, imgOpac);
              image (mainImage, imgPos [0], imgPos [1], (imgSize [0] * imgScale), (imgSize [1] * imgScale));
              tint (255, blinkCalculator.animateOpacity(blinkVeloc, true));
              image (buttonImage [4], imgPos [0], imgPos [1], (imgSize [0] * imgScale), (imgSize [1] * imgScale));
              clickOutSide = false;
            }
            break;
          }
        }
      } else {
        if (buttonImage.length == 4) {
          switch (getMouseOverID ()) {
          case 0: // Objeto 0
            image (buttonImage [0], imgPos [0], imgPos [1], (imgSize [0] * imgScale), (imgSize [1] * imgScale));
            break;
          case 1: // Objeto 1
            image (buttonImage [1], imgPos [0], imgPos [1], (imgSize [0] * imgScale), (imgSize [1] * imgScale));
            break;
          case 2: // Objeto 2
            image (buttonImage [2], imgPos [0], imgPos [1], (imgSize [0] * imgScale), (imgSize [1] * imgScale));
            break;
          case 3: // Objeto 3 (No caso não existe)
          case 4: // Objeto 4 (No caso não existe)
          case 5: // Silhueta, nenhum botão
          case 6:
          case 7: // Nenhum botão
            image (mainImage, imgPos [0], imgPos [1], (imgSize [0] * imgScale), (imgSize [1] * imgScale));
            break;
          }
        } else if (buttonImage.length == 5) {
          switch (getMouseOverID ()) {
          case 0: // Objeto 0
            image (buttonImage [0], imgPos [0], imgPos [1], (imgSize [0] * imgScale), (imgSize [1] * imgScale));
            break;
          case 1: // Objeto 1
            image (buttonImage [1], imgPos [0], imgPos [1], (imgSize [0] * imgScale), (imgSize [1] * imgScale));
            break;
          case 2: // Objeto 2
            image (buttonImage [2], imgPos [0], imgPos [1], (imgSize [0] * imgScale), (imgSize [1] * imgScale));
            break;
          case 3: // Objeto 3
            image (buttonImage [3], imgPos [0], imgPos [1], (imgSize [0] * imgScale), (imgSize [1] * imgScale));
            break;
          case 4: // Objeto 4 (No caso não existe)
          case 5: // Silhueta, nenhum botão
          case 6:
          case 7: // Nenhum botão
            image (mainImage, imgPos [0], imgPos [1], (imgSize [0] * imgScale), (imgSize [1] * imgScale));
            break;
          }
        }
      }
    }
  }
}