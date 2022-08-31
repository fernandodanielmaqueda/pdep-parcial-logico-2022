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

puedeRealizarObjetivo(Persona, Objetivo):-
    objetivo(_, Objetivo, TipoDeObjetivo),
    puedeTrabajarEn(Persona, TipoDeObjetivo).

puedeTrabajarEn(Persona, Quimica):-
    persona(Persona),
    expertoEn(Persona, quimica),
    objetivo(_, _, Quimica),
    esUnProductoHechoMedianteProcesosQuimicos(Quimica).
puedeTrabajarEn(chrome, Material):-
    objetivo(_, _, Material),
    esUnMaterial(Material),
    not(seConsigueDeLosAnimales(Material)).
puedeTrabajarEn(Persona, material(animales)):-
    persona(Persona),
    seDedicaA(Persona, caza).
puedeTrabajarEn(suika, material(playa)).
puedeTrabajarEn(suika, material(bosque)).
puedeTrabajarEn(suika, quimica([mezclarIngredientes])).
puedeTrabajarEn(chrome, Quimica):-
    objetivo(_, _, Quimica),
    procesosQuimicosConQueEstaHecho(Quimica, ProcesosQuimicos),
    length(ProcesosQuimicos, CantidadDeProcesosQuimicos),
    CantidadDeProcesosQuimicos =< 3.
puedeTrabajarEn(Persona, Artesania):-
    persona(Persona),
    objetivo(_, _, Artesania),
    dificultadArtesania(Artesania, Dificultad),
    criterioDificultadArtesania(Persona, Dificultad).    

expertoEn(senku, quimica).

seDedicaA(kohaku, caza).

esUnMaterial(material(_)).

esUnProductoHechoMedianteProcesosQuimicos(quimica(_)).

dondeSeConsigueMaterial(material(DondeSeConsigue), DondeSeConsigue).

procesosQuimicosConQueEstaHecho(quimica(ProcesosQuimicos), ProcesosQuimicos).

dificultadArtesania(artesania(Dificultad), Dificultad).

seConsigueDeLosAnimales(material(animales)).

criterioDificultadArtesania(senku, Dificultad):-
    Dificultad =< 6.
criterioDificultadArtesania(Persona, Dificultad):-
    Persona \= senku,
    Dificultad < 3.

%% Punto 2

objetivoFinalDeUnProyecto(Proyecto, ObjetivoFinal):-
    objetivo(Proyecto, ObjetivoFinal, _),
    not(prerrequisito(ObjetivoFinal, _)).

%% Punto 3

esIndispensablePara(Persona, Objetivo):-
    objetivo(_, Objetivo, _),
    persona(Persona),
    puedeRealizarObjetivo(Persona, Objetivo),
    forall((persona(OtraPersona), Persona \= OtraPersona), not(puedeRealizarObjetivo(OtraPersona, Objetivo))).

%% Punto 4

puedeIniciarse(Objetivo):-
    estaPendiente(Objetivo),
    not((prerrequisito(Prerrequisito, Objetivo), estaPendiente(Prerrequisito))).

estaPendiente(Objetivo):-
    objetivo(_, Objetivo, _),
    not(conseguido(Objetivo)).

%% Punto 5

cuantoFaltaParaTerminar(Proyecto, TiempoFaltante):-
    objetivo(Proyecto, _, _),
    findall(TiempoEstimado, (objetivo(Proyecto, Objetivo, _), estaPendiente(Objetivo), tiempoEstimadoParaRealizarse(Objetivo, TiempoEstimado)), TiemposEstimados),
    sum_list(TiemposEstimados, TiempoFaltante).

tiempoEstimadoParaRealizarse(Objetivo, TiempoEstimado):-
    objetivo(_, Objetivo, TipoDeObjetivo),
    tiempoEstimadoSegunTipo(TipoDeObjetivo, TiempoEstimado).

tiempoEstimadoSegunTipo(Material, 3):-
    objetivo(_, _, Material),
    esUnMaterial(Material),
    seEncuentraEnLaSuperficie(Material).
tiempoEstimadoSegunTipo(material(mar), 8).
tiempoEstimadoSegunTipo(material(cueva), 48).
tiempoEstimadoSegunTipo(quimica(ProcesosQuimicos), TiempoEstimado):-
    length(ProcesosQuimicos, CantidadDeProcesosQuimicos),
    TiempoEstimado is 2 * CantidadDeProcesosQuimicos.
tiempoEstimadoSegunTipo(artesania(Dificultad), Dificultad).

seEncuentraEnLaSuperficie(Material):-
    not(dondeSeConsigueMaterial(Material, mar)),
    not(dondeSeConsigueMaterial(Material, cueva)).

%% Punto 6

esCriticoPara(Proyecto, Objetivo):-
    objetivo(Proyecto, Objetivo, _),
    objetivo(Proyecto, OtroObjetivo, _),
    Objetivo \= OtroObjetivo,
    bloqueaElAvanceDe(Objetivo, OtroObjetivo),
    esCostoso(OtroObjetivo).

bloqueaElAvanceDe(ObjetivoPrevio, ObjetivoSiguiente):-
    prerrequisito(ObjetivoPrevio, ObjetivoSiguiente).
bloqueaElAvanceDe(ObjetivoPrevio, ObjetivoSiguiente):-
    prerrequisito(ObjetivoPrevio, OtroObjetivo),
    bloqueaElAvanceDe(OtroObjetivo, ObjetivoSiguiente).

esCostoso(Objetivo):-
    tiempoEstimadoParaRealizarse(Objetivo, TiempoEstimado),
    TiempoEstimado > 5.

%% Punto 7

leConvieneTrabajarSobre(Persona, Objetivo, Proyecto):-
    persona(Persona),
    objetivo(Proyecto, Objetivo, _),
    puedeIniciarse(Objetivo),
    puedeRealizarObjetivo(Persona, Objetivo),
    esIdealPara(Persona, Objetivo, Proyecto).

esIdealPara(Persona, Objetivo, _):-
    esIndispensablePara(Persona, Objetivo).
esIdealPara(_, Objetivo, Proyecto):-
    tiempoEstimadoParaRealizarse(Objetivo, TiempoEstimado),
    cuantoFaltaParaTerminar(Proyecto, TiempoFaltante),
    TiempoEstimado > TiempoFaltante / 2.
esIdealPara(Persona, Objetivo, Proyecto):-
    forall((objetivo(Proyecto, OtroObjetivo, _), Objetivo \= OtroObjetivo, puedeIniciarse(OtroObjetivo)), puedeHacerloAlguienMas(Persona, OtroObjetivo)).

puedeHacerloAlguienMas(Persona, Objetivo):-
    persona(OtraPersona),
    Persona \= OtraPersona,
    puedeRealizarObjetivo(OtraPersona, Objetivo).