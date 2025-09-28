//
//  HandPosesEnum.swift
//  Handy
//
//  Created by Breno Marques on 28/09/25.
//

import Foundation

/**
 Comtempla todos os possíveis casos de gestos de mão
 treinados pelo modelo no createML.
 */
public enum HandPoses: String {
    /**
     Caso de mão aberta.
     */
    case open = "aberta"
    
    /**
     Caso de mão fechada.
     */
    case closed = "fechada"
    
    /**
     Qualquer outro caso que não se encaixe com os dois principais.
    */
    case background = "Background"
}
