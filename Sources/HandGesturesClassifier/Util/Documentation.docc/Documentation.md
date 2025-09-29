# ``HandGesturesClassifier``

HandGesturesClassifier é um pacote Swift para detecção e classificação de gestos de mão em tempo real, utilizando Vision e um modelo Core ML pré-treinado. Ele identifica se a mão está aberta ou fechada e fornece o nível de confiança da predição, permitindo integração rápida em aplicações iOS sem a necessidade de treinar modelos personalizados.

## Overview

HandGesturesClassifier é um pacote Swift que fornece um modelo Core ML pré-treinado para classificação de poses de mão, integrado ao framework Vision da Apple para reconhecimento visual de gestos em tempo real.

O pacote permite que desenvolvedores iOS detectem e interpretem gestos manuais de forma eficiente, sem a necessidade de treinar um modelo do zero.

### Gestos suportados
Atualmente, o modelo reconhece dois gestos básicos:

•    Mão aberta

•    Mão fechada

### Fluxo de funcionamento

1.    Captura da mão usando a câmera do dispositivo.
2.    Detecção de pontos-chave da mão via VNDetectHumanHandPoseRequest do Vision.
3.    Processamento dos pontos pelo modelo Core ML (HandGestures6).
4.    Retorno do estado da mão (open, closed, background).

### Requisitos e compatibilidade
•    iOS 14 ou superior

•    Xcode 15 ou superior

•    Suporte a CPU e GPU para inferência do modelo
