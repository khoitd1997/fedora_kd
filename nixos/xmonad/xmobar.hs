Config
  { overrideRedirect = False,
    font = "xft:iosevka-9",
    bgColor = "#5f5f5f",
    fgColor = "#f8f8f2",
    position = TopW L 90,
    commands =
      [ Run
          Cpu
          [ "-L",
            "3",
            "-H",
            "50",
            "--high",
            "red",
            "--normal",
            "green"
          ]
          10,
        Run
          Alsa
          "default"
          "Master"
          [ "--template",
            "<volumestatus>",
            "--suffix",
            "True",
            "--",
            "--on",
            ""
          ],
        Run Memory ["--template", "Mem: <usedratio>%"] 10,
        Run Date "%a %Y-%m-%d <fc=#8be9fd>%H:%M</fc>" "date" 10,
        Run XMonadLog
      ],
    sepChar = "%",
    alignSep = "}{",
    template = "%XMonadLog% }{ %alsa:default:Master% | %cpu% | %memory% * %swap% | %EGPF% | %date% "
  }
