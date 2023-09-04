[Acesso ao OpenPLC](https://pi-sed.duckdns.org:8080/)

# A Planta: Padaria Industrial

Tanque misturador e batedeira em uma padaria industrial.

* São utilizados dois dosadores volumétricos para pó, um para farinha e um para sal, onde cada um:
  * Possui um motor que aciona o disco do dosador.
  * Possui um e um sensor de rotação que indica a posição do disco dosador, gerando um pulso por porção.
  * Um sensor no reservatório, que indica se este está abastecido ou vazio.
* Uma válvula solenoide permite acionar a entrada de água no tanque.
* Três sensores de nível permitem medir a quantidade de água no tanque: Baixo, Médio e Alto.
* Um atuador pneumático permite abrir e fechar a tampa do tanque, acesso do alimentador de pó.
* Uma batedeira acionada por um motor.
* Uma válvula solenoide perite pressurizar o interior do tanque.
* Uma válvula solenoide permite descartar o conteúdo do tanque.
* Uma válvula permite liberar o conteúdo do tanque para a próxima etapa através de um bico dosador.
* Uma esteira move formas de pão na saída.
* Um sensor indica que há uma forma sob o bico dosador.
* Uma balança indica que a forma está cheia (peso correto).

# O Processo

Preparar massa, encher formas, lavar, repetir.

Preparando a receita:

1. Adicionar 10 porções de farinha e 2 de sal.
2. Adicionar água até o nível máximo.
3. Acionar a batedeira a partir do nível médio.
4. Bater por 1 minuto.

Enchendo as formas:

1. Acione a esteira até posicionar uma forma sob o bico injetor.
2. Com o tanque pressurizado acione a válvula de saída até completar o peso da forma, e avance para a próxima forma.
3. O sensor de nível inferior provavelmente estará sujo, e indicando incorreto, então se a forma não encher em 5 segundos considere que acabou a massa.

Limpeza do tanque:

1. Colocar água até a marca média.
2. Bater por 3 segundos.
3. Pressurizar e descartar a água até o sensor de nível baixo não detectar mais água.

# Restrições:

* Somente é possível adicionar pó com a tampa aberta.
* Somente é possível pressurizar o tanque com a tampa fechada.
* Somente é possível adicionar água com o tanque despressurizado.
* Somente é possível encher formas com o tanque pressurizado.
* Abrir ou fechar a tampa do tanque demora em torno de 3 segundos.
* Se terminarem farinha ou sal, o processo deve esperar o abastecimento.

# Plataforma de Emulação

A padaria está sendo emulado em FPGA, e conectado à uma Raspberry PI com OpenPLC. Abaixo uma demonstração da operação manual da plataforma.

[Vídeo](https://youtu.be/FKkZEzmhEWk)

# Mapeamento de Portas

| Sina na planta | Ativo (1) | Inativo (0) | Planta(FPGA) |  | PLC(Pi) |
|----------------|-----------|-------------|--------------|--|---------|
| Válvula de entrada de água | Abrir | Fechar | X_water | ← | QX0.0 |
| Válvula dreno | Abrir | Fechar | X_drain | ← | QX0.1 |
| Acionamento tampa | Fechar | Abrir | X_cover | ← | QX0.2 |
| Pressurizador | Pressurizar | Despressurizar | X_pressurize | ← | QX0.3 |
| Misturador | Ligar | Desligar | X_mixer | ← | QX0.4 |
| Dosador de Farinha | Ligar | Desligar | X_flour | ← | QX1.2 |
| Dosador de Sal | Ligar | Desligar | X_salt | ← | QX0.6 |
| Esteira de formas | Ligar | Desligar | X_pan_conveyor | ← | QX1.1 |
| Dispenser de massa | Abrir | Fechar | X_dispenser | ← | QX1.0 |
| Sensor de nível na base | Água | Ar | Y_water_base | → | IX0.0 |
| Sensor de nível no meio | Água | Ar | Y_water_middle | → | IX0.1 |
| Sensor de nível no topo | Água | Ar | Y_water_top | → | IX0.2 |
| Realimentação dosador de farinha | Fechado | Dosando | Y_flour | → | IX0.3 |
| Sensor Reservatório de farinha | OK | Vazio | Y_flour_remain | → | IX0.4 |
| Realimentação dosador de sal | Fechado | Dosando | Y_salt | → | IX0.5 |
| Sensor Reservatório de sal | OK | Vazio | Y_salt_remain | → | IX1.2 |
| Sensor de forma sob o dispenser | Presente | Ausente | Y_pan | → | IX1.1 |
| Sensor de peso da forma | Cheio | Vazio | Y_pan_full | → | IX1.0 |

# Links:

* Dosador volumétrico para grãos e pó: [link](https://youtu.be/9005S6I3AZc).
* Válvula solenoide: [link](https://www.youtube.com/watch?v=-MLGr1_Fw0c)
