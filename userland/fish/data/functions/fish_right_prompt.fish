function fish_right_prompt -d "Write out the right prompt"
    printf (__color_dim)(date +"[%H:%M]"(__color_off))
end
