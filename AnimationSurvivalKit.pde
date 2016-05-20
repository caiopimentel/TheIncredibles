/* AnimationSurvivalKit é uma classe calculadora basica para animação, inicialmente calculava somente a posição de pontos ao longo de uma linha reta,
 dado o seu xy inicial e final, esta podendo estar em qualquer ângulo, para se animar algo se movendo ao longo dela.
 Foi expandida nesse projeto e agora calcula com easing out escala e opacidade também. 
 É uma ferramenta pessoal com fins de estudo em continua construção. */

class AnimationSurvivalKit 
{
  private float lineSegment [] = new float[4];
  private float moduleSum [] = {0, 0};
  private float scaleInicial = 1;
  private float scale = scaleInicial;
  private float lineResolution, easing, positionX, positionY, targetXFinal, targetYFinal, 
    targetXInicial, targetYInicial, scaleFinal, opacityFinal;
  private float opacityInicial = 0;
  private float opacity = opacityInicial;

  public AnimationSurvivalKit (float lineSegmentX1_, float lineSegmentY1_, float lineSegmentX2_, float lineSegmentY2_, 
    float scaleFinal_, float opacityFinal_)
  { // Constructor a ser usado quando se deseja animar posição, escala e opacidade
  
    // Determina o X e Y dos dois pontos que formam o segmento de linha
    lineSegment [0] = lineSegmentX1_;
    lineSegment [1] = lineSegmentY1_;
    lineSegment [2] = lineSegmentX2_;
    lineSegment [3] = lineSegmentY2_;

    targetXInicial = lineSegment [0];
    targetYInicial = lineSegment [1];
    positionX = targetXInicial;
    positionY = targetYInicial;


    scaleFinal = scaleFinal_;
    opacityFinal = opacityFinal_;
  }

  public AnimationSurvivalKit (float lineSegmentX1_, float lineSegmentY1_, float lineSegmentX2_, float lineSegmentY2_)
  { // Constructor a ser usado quando se deseja animar somente posição
  
    // Determina o X e Y dos dois pontos que formam o segmento de linha
    lineSegment [0] = lineSegmentX1_;
    lineSegment [1] = lineSegmentY1_;
    lineSegment [2] = lineSegmentX2_;
    lineSegment [3] = lineSegmentY2_;

    targetXInicial = lineSegment [0];
    targetYInicial = lineSegment [1];
    positionX = targetXInicial;
    positionY = targetYInicial;
  }

  public AnimationSurvivalKit (float scaleFinal_, float opacityFinal_)
  { // Constructor a ser usado quando se deseja animar somente escala e/ou opacidade
    scaleFinal = scaleFinal_;
    opacityFinal = opacityFinal_;
  }


  public float [] animateAlongLine (boolean easing_, float denominator_, boolean reverse_, float percentage_) 
  {
    // Responsavel por calcular a posicao de um ponto ao longo da linha com o passar to tempo. 
    // easing_ == True, ativa a animação com easing out, False, ativa a animação sem easing
    // percentage_: Recebe a porcentagem da linha que será usada nos calculos de posição (100 é 100% da linha/50 é 50% da linha, etc.)
    // Obs: Nos arrays index 0 == x value, index 1 == y value.

    float vectorAverage [] = new float[2];
    // Calcula o vetor da linha proporcional ao valor percentage_, em relação a linha inteira
    vectorAverage [0] = map (percentage_, 0, 100, 0, (lineSegment [0] - lineSegment [2])); 
    vectorAverage [1] = map (percentage_, 0, 100, 0, (lineSegment [1] - lineSegment [3]));
    targetXFinal = (lineSegment [0] + (vectorAverage [0] * -1));
    targetYFinal = (lineSegment [1] + (vectorAverage [1] * -1));


    if (easing_)
    { // Animação com easing out
      if ((1/denominator_) > 0 && (1/denominator_) < 1) { /* PARA ANIMAÇÕES COM EASING. 
       Se a animação não tiver easing DEVE-SE iniciar o objeto com 0 nesse parametro.
       Controla a velocidade da animação com easing. */
       
        easing = 1/denominator_;
      } else {
        easing = 0;
      }

      if (reverse_) { // True no reverse_ para inverter o sentido da animacao ao longo da linha
        if (dist (targetXInicial, targetXInicial, positionX, positionY) < 0.1) { // Se a position estiver muito próxima do target ela para de calcular vira o target.
          positionX = targetXInicial;
          positionY = targetYInicial;
        } else {
          positionX += (targetXInicial - positionX) * easing;
          positionY += (targetYInicial - positionY) * easing;
        }
      } else {
        if (dist (targetXFinal, targetYFinal, positionX, positionY) < 0.1) { // Se a position estiver muito próxima do target ela para de calcular vira o target.
          positionX = targetXFinal;
          positionY = targetYFinal;
        } else {
          positionX += (targetXFinal - positionX) * easing;
          positionY += (targetYFinal - positionY) * easing;
        }
      }
    } else 
    { // Animação sem easing out

      lineResolution = (1/denominator_); /* PARA ANIMAÇÕES SEM EASING. 
       Se a animação tiver easing pode iniciar o objeto com 0 nesse parametro.
       Controla a velocidade da animação sem easing. Determina o número de pontos 
       monoespaçados que serão calculados ao longo da linha 
       (não são usados na animação com easing). */

      // Calcula um modulo, uma parcela, do vetor total. OBS: -1 é usado para as coordenadas seguirem sobre a linha e não para a outra direção
      float vectorModule [] = {(vectorAverage [0] * lineResolution * -1), (vectorAverage [1] * lineResolution * -1)};

      // Só continua o calculo do ponto se sua posição no eixo X não tiver ultrapassado a do fim da linha da average
      if (abs (moduleSum [0]) < abs (vectorAverage [0])) { 
        moduleSum [0] = moduleSum [0] + vectorModule [0];
      }

      // Só continua o calculo do ponto se sua posição no eixo Y não tiver ultrapassado a do fim da linha da average
      if (abs (moduleSum [1]) < abs (vectorAverage [1])) { 
        moduleSum [1] = moduleSum [1] + vectorModule [1];
      }
    }


    float pointOutput [] = new float[2];

    if (easing_) {
      pointOutput [0] = positionX;
      pointOutput [1] = positionY;
    } else {
      pointOutput [0] = lineSegment [0] + moduleSum [0];
      pointOutput [1] = lineSegment [1] + moduleSum [1];
    }

    return pointOutput;
  }


  public float [] putAlongLine (float percentage_) 
  { /* Responsavel por calcular a posicao de um ponto ao longo da linha, 
   tendo como base em que porcentagem do comprimento da linha ele estará */

    float vectorAverage [] = new float[2];
    // Calcula o vetor da linha proporcional ao valor percentage_, em relação a linha inteira
    vectorAverage [0] = map (percentage_, 0, 100, 0, (lineSegment [0] - lineSegment [2])); 
    vectorAverage [1] = map (percentage_, 0, 100, 0, (lineSegment [1] - lineSegment [3]));

    float pointOutput [] = {lineSegment [0] + (vectorAverage [0] * -1), lineSegment [1] + (vectorAverage [1] * -1)};
    return pointOutput;
  }


  public void displayLine (int strokeWeightIn, color colorIn) 
  { // Desenha a linha sobre qual a animação ocorre
    stroke (colorIn);
    strokeWeight (strokeWeightIn);
    line (lineSegment [0], lineSegment [1], lineSegment [2], lineSegment [3]);
  }


  public float animateScale (float denominator_, boolean reverse_) 
  { /* Calcula o scale com easing out. Com o reverse_ desligado (false),
   o calculo é crescente, com o reverse_ ligado isso se inverte. */

    if (scale <= scaleFinal && reverse_) { // Scale DOWN
      if ((scaleInicial - scale) > -0.001) {
        scale = scaleInicial;
      } else {
        scale += (scaleInicial - scale) * 1/denominator_;
      }
    } else if (scale >= scaleInicial && !reverse_) { // Scale UP
      if ((scaleFinal - scale) < 0.001) { 
        scale = scaleFinal;
      } else {
        scale += (scaleFinal - scale) * 1/denominator_;
      }
    }

    return scale;
  }


  public float animateOpacity (float denominator_, boolean reverse_) 
  { /* Calcula a opacity com easing out. Com o reverse_ desligado (false), 
   o calculo é crescente, com o reverse_ ligado isso se inverte. */

    if (opacity <= opacityFinal && reverse_) { // FADE OUT
      if ((opacityInicial - opacity) > -1) { 
        opacity = opacityInicial;
      } else {
        opacity += (opacityInicial - opacity) * 1/denominator_;
      }
    } else if (opacity >= opacityInicial && !reverse_) { // FADE IN
      if ((opacityFinal - opacity) < 1) { 
        opacity = opacityFinal;
      } else {
        opacity += (opacityFinal - opacity) * 1/denominator_;
      }
    }

    return opacity;
  }
}