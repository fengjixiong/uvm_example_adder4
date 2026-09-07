# scripts/run.tcl
# UCLI 脚本用于控制仿真

proc run {} {
    run 100us
    quit
}

proc load_wave {} {
    # DVE 波形加载命令
    call \$vcdpluson
}
