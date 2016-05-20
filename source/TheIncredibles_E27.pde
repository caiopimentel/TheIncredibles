////////////////////////////
//////// The Incredibles: Visualization of a cinematic narrative - 2016/05/19
//////// Design: Caio Pimentel & Taís Fernandes
//////// Software Dev: Caio Pimentel
//////// Illustrations: Taís Fernandes
//////// Text: Hellen Jardim
//////// 
//////// More about the project: 
////////////////////////////


SrIncrivel [] srincrivel = new SrIncrivel [5];
AnimationSurvivalKit titleCalculator, subTitleCalculator, instructionCalculator, textCalculator;
PFont fontBook, fontLight;

color bgColor = color (90, 90, 150);
float [] focusPosition = new float[2];
float [] imgSize = new float[2];
float topLine, finalScale;
int leftLine, pick;
long lastTime, currentTime;
int limitTime = 200;
int lastButtonClicked = 0;

String [] textoMomentos;
String [] [] textoSecrets = new String [5][];
String [] [] tituloSecrets = new String [5][];


String [] [] buttonImages = {
  {"conceptSrIncrivel00_botao00.png", "conceptSrIncrivel00_botao01.png", "conceptSrIncrivel00_botao02.png", "conceptSrIncrivel00_botao03.png", "conceptSrIncrivel00_botoesAll.png"}, 
  {"conceptSrIncrivel01_botao00.png", "conceptSrIncrivel01_botao01.png", "conceptSrIncrivel01_botao02.png", "conceptSrIncrivel01_botao03.png", "conceptSrIncrivel01_botoesAll.png"}, 
  {"conceptSrIncrivel02_botao00.png", "conceptSrIncrivel02_botao01.png", "conceptSrIncrivel02_botao02.png", "conceptSrIncrivel02_botoesAll.png"}, 
  {"conceptSrIncrivel03_botao00.png", "conceptSrIncrivel03_botao01.png", "conceptSrIncrivel03_botao02.png", "conceptSrIncrivel03_botoesAll.png"}, 
  {"conceptSrIncrivel04_botao00.png", "conceptSrIncrivel04_botao01.png", "conceptSrIncrivel04_botao02.png", "conceptSrIncrivel04_botoesAll.png"}
};


void setup () {
  fullScreen ();
  frameRate (30);
  smooth ();
  background (bgColor);

  imgSize [0] = width * 0.175; // Largura das imagens dos personagens no layout inicial
  imgSize [1] = width * 0.296; // Altura das imagens dos personagens no layout inicial
  leftLine = width/21;
  topLine = (height/2) - (height/4.5);
  finalScale = (height)/imgSize [1]; // Após escala máxima da animação de seleção
  focusPosition [0] = (width/4) - (imgSize [0] * finalScale)/2; // Posição final x e y da animação de seleção
  focusPosition [1] = ((height/2) - (height/4)) - (height/3.8);

  for (int i = 0; i < srincrivel.length; i++) { // Inicializa os objetos que controlarão cada ilustração
    srincrivel [i]= new SrIncrivel (imgSize, leftLine + (imgSize [0] * i) + ((width/130) * i), topLine, focusPosition [0], focusPosition [1], finalScale);
  }

  for (int i = 0; i < srincrivel.length; i++) { // Carrega imagens respectivas a cada ilustração em seu objeto respectivo
    srincrivel [i].loadImages("conceptSrIncrivel0" + i + "_full.png", "conceptSrIncrivel0" + i + "_silhueta.png", "conceptSrIncrivel0" + i +"_mascara.png", buttonImages [i]);
  }

  titleCalculator = new AnimationSurvivalKit (0, 200); // Objetos usados para calcular a animação da opacidade dos textos
  subTitleCalculator = new AnimationSurvivalKit (0, 150);
  instructionCalculator = new AnimationSurvivalKit (0, 80);
  textCalculator = new AnimationSurvivalKit (0, 255);

  fontBook = createFont ("ITC Avant Garde Gothic LT Book_0.ttf", 14);
  fontLight = createFont ("ITC Avant Garde Gothic LT Extra Light_0.ttf", 14);

  textoMomentos = loadStrings ("sobreMomentos_en.txt"); // Carrega textos do layout geral

  for (int i = 0; i < textoSecrets.length; i++) { // Carrega textos do layout específico
    textoSecrets [i]  = loadStrings ("secretsMomento0" + i +  "_en.txt");
    tituloSecrets [i] = loadStrings ("secretsMomentoTitulo0" + i +  "_en.txt");
  }
}


void draw () {
  background (bgColor);
  
  updateInteractions ();
  animateMovement ();
  chooseSrIncrivel ();
  displayMaster ();
}
