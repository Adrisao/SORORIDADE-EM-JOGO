
const List<Map<String, dynamic>> quizzes = [

  // quiz 1
  {
    'numero': 1,
    'titulo': 'Lição 1 — O que é sororidade?',
    'tipoApresentacao': 'texto',
    'conteudo': '''
Sororidade é uma palavra que vem do latim "soror", que quer dizer irmã. Ela significa a união e o apoio entre meninas e mulheres. Ter sororidade é torcer pela colega, ajudar quem está com dificuldade e defender quem está sendo deixada de lado, em vez de competir ou fazer pouco caso. Isso não quer dizer que todas precisam ser amigas nem concordar em tudo. Quer dizer que, mesmo sendo diferentes, elas se respeitam e se ajudam. Na escola, a sororidade aparece em coisas simples: chamar para brincar quem está sozinha, emprestar o material, explicar a lição para quem não entendeu e não rir quando alguém erra.
''',
    'video': null,
    'perguntas': [
      {
        'enunciado': 'O que é sororidade?',
        'alternativas': [
          'Competição entre mulheres',
          'Apoio e solidariedade entre mulheres',
          'Evitar outras pessoas',
          'Tentar ser melhor que as outras',
        ],
        'respostaCorreta': 1,
      },
      {
        'enunciado': 'Qual atitude demonstra sororidade?',
        'alternativas': [
          'Ajudar uma colega que precisa',
          'Ignorar uma colega',
          'Fazer piada com um erro',
          'Excluir alguém',
        ],
        'respostaCorreta': 0,
      },
      {
        'enunciado': 'A sororidade está relacionada a qual palavra?',
        'alternativas': [
          'Respeito',
          'Disputa',
          'Exclusão',
          'Desprezo',
        ],
        'respostaCorreta': 0,
      },
    ],
  },


  // quiz 2
  {
    'numero': 2,
    'titulo': 'Lição 2 — Entendendo a empatia',
    'tipoApresentacao': 'video',
    'duracao': '1 a 2 minutos',
    'conteudo': null,
    'video': 'Sororidade_Video1_Licao1.mp4',
    'perguntas': [
      {
        'enunciado': 'O que significa ter empatia?',
        'alternativas': [
          'Tentar entender o que outra pessoa sente',
          'Ignorar os sentimentos dos outros',
          'Sempre querer ganhar',
          'Não ouvir ninguém',
        ],
        'respostaCorreta': 0,
      },
      {
        'enunciado': 'Uma colega está triste. O que você pode fazer?',
        'alternativas': [
          'Rir dela',
          'Perguntar se ela precisa de ajuda',
          'Ignorar',
          'Fazer uma brincadeira com o problema',
        ],
        'respostaCorreta': 1,
      },
      {
        'enunciado':
            'Verdadeiro ou falso: ouvir alguém com atenção é uma forma de demonstrar empatia.',
        'alternativas': [
          'Verdadeiro',
          'Falso',
          'Somente às vezes',
          'Não sei',
        ],
        'respostaCorreta': 0,
      },
    ],
  },

  // quiz 3
  {
    'numero': 3,
    'titulo': 'Lição 3 — Respeitando as diferenças',
    'tipoApresentacao': 'texto',
    'conteudo': '''
Cada pessoa é de um jeito. Tem gente que gosta de coisas diferentes, que pensa diferente e que vem de lugares diferentes. Respeitar as diferenças é aceitar que a colega pode não ser igual a você, e que está tudo bem com isso. Quando duas pessoas discordam, respeitar não é obrigar a outra a mudar de ideia nem parar de falar com ela. É conversar e ouvir o que ela tem a dizer. Incluir também faz parte do respeito: chamar para participar quem ficou de fora é um jeito de mostrar que todo mundo tem o seu lugar.
''',
    'video': null,
    'perguntas': [
      {
        'enunciado': 'O que significa respeitar uma pessoa?',
        'alternativas': [
          'Aceitar que ela pode ser diferente de você',
          'Obrigar a pessoa a pensar como você',
          'Rir das diferenças',
          'Excluir quem é diferente',
        ],
        'respostaCorreta': 0,
      },
      {
        'enunciado':
            'Duas colegas têm opiniões diferentes. O que elas podem fazer?',
        'alternativas': [
          'Brigar',
          'Conversar e ouvir uma à outra',
          'Parar de se falar',
          'Fazer piada',
        ],
        'respostaCorreta': 1,
      },
      {
        'enunciado':
            'Qual atitude ajuda a incluir uma colega em uma atividade?',
        'alternativas': [
          'Chamar a colega para participar',
          'Deixar a colega de fora',
          'Dizer que ela não pode participar',
          'Ignorá-la',
        ],
        'respostaCorreta': 0,
      },
    ],
  },

  // quiz 4
  {
    'numero': 4,
    'titulo': 'Lição 4 — Apoiar em vez de competir',
    'tipoApresentacao': 'jogo',
    'conteudo': '''
Jogo no formato do Duolingo sobre o tema "apoiar em vez de competir". A aluna arrasta várias atitudes para duas caixas: "apoia" e "compete". A cada acerto ela ganha pontos e a barra de progresso avança. As situações do jogo (como "parabenizar a colega que foi bem" ou "torcer para a colega errar") deixam a aluna treinar a diferença entre apoiar e competir antes de responder as questões.
''',
    'video': null,
    'perguntas': [
      {
        'enunciado':
            'Quando uma colega consegue fazer algo difícil, o que você pode fazer?',
        'alternativas': [
          'Parabenizá-la',
          'Ficar com raiva',
          'Dizer que não foi difícil',
          'Ignorá-la',
        ],
        'respostaCorreta': 0,
      },
      {
        'enunciado':
            'Uma colega está com dificuldade em uma atividade. Qual é uma boa atitude?',
        'alternativas': [
          'Ajudar se puder',
          'Dizer que ela não consegue',
          'Esconder o material',
          'Rir dela',
        ],
        'respostaCorreta': 0,
      },
      {
        'enunciado': 'Ajudar alguém significa que você perdeu uma competição?',
        'alternativas': [
          'Sim, sempre',
          'Não',
          'Somente na escola',
          'Depende da nota',
        ],
        'respostaCorreta': 1,
      },
    ],
  },

  // quiz 5
  {
    'numero': 5,
    'titulo': 'Lição 5 — Resolvendo conflitos com diálogo',
    'tipoApresentacao': 'video',
    'duracao': '1 a 2 minutos',
    'conteudo': '''
O vídeo mostra duas colegas que querem usar o mesmo material ao mesmo tempo e começam a discutir. Em vez de brigar, elas param, conversam e combinam de dividir o uso. A narração mostra o passo a passo: primeiro ouvir os dois lados, depois procurar uma solução em que as duas ganham. O vídeo reforça que conflito é normal e que o diálogo resolve melhor do que o grito.
''',
    'video': 'Sororidade_Video2_Licao2.mp4',
    'perguntas': [
      {
        'enunciado': 'O que podemos fazer quando acontece um conflito?',
        'alternativas': [
          'Conversar sobre o problema',
          'Gritar',
          'Ignorar para sempre',
          'Culpar alguém sem ouvir',
        ],
        'respostaCorreta': 0,
      },
      {
        'enunciado':
            'Duas colegas querem usar o mesmo material. O que elas podem fazer?',
        'alternativas': [
          'Brigar pelo material',
          'Conversar e dividir o uso',
          'Esconder o material',
          'Desistir da atividade',
        ],
        'respostaCorreta': 1,
      },
      {
        'enunciado':
            'Antes de decidir quem está certa em uma discussão, é importante:',
        'alternativas': [
          'Ouvir os dois lados',
          'Escolher uma pessoa rapidamente',
          'Ignorar o problema',
          'Culpar alguém',
        ],
        'respostaCorreta': 0,
      },
    ],
  },

  // quiz 6
  {
    'numero': 6,
    'titulo': 'Lição 6 — Pensar antes de agir',
    'tipoApresentacao': 'texto',
    'conteudo': '''
Antes de fazer alguma coisa, vale a pena parar e pensar no que vai acontecer depois. Muita escolha do dia a dia funciona assim: SE uma coisa acontece, ENTÃO você decide o que fazer. Por exemplo: SE uma colega pede ajuda, ENTÃO você pergunta como pode ajudar. SE alguém erra, ENTÃO você pode respeitar em vez de fazer piada. Pensar antes de agir ajuda a escolher a atitude certa e a não se arrepender depois. É o mesmo jeito de raciocinar que o computador usa quando segue uma regra: ele olha a situação e decide o próximo passo.
''',
    'video': null,
    'perguntas': [
      {
        'enunciado':
            'Se uma colega pedir ajuda, qual atitude pode ser tomada?',
        'alternativas': [
          'Perguntar como você pode ajudar',
          'Ignorar',
          'Rir',
          'Sair correndo',
        ],
        'respostaCorreta': 0,
      },
      {
        'enunciado':
            'Se uma colega cometer um erro, o que é melhor fazer?',
        'alternativas': [
          'Ajudar e respeitar',
          'Fazer piada',
          'Excluir a colega',
          'Contar o erro para todo mundo',
        ],
        'respostaCorreta': 0,
      },
      {
        'enunciado':
            'Se duas colegas estão discutindo, o que pode ajudar?',
        'alternativas': [
          'Incentivar a briga',
          'Ajudar a conversar com calma',
          'Escolher um lado sem ouvir',
          'Fazer piada',
        ],
        'respostaCorreta': 1,
      },
    ],
  },


  // quiz 7
  {
    'numero': 7,
    'titulo': 'Lição 7 — Missão final: juntas somos mais fortes',
    'tipoApresentacao': 'jogo',
    'conteudo': '''
Jogo final que junta tudo o que foi visto na trilha. A aluna conduz uma personagem que precisa ajudar as colegas para chegar ao fim do caminho, escolhendo a cada etapa a atitude certa (respeito, empatia, cooperação). A cada fase ela ganha pontos e conquista uma medalha ao terminar. É a revisão de tudo em forma de jogo, antes das últimas questões.
''',
    'video': 'Sororidade_Video3_Licao5.mp4',
    'perguntas': [
      {
        'enunciado':
            'Uma colega nova está sozinha durante uma atividade. O que você pode fazer?',
        'alternativas': [
          'Convidá-la para participar',
          'Ignorá-la',
          'Dizer que ela não pode participar',
          'Fazer uma brincadeira com ela',
        ],
        'respostaCorreta': 0,
      },
      {
        'enunciado':
            'Uma colega está com dificuldade e você também precisa terminar sua atividade. O que pode fazer?',
        'alternativas': [
          'Ajudar rapidamente e depois continuar sua atividade',
          'Ignorar sempre',
          'Fazer a atividade dela inteira',
          'Rir da dificuldade',
        ],
        'respostaCorreta': 0,
      },
      {
        'enunciado':
            'Qual opção reúne atitudes trabalhadas nesta trilha?',
        'alternativas': [
          'Respeito, empatia e cooperação',
          'Competição, exclusão e disputa',
          'Desrespeito e individualismo',
          'Ignorar e excluir',
        ],
        'respostaCorreta': 0,
      },
    ],
  },
];
