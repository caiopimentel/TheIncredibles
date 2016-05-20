void updateInteractions ()
{// Checa se teve interação nos botões da ilustração
  for (int i = 0; i < srincrivel.length; i++) {
    srincrivel [i].updateInteraction ();
  }
}


void animateMovement ()
{ // Calcula a posição e a escala das imagens principais dos momentos
  for (int i = 0; i <=4; i++) {
    if (!srincrivel [i].isChoosen ()) {
      srincrivel [i].animateOutImage();
    } else {
      srincrivel [i].animateInImage();
    }
  }
}


void chooseSrIncrivel () 
{ /* Permite ao usuário selecionar e deselecionar uma ilustração (que vai disparar as animações desta)*/
  currentTime = millis ();

  if (!(srincrivel [0].isChoosen () || srincrivel [1].isChoosen () || srincrivel [2].isChoosen () ||
    srincrivel [3].isChoosen () || srincrivel [4].isChoosen ())) { // Se nenhuma ilustração estiver selecionada
    for (int i = 0; i < srincrivel.length; i++) {
      if (mousePressed && srincrivel [i].isMouseOver ()) {
        if ((currentTime - lastTime) >= limitTime) { // Timer, para impedir mudanças de escolha com intervalos de tempo muito pequenos
          srincrivel [i].chooseImage();
          pick = i; // Armazena o valor a última imagem escolhida
          lastTime = currentTime;           
          break;
        }
      }
    }
  } else {
    for (int i = 0; i < srincrivel.length; i++) {
      if (mousePressed && !srincrivel [i].isMouseOver () && srincrivel [i].isChoosen ()) { // Checa condições de deseleção da ilustração escolhida
        if ((currentTime - lastTime) >= limitTime) { // Timer, para impedir mudanças de escolha com intervalos de tempo muito pequenos
          srincrivel [i].unchooseImage();
          lastTime = currentTime;
        }
      }
    }
  }
}


void displayMaster () 
{ // Renderiza ilustrações/imagens de cada momento da história e executa outras funções de display
  int opacityVelocIN = 10;
  int opacityVelocOUT = 2;

  if (srincrivel [0].isChoosen () || srincrivel [1].isChoosen () || srincrivel [2].isChoosen ()
    || srincrivel [3].isChoosen () || srincrivel [4].isChoosen ()) {

    displayTitle (titleCalculator.animateOpacity(opacityVelocOUT, true), subTitleCalculator.animateOpacity(opacityVelocOUT, true), 
      instructionCalculator.animateOpacity(opacityVelocOUT, true)); // Dá fade out na tipografia do layout geral

    for (int i = 0; i < srincrivel.length; i++) {
      if (srincrivel [i].isChoosen ()) {
        srincrivel [i].fadeInImage (); // Dá fade in na imagem escolhida
        srincrivel [i].display(true); // Renderiza a ilustração escolhida
        displayText (textCalculator.animateOpacity(opacityVelocIN, false)); // Revela os textos do momento
      } else {
        srincrivel [i].fadeOutImage (); // Dá fade out nas demais ilustrações
        srincrivel [i].display(false); // Renderiza as demais ilustrações
      }
    }
  } else {

    displayTitle (titleCalculator.animateOpacity(opacityVelocIN, false), subTitleCalculator.animateOpacity(opacityVelocIN, false), 
      instructionCalculator.animateOpacity(opacityVelocIN, false)); // Dá fade in na tipografia do layout geral

    for (int i = 0; i < srincrivel.length; i++) {
      if (!(pick == i)) {
        srincrivel [i].fadeInImage (); // Dá fade in nas demais ilustrações
        srincrivel [i].display(true); // Renderiza as demais ilustrações
        displayText (textCalculator.animateOpacity(opacityVelocOUT, true)); // Oculta os textos do momento
      } else {
        srincrivel [i].display(true); // Renderiza a ilustração previamente escolhida
      }
    }
  }
}


float adaptiveData (int inData, float imgWidth) 
{/* Adapta qualquer dado à resolução da tela em que o programa está rodando. Seja uma posição, escala
 largura, altura, diametro, etc. Para que o layout esteja propriamente mostrado na tela em modo fullscreen independente do monitor*/

  int dellImgWidth = 336; // No monitor da Dell UltraSharp U2415 (Usado como controle) essa é a largura da imagem adequada
  float outadaptiveData = (inData * imgWidth) / dellImgWidth;

  return outadaptiveData;
}


void displayTitle (float tempTitleOpacity, float tempSubTitleOpacity, float tempInstructionOpacity) 
{ // Renderiza os textos do layout geral
  color titleColor, subtitleColor, startInstructionColor;
  int titleYAdjust = 60;
  
  pushStyle ();

  titleColor = color (240, 240, 240, tempTitleOpacity);
  subtitleColor = color (240, 240, 240, tempSubTitleOpacity);
  startInstructionColor = color (240, 240, 240, tempInstructionOpacity);

  fill (titleColor);
  textFont (fontBook);
  textSize (adaptiveData (250, imgSize [0]));
  text ("THE INCREDIBLES", adaptiveData (-20, imgSize [0]), topLine + adaptiveData (-135, imgSize [0]) + titleYAdjust, 
    width + adaptiveData (800, imgSize [0]), adaptiveData (800, imgSize [0]));

  fill (subtitleColor);
  textSize (adaptiveData (70, imgSize [0]));
  text ("by Bob Parr", adaptiveData (102, imgSize [0]), topLine + adaptiveData (-175, imgSize [0]) + titleYAdjust, 
    adaptiveData (600, imgSize [0]), adaptiveData (400, imgSize [0]));

  fill (startInstructionColor);
  textSize (adaptiveData (18, imgSize [0]));
  textAlign(RIGHT);
  text ("Design: Caio Pimentel & Taís Fernandes \nSoftware Dev: Caio Pimentel \nIllustrations: Taís Fernandes \nText: Hellen Jardim ", 
    (width/2) + adaptiveData (50, imgSize [0]), height - (height/6.4), 
    adaptiveData (800, imgSize [0]), adaptiveData (450, imgSize [0]));

  popStyle ();
}


void displayText (float opacity_) 
{ // Renderiza os textos do layout específico dos momentos
  pushStyle ();
  color textColor = color (250, 250, 250, opacity_);
  color secretsTitleColor = color (243, 234, 234, (opacity_ - 50));
  color instructionColor = color (243, 234, 234, (opacity_ - 100));
  int masterYAdjust = -150;
  int compensateTextSize = -130;

  fill (textColor);
  textFont (fontLight);
  textSize (adaptiveData (37, imgSize [0]));
  textLeading(adaptiveData (47, imgSize [0])); //controla entrelinha

  if (!srincrivel [pick].hadInteraction () && srincrivel [pick].isChoosen ()) {
    text (textoMomentos [pick + 1], width/2, height/2 + adaptiveData (-125, imgSize [0]) + masterYAdjust, // tempPick + 1 para pular a primeira linha com entrada de parágrafo
      adaptiveData (800, imgSize [0]), adaptiveData (450, imgSize [0])); // Escreve os textos referentes ao momentos em si


    fill (instructionColor);
    textFont (fontBook);
    textSize (adaptiveData (42, imgSize [0]));

    if (pick == 3) {
      text ("Mr. Parr has something to say!", width/2, (height/2 + adaptiveData (265, imgSize [0]) + masterYAdjust + compensateTextSize), 
        adaptiveData (800, imgSize [0]), adaptiveData (450, imgSize [0]));

      textSize (adaptiveData (26, imgSize [0]));

      text ("Click and find out his side of the story", width/2, (height/2 + adaptiveData (323, imgSize [0]) + masterYAdjust  + compensateTextSize), 
        adaptiveData (800, imgSize [0]), adaptiveData (450, imgSize [0]));
    } else {
      text ("Mr. Parr has something to say!", width/2, height/2 + adaptiveData (265, imgSize [0]) + masterYAdjust, 
        adaptiveData (800, imgSize [0]), adaptiveData (450, imgSize [0]));

      textSize (adaptiveData (26, imgSize [0]));

      text ("Click and find out his side of the story", width/2, height/2 + adaptiveData (323, imgSize [0]) + masterYAdjust, 
        adaptiveData (800, imgSize [0]), adaptiveData (450, imgSize [0]));
    }
  } else if (srincrivel [pick].getClickID () < 5) {
    text (textoSecrets [pick] [srincrivel [pick].getClickID () + 1], width/2, height/2 + adaptiveData (-125, imgSize [0]) + masterYAdjust, // getClickID () + 1 para pular a primeira linha com entrada de parágrafo
      adaptiveData (800, imgSize [0]), adaptiveData (450, imgSize [0]));

    fill (secretsTitleColor);
    textFont (fontBook);
    textSize (adaptiveData (70, imgSize [0]));
    text (tituloSecrets [pick] [srincrivel [pick].getClickID () + 1], width/2 + adaptiveData (-50, imgSize [0]), height/2 + adaptiveData (-210, imgSize [0]) + masterYAdjust, // getClickID () + 1 para pular a primeira linha com entrada de parágrafo
      adaptiveData (1200, imgSize [0]), adaptiveData (450, imgSize [0]));

    lastButtonClicked = srincrivel [pick].getClickID () + 1;
  } else if (srincrivel [pick].getClickID () == 5 && srincrivel [pick].hadInteraction ()) {
    text (textoSecrets [pick] [lastButtonClicked], width/2, height/2 + adaptiveData (-125, imgSize [0]) + masterYAdjust, 
      adaptiveData (800, imgSize [0]), adaptiveData (450, imgSize [0]));

    fill (secretsTitleColor);
    textFont (fontBook);
    textSize (adaptiveData (70, imgSize [0]));
    text (tituloSecrets [pick] [lastButtonClicked], width/2 + adaptiveData (-50, imgSize [0]), height/2 + adaptiveData (-210, imgSize [0]) + masterYAdjust, // getClickID () + 1 para pular a primeira linha com entrada de parágrafo
      adaptiveData (1200, imgSize [0]), adaptiveData (450, imgSize [0]));
  }

  popStyle ();
}
