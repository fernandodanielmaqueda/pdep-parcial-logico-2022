/*
Nombre: Maqueda, Fernando Daniel
Legajo: 173.065-4
*/

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Código Inicial
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% objetivo(Proyecto, Objetivo, TipoDeObjetivo)
objetivo(higiene, almejas, material(playa)).
objetivo(higiene, algas, material(mar)).
objetivo(higiene, grasa, material(animales)).
objetivo(higiene, hidroxidoDeCalcio, quimica([hacerPolvo, diluirEnAgua])).
objetivo(higiene, hidroxidoDeSodio, quimica([mezclarIngredientes])).
objetivo(higiene, jabon, quimica([mezclarIngredientes, dejarSecar])).

% prerrequisito(ObjetivoPrevio, ObjetivoSiguiente)
prerrequisito(almejas, hidroxidoDeCalcio).
prerrequisito(hidroxidoDeCalcio, hidroxidoDeSodio).
prerrequisito(algas, hidroxidoDeSodio).
prerrequisito(hidroxidoDeSodio, jabon).
prerrequisito(grasa, jabon).

% conseguido(Objetivo)
conseguido(almejas).
conseguido(algas).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Punto 1

persona(senku).
persona(chrome).
persona(kohaku).
persona(suika).

expertoEn(senku, quimica).

puedeTrabajarEn(Persona, quimica(_)):-
    persona(Persona),
    expertoEn(Persona, quimica).

puedeConseguir(chrome, Material):-
    objetivo(_, _, Material),
    esUnMaterial(Material).

esUnMaterial(material(_)).
material(material(DondeSeConsigue), DondeSeConsigue).
esUnProductoHechoMedianteProcesosQuimicos(quimica(_)).
procesosQuimicos(quimica(ProcesosQuimicos), ProcesosQuimicos).

%% Punto 2

objetivoFinalDeUnProyecto(Proyecto, ObjetivoFinal):-
    objetivo(Proyecto, ObjetivoFinal, _),
    not(prerrequisito(ObjetivoFinal, _)).

%% Punto 3

esIndispensablePara(Persona, Objetivo):-
    objetivo(_, Objetivo, _),
    persona(Persona),
    persona(OtraPersona),
    Persona \= OtraPersona,
    puedeTrabajarEn(Persona, Objetivo),
    not(puedeTrabajarEn(OtraPersona, Objetivo)).

%% Punto 4

puedeIniciarse(Objetivo):-
    estaPendiente(Objetivo),
    not((prerrequisito(Prerrequisito, Objetivo), estaPendiente(Prerrequisito))).

estaPendiente(Objetivo):-
    objetivo(_, Objetivo, _),
    not(conseguido(Objetivo)).

%% Punto 5

cuantoFaltaParaTerminar(Proyecto, TiempoFaltante):-

    findall(TiempoEstimado, (), TiemposEstimados),
    sum_list(TiemposEstimados, TiempoFaltante).

%% Punto 6

esCriticoPara(Proyecto, Objetivo):-


%% Punto 7